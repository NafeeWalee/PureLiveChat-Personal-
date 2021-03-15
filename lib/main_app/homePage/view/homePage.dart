import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pure_live_chat/fcm/fcm_settings.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  @override
  void initState() {
    super.initState();

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
              'Push noti',
            ),
            TextButton(
              onPressed: () async {
                // AuthRepo().createUser(name, email, password, userPhoto, userType, loginType);

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
