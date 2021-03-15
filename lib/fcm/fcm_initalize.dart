import 'package:pure_live_chat/fcm/fcm_settings.dart';
import 'package:pure_live_chat/fcm/fcm_messageFunction.dart';


class FCM{
  static initializeFCM(){
    FCMSettings.settings();
    FCMMessageFunction.fcmMessageFunction();
  }
}

