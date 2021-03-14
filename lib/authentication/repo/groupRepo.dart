import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pure_live_chat/authentication/model/activeModel.dart';
import 'package:pure_live_chat/authentication/model/groupModel.dart';
import 'package:pure_live_chat/authentication/model/userModel.dart';
import 'package:pure_live_chat/authentication/view_model/userDataController.dart';
import 'package:pure_live_chat/utility/resources/appConst.dart';

class RepoGroupMembers {
  Logger logger = Logger();

  UserDataController userDataController = Get.find();
  final CollectionReference group =
  FirebaseFirestore.instance.collection('Groups');
  final CollectionReference user =
  FirebaseFirestore.instance.collection('User');

  getGroupMemberData() async {
    userDataController.groupMemberData.clear();
    QuerySnapshot querySnapshot = await user.where(
        'userGroupID',
        isEqualTo: userDataController.userData.value!.userGroupID
    ).get();
    querySnapshot.docs.forEach((element) {
      userDataController.groupMemberData.add(UserModel.fromJson(element.data()!));
    });
  }

  getUngroupedMembers() async {
    userDataController.ungroupMemberData.clear();
    QuerySnapshot querySnapshot = await user.where('userGroupID', isEqualTo: "").get();

    querySnapshot.docs.forEach((element) {
      userDataController.ungroupMemberData.add(UserModel.fromJson(element.data()!));
    });
  }

  getGroupData(groupID) async {
    DocumentSnapshot documentSnapshot = await group.doc(groupID).get();
    userDataController.groupData.value = GroupModel.fromJson(documentSnapshot.data()!);
    try{
      String valueString = userDataController.groupData.value!.theme!.split('(0x')[1].split(')')[0];
      int value = int.parse(valueString, radix: 16);
      Color themeColor = new Color(value);
      Get.changeTheme(ThemeData(primaryColor: themeColor));
    }catch(e){
      Get.changeTheme(ThemeData(primaryColor: AppConst.blue));
    }
  }


  addToGroup(memberID,groupID) async{
    try{
      await group.doc(groupID).update({'members' : FieldValue.arrayUnion([memberID])});
      await user.doc(memberID).update({'userGroupID' : groupID});
      return null;
    }catch(e){
      logger.i(e);
      return e.toString();
    }
  }

  getUserByEmail(userEmail,groupID) async {
    try{
      QuerySnapshot querySnapshot = await user.where('email', isEqualTo: userEmail).get();
      if(!querySnapshot.isBlank!){
        var memberID = querySnapshot.docs[0].data();
        await addToGroup(memberID!['userID'],groupID);
      }
      return null;
    }catch(e){
      logger.i(e);
      return e.toString();
    }

  }

  listenToCheckInData(){
    print('here on function');
    for(var data in userDataController.groupMemberData){
      user.where('userGroupID',isEqualTo: data.userGroupID).snapshots().listen((value) {
        userDataController.checkInData.value = CheckInModel.fromJson(value.docChanges[0].doc.data()!['lastCheckIn']);
        print('listening to checkIn model...');
      });
    }
  }
}