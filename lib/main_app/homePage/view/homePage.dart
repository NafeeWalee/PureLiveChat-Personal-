import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pure_live_chat/authentication/repo/authRepo.dart';
import 'package:pure_live_chat/fcm/fcm_item.dart';
import 'package:get/get.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Map<String, Item> _items = <String, Item>{};
  String _homeScreenText = "Waiting for token...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Item _itemForMessage(RemoteMessage message) {
    final dynamic data = message.data;
    final String itemId = data['id'];
    final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId))..status = data['status'];
    return item;
  }


  Widget _buildDialog(BuildContext context, Item item) {
    return AlertDialog(
      content: Text("Item ${item.itemId} has been updated"),
      actions: <Widget>[
        TextButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  void _showItemDialog(RemoteMessage message) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, _itemForMessage(message)),
    ).then((bool? shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }

  void _navigateToItemDetail(RemoteMessage message) {
    final Item item = _itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.push(context, item.route);
    }
  }

  initializeFCM() async {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        _showItemDialog(message);
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      _navigateToItemDetail(message);
    });


    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });

      print(_homeScreenText);
    });
  }

  @override
  void initState() {
    super.initState();
    initializeFCM();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Push Notification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _homeScreenText,
            ),
            TextButton(
              onPressed: () async {
                // AuthRepo().createUser(name, email, password, userPhoto, userType, loginType);
                var hasException =  await AuthRepo().login(emailController.text, passwordController.text,rememberUser);
                if(hasException != null){
                  setState(() {
                    isLoading = false;
                  });
                  Get.snackbar('Error', hasException);
                }
               // AuthRepo().createUser(name: 'WALEE',password: '1212',email: 'walee@gmail.com',userType: 'member');
              },
              child: Text('Authenticate'),
            )
          ],
        ),
      ),
    );
  }
}
