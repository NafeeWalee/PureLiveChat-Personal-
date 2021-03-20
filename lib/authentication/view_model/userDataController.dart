import 'package:get/get.dart';
import 'package:pure_live_chat/authentication/model/activeModel.dart';
import 'package:pure_live_chat/authentication/model/groupModel.dart';
import 'package:pure_live_chat/authentication/model/sessionModel.dart';
import 'package:pure_live_chat/authentication/model/userModel.dart';

class UserDataController extends GetxController{
  var userData = UserModel().obs;
  var groupData = GroupModel().obs;
  var sessionData = UserSessionModel().obs;
  var checkInData = CheckInModel().obs;
  // RxList<dynamic> groupMemberData =[].obs;
  var groupMemberData =<UserModel>[].obs;
  // RxList<UserModel> ungroupMemberData =[].obs;
  var ungroupMemberData =<UserModel>[].obs;
  var getAllMembers =<UserModel>[].obs;
  var tabIndex = 0.obs;

}