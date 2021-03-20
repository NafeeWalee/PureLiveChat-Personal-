import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pure_live_chat/authentication/model/errorModel.dart';
import 'package:pure_live_chat/authentication/model/sessionModel.dart';
import 'package:pure_live_chat/authentication/model/userModel.dart';
import 'package:pure_live_chat/authentication/repo/groupRepo.dart';
import 'package:pure_live_chat/authentication/repo/userRepo.dart';
import 'package:pure_live_chat/authentication/view/loginPage.dart';
import 'package:pure_live_chat/authentication/view_model/userDataController.dart';
import 'package:pure_live_chat/main_app/homePage/view/homePage.dart';
class AuthRepo extends GetxController {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  Logger logger = Logger();
  GetStorage localStorage = GetStorage();
  UserDataController userDataController = Get.find();

  createUser({required String name, required String email,required String password, File? userPhoto, required String userType, String? loginType}) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      try {
        Reference? ref = storage.ref().child("user/${user.user!.uid}");
        UploadTask? uploadTask = ref.putFile(userPhoto!);
        TaskSnapshot? res = await uploadTask;
        var photoURL = await res.ref.getDownloadURL();
        try {
          await addUserToDatabase(name, email, photoURL, userType, loginType, user.user!.uid);
        } on FirebaseAuthException catch (e) {
          //Error on saving data to database
          logger.i(e.message);
          return e.message;
        }
      } on FirebaseAuthException catch (e) {
        //Error on uploading picture to storage
        logger.i(e.message);
        return e.message;
      }
    } on FirebaseAuthException catch (e) {
      //Error on existing account of same email
      logger.i(e.message);
      return e.message;
    }
  }

  addUserToDatabase(name, email, userPhoto, userType, loginType, userID) async {
    try {
      DateTime staticTime = DateTime(2020, 1, 1, 12, 1, 1, 1, 1);
      Timestamp timestamp = Timestamp.fromDate(staticTime);

      var data = UserModel(
        userID: userID,
        userGroupID: '',
        userName: name,
        email: email,
        userPhoto: userPhoto,
        address: '',
        phoneNumber: '',
        userType: userType,
        userLoginType: loginType,
        checkInData: [],
        lastCheckIn: timestamp,
        facebookID: '',
        instagramID: '',
      );
      try {
        await UserProfileDataRepository().addNewUser(data);
      } on FirebaseAuthException catch (e) {
        // Error on adding data to firebase
        logger.i(e.message);
        return e.message;
      }
    } on FirebaseAuthException catch (e) {
      //Error on model class
      logger.i(e.message);
      return e.message;
    }
  }

  login(String email, String password,bool rememberMe) async {
    String userLoginType = 'regular';

    try {
      UserCredential isSuccess = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      print('Successfully logged in $isSuccess');

      if (!isSuccess.isBlank!) {
        await UserProfileDataRepository().getUserData(email, userLoginType,rememberMe);
        loginNavigation();
        return null;
      }
    } on FirebaseAuthException catch (eLogin) {
      // Error logging in
      var data = ErrorModel(
        message: '${eLogin.message} [Email: $email]',
        timestamp: Timestamp.now(),
      );
      try {
        await UserProfileDataRepository().loginFailed(data);
        logger.i(eLogin.message);
        return eLogin.message;
      } on FirebaseAuthException catch (eErrorData) {
        // Error on adding error data
        logger.i(eErrorData.message);
        return eErrorData.message;
      }
    }
  }

  signOut() async {
    try {
      _auth.signOut();
      localStorage.remove('userValues');
      Get.offAll(()=>LoginPage());
    } catch (e) {
      Get.snackbar(
        "Error signing out",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


  //TODO add types
  sessionNavigation(String userLoginType) {
    print(userDataController.userData.value!.userLoginType);
    UserSessionModel value = userDataController.sessionData.value!;
    getData(email: value.email, groupID: value.userGroupID, userType: value.userType, userLoginType: value.userLoginType);
    if(value.userType == 'member'){
      // Get.offAll(MemberHomeScreen());
    }else{
      //  Get.offAll(AdminHomeScreen());
    }
  }

  loginNavigation() async{
    UserModel value = userDataController.userData.value!;
    await getData(email: value.email, groupID: value.userGroupID, userType: value.userType, userLoginType: value.userLoginType);
    if(value.userType == 'member'){
    //  Get.offAll(MemberHomeScreen());
    }else{
     // Get.offAll(AdminHomeScreen());
    }
    Get.offAll(()=>HomePage());
  }

  getData({email,groupID,userType,userLoginType}) async {
    await UserProfileDataRepository().listenToUserData(email,userLoginType);
    if(groupID != null){
      await RepoGroupMembers().getGroupData(groupID);
      if(userType == 'admin'){
        await RepoGroupMembers().listenToCheckInData();
      }
    }
  }

}
