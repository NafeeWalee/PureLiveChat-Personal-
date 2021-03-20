import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pure_live_chat/authentication/model/userModel.dart';
import 'package:pure_live_chat/authentication/view_model/userDataController.dart';
class GetAllUsers{
  final CollectionReference user = FirebaseFirestore.instance.collection('User');
  final UserDataController userDataController = Get.find();

  getUngroupedMembers() async {
    userDataController.getAllMembers.clear();
    QuerySnapshot querySnapshot = await user.where('userGroupID', isEqualTo: "").get();

    querySnapshot.docs.forEach((element) {
      userDataController.getAllMembers.add(UserModel.fromJson(element.data()!));
    });
  }
}