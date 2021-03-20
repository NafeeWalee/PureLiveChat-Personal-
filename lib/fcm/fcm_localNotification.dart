
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pure_live_chat/main_app/homePage/view/homePage.dart';
import 'package:get/get.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
  sound: RawResourceAndroidNotificationSound('swiftly_noti'),
  playSound: true,
);

class FCMLocalNotification{

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static localInit() async {
    await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    //init plugin platform settings
    _flutterLocalNotificationsPlugin.initialize(InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: IOSInitializationSettings()),
        onSelectNotification: notificationSelected);
  }

  static localNotification(RemoteMessage message) async {
    ///Local notification
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      print('Got a message whilst in the foreground!');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      //init plugin platform Details
      var platform = NotificationDetails(
          android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              sound: channel.sound,
              importance: channel.importance,
              playSound: channel.playSound,
              icon: android.smallIcon,
              priority: Priority.high,
             ),
          iOS: IOSNotificationDetails());

      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platform,
      );
    }
  }


  static Future notificationSelected(String? payload) async {
    Get.to(HomePage());
  }
}