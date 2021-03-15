import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:pure_live_chat/main_app/homePage/view/homePage.dart';


int channelId = 1;
String channelName = "NewUser";
String channelDescription = "Welcome User";

class LocalNotification {

  static showNotification(notificationTitle,notificationBody) async {

    //set plugin variable
    FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //init plugin platform settings
    _flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
            //android: AndroidInitializationSettings('@drawable/ic_noti_icon'),
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: IOSInitializationSettings()),

        onSelectNotification: notificationSelected);

    //init plugin platform Details
    var platform = NotificationDetails(
        android: AndroidNotificationDetails(
            channelId.toString(),
            channelName,
            channelDescription,
            sound: RawResourceAndroidNotificationSound('swiftly_noti'),
            timeoutAfter: 30000,
            autoCancel: false,
            playSound: true,
            priority: Priority.high,
            importance: Importance.max,
            ongoing: true,
            showProgress: debugInstrumentationEnabled),
        iOS: IOSNotificationDetails());

    await _flutterLocalNotificationsPlugin.show(

        channelId,
        notificationTitle,
        notificationBody,
        platform,
        payload: 'New message');
  }

  static Future notificationSelected(String? payload) async {

    Get.to(HomePage());
  }
}
