import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pure_live_chat/main_app/utils/controller/sizeConfig.dart';
import 'package:get/get.dart';
import 'package:pure_live_chat/users/Screens/homePage.dart';

void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv().load('.env');
  await GetStorage.init();
  await Firebase.initializeApp();
  Get.put(GetSizeConfig());
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
