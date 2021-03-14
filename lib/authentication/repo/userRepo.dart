import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:pure_live_chat/authentication/model/errorModel.dart';
import 'package:pure_live_chat/authentication/model/sessionModel.dart';
import 'package:pure_live_chat/authentication/model/userModel.dart';
import 'package:pure_live_chat/authentication/repo/groupRepo.dart';
import 'package:pure_live_chat/authentication/view_model/userDataController.dart';


class UserProfileDataRepository{
  var logger = Logger();

  UserModel userModel = UserModel();
  GetStorage localStorage = GetStorage();

  RepoGroupMembers repoGroupMembers = RepoGroupMembers();
  UserDataController userDataController = Get.find();

  CollectionReference user = FirebaseFirestore.instance.collection('User');
  CollectionReference group = FirebaseFirestore.instance.collection('Groups');
  CollectionReference loginErrors = FirebaseFirestore.instance.collection('LoginErrors');
  CollectionReference checkInErrors = FirebaseFirestore.instance.collection('checkInErrors');

  checkCode(String result) async {
    DocumentSnapshot documentSnapshot = await group.doc(userDataController.userData.value!.userGroupID).get();
    if(documentSnapshot.data()!['groupCode'] == result){
      return true;
    }else{
      return false;
    }
  }

  userCheckIn(userID,timestamp) async {
    try{
      user.doc(userID).update({'checkInData' : FieldValue.arrayUnion([timestamp]),'lastCheckIn': timestamp});
    }catch(e){
      logger.i(e);
      return e;
    }
  }

  addNewUser(UserModel data) async {
    try{
      await user.doc(data.userID).set(data.toJson());
    }catch(e){
      logger.i(e);
      return e;
    }
  }

  loginFailed(ErrorModel data) async {
    try{
      await loginErrors.add(data.toJson()).then((value) => logger.i(value)).catchError((e){logger.e(e);});
    }catch(e){
      logger.i(e);
      return e;
    }
  }

  logCheckInFailed(String qrCode) async {
    try{
      await checkInErrors.add({
        'userId': '${userDataController.userData.value!.userID}',
        'userName': '${userDataController.userData.value!.userName}',
        'message': qrCode != null? 'No QR code scanned' : 'Wrong QR code > $qrCode',
        'timeStamp': Timestamp.now()
      });
    }catch(e){
      logger.i(e);
      return e;
    }
  }

  checkExistingFacebookEmail(email,userLoginType) async {
    Query query = user.where('email',isEqualTo: email).where('userLoginType',isEqualTo: userLoginType);
    QuerySnapshot querySnapshot = await query.get();
    if(querySnapshot.docs.isEmpty){
      return null;
    }else{
      return 'facebook account available';
    }
  }

  updateUserData(UserModel data) async {
    try{
      await user.doc(data.userID).update(data.toJson());

      bool session = localStorage.hasData('userValues');

      if(session){
        updateSession();
      }

    }catch(e){
      logger.i(e);
      return e;
    }
  }

  getUserData(email,userLoginType,rememberMe) async{
    Query query = user.where('email',isEqualTo: email).where('userLoginType',isEqualTo: userLoginType);
    QuerySnapshot querySnapshot = await query.get();
    if(querySnapshot.docs.isEmpty){
      return null;
    }else{

      QuerySnapshot querySnapshot2 = await user.where('email',isEqualTo: email).where('userLoginType',isEqualTo: userLoginType).get();
      userDataController.userData.value = UserModel.fromJson(querySnapshot2.docChanges[0].doc.data()!);

      if(userDataController.userData.value!.userGroupID != ''){
        repoGroupMembers.getGroupData(userDataController.userData.value!.userGroupID);
      }

      if(rememberMe){
        updateSessionModel();
        updateSession();
      }
      return 'user Found';
    }
  }

  listenToUserData(email,userLoginType){
    print('listenToUserData');
    user.where('email',isEqualTo: email).where('userLoginType',isEqualTo: userLoginType).snapshots().listen((value) {
      userDataController.userData.value = UserModel.fromJson(value.docChanges[0].doc.data()!);
      print('listening to user model...');
    });
  }

  updateSessionModel(){
    var sessionData =  UserSessionModel(
        email: userDataController.userData.value!.email,
        userLoginType:  userDataController.userData.value!.userLoginType,
        userType:  userDataController.userData.value!.userType,
        userGroupID: userDataController.userData.value!.userGroupID
    );
    userDataController.sessionData.value = sessionData;
  }

  updateSession(){
    print('updating cookies...');
    localStorage.write('userValues',userDataController.sessionData.value);
    print(localStorage.read('userValues'));
  }
}