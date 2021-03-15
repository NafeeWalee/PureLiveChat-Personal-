import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pure_live_chat/authentication/view_model/userDataController.dart';
import 'package:pure_live_chat/fcm/fcm_initalize.dart';
import 'package:pure_live_chat/main_app/homePage/view/homePage.dart';
import 'package:pure_live_chat/utility/controller/sizeConfig.dart';



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
            color: Colors.deepPurple,
            centerTitle: false,
            iconTheme: IconThemeData(color: Colors.black),
          )),

      home: HomePage(),
    ),
  );
}
