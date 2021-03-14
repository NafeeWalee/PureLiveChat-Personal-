import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pure_live_chat/authentication/view/loginPage.dart';
class InitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  child: Text('Video Room'),
                  style: TextButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Get.to(()=>LoginPage());
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
