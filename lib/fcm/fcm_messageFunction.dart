import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pure_live_chat/fcm/fcm_localNotification.dart';
import 'package:pure_live_chat/fcm/fcm_notificationDataModel.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

class FCMMessageFunction {
  static fcmMessageFunction() {
    print("Initializing local notification...");
    FCMLocalNotification.localInit();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    firebaseOnMessage();
    firebaseOnMessageOpenedApp();
  }

  static firebaseOnMessage(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage data: ${message.data}');
      showDialog(NotificationDataModel.fromJson(message.data));
      //FCMLocalNotification.localNotification(message);
    });
  }

  static firebaseOnMessageOpenedApp(){
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp data: ${message.data}');
      showDialog(NotificationDataModel.fromJson(message.data));
    });
  }

  static Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print('received data in background: $message');
  }

  static showDialog(NotificationDataModel notification) => Get.dialog(Dialog(
    child: Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/appLogo/favi.jpg')),
                            borderRadius: BorderRadius.circular(11)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title!,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(notification.body!),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              notification.image != null
                  ? AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(notification.image!)),
                        borderRadius: BorderRadius.circular(11)),
                  ))
                  : SizedBox()
            ],
          ),
        ),
      ],
    ),
  ));
}
