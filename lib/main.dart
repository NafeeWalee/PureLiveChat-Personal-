import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pure_live_chat/authentication/view_model/userDataController.dart';
import 'package:pure_live_chat/fcm/fcm_initalize.dart';
import 'package:pure_live_chat/main_app/homePage/view/homePage.dart';
import 'package:pure_live_chat/utility/controller/sizeConfig.dart';
import 'package:pure_live_chat/utility/resources/appConst.dart';
import 'package:pure_live_chat/utility/widgets/gradientButton.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FCM.initializeFCM();
  await GetStorage.init();
  await load();

  Get.put(GetSizeConfig());
  Get.put(UserDataController());
  runApp(
    GetMaterialApp(
      title: 'Pure International',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.zoom,
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.black,
          fontFamily: 'PermanentMarker-Regular',
          appBarTheme: AppBarTheme(
            elevation: 0,
            color: AppConst.themePurple,
            centerTitle: false,
            iconTheme: IconThemeData(color: Colors.black),
          )),
      home: AnimatedSplashScreen(
          splashIconSize: 240,
          duration: 3000,
          splash: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
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
                          "SnacksKitty",
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
          nextScreen: HomePage(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.leftToRightWithFade,
          backgroundColor: Colors.deepPurple),
    ),
  );
}
