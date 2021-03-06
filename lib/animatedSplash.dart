
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:pure_live_chat/authentication/model/userModel.dart';
import 'package:pure_live_chat/authentication/repo/authRepo.dart';
import 'package:pure_live_chat/authentication/view/loginPage.dart';
import 'package:pure_live_chat/authentication/view_model/userDataController.dart';
import 'package:pure_live_chat/main_app/homePage/view/homePage.dart';
import 'package:pure_live_chat/utility/controller/sizeConfig.dart';
import 'package:pure_live_chat/utility/resources/appConst.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get_storage/get_storage.dart';

// ignore: must_be_immutable
class AnimatedSplash extends StatelessWidget {
  final GetSizeConfig sizeConfig = Get.find();
  final AuthRepo authRepo = Get.find();
  final GetStorage localStorage = GetStorage();
  final UserDataController userDataController = Get.find();
  double? width;
  double? height;
  bool isLoggedIn = false;
  bool checkingSession = true; // to insure running checking session method one time only
  bool initSize = true; // to insure running checking session method one time only

  setInitialScreenSize() {
    if(initSize){
      initSize = false;
      sizeConfig.setSize(
        (Get.width -
            (Get.mediaQuery.padding.left + Get.mediaQuery.padding.right)) /
            1000,
        (Get.height -
            (Get.mediaQuery.padding.top + Get.mediaQuery.padding.bottom)) /
            1000,
      );
      width = sizeConfig.width.value;
      height = sizeConfig.height.value;
    }
  }
  checkSession() {
    if(checkingSession){
      checkingSession = false;
      print('Checking session...');
      print(localStorage.read('userValues'));
      bool session = localStorage.hasData('userValues');
      if (session) {
        userDataController.userData.value = UserModel.fromJson(localStorage.read('userValues'));
        authRepo.sessionNavigation(userDataController.userData.value!.userLoginType!);
        isLoggedIn = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkSession();
    setInitialScreenSize();
    return AnimatedSplashScreen(
        splashIconSize: 240,
        duration: 3000,
        splash: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Color(0xffE8AA4F), Color(0xffED5369)]),
                  color: Colors.white,
                ),
                child: Container(
                    width: 120,
                    height: 120,
                    padding: EdgeInsets.all(16),
                    child: AppConst.icon),
              ),
              FutureBuilder(
                future: Future.delayed(Duration(seconds: 1)),
                builder: (c, s) =>  SizedBox(
                  height: 110.0,
                  child: ColorizeAnimatedTextKit(
                    speed: Duration(milliseconds: 700),
                    pause: Duration(milliseconds: 200),
                    onTap: () {
                      print("Tap Event");
                    },
                    text: [
                      "PureChat",
                    ],
                    textStyle: TextStyle(
                        fontSize: 50.0, fontFamily: "Pacifico-Regular"),
                    colors: [
                      Colors.white,
                      Colors.red,
                      Colors.yellow,
                    ],
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ],
          ),
        ),
        nextScreen: isLoggedIn?HomePage():LoginPage(),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.leftToRightWithFade,
        backgroundColor: Colors.black);
  }
}
