import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pure_live_chat/Utils/controller/sizeConfig.dart';
import 'package:pure_live_chat/src/Screens/homePage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  runApp(InitiateApp());
}


class InitiateApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Get.put(GetSizeConfig());

    return GetMaterialApp(
      title: 'Pure International',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.zoom,
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'PermanentMarker-Regular',
          appBarTheme: AppBarTheme(
              elevation: 0,
              color: Colors.deepPurple,
              centerTitle: false,
              iconTheme: IconThemeData(
                  color: Colors.black
              ),

          )
      ),
      home: HomePage(),
    );
  }
}

