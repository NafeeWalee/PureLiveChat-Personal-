import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';

import 'package:pure_live_chat/main_app/utils/controller/sizeConfig.dart';
import 'package:pure_live_chat/main_app/widgets/gradientButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pure_live_chat/main_app/widgets/lightTextField.dart';
import 'package:pure_live_chat/main_app/widgets/orDivider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  GetSizeConfig getSizeConfig = Get.find();
  double width;
  double height;
  bool _switchValue = false;
  bool hasConnection;
  Future _dialog;
  var currentStatus;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool crossFade = true;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    if (!mounted) {
      return;
    } else {
      super.initState();
      setInitialScreenSize();
      initConnectivity();
      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
    username.dispose();
    password.dispose();
  }

  setInitialScreenSize() {
    getSizeConfig.setSize(
      (Get.width -
          (Get.mediaQuery.padding.left + Get.mediaQuery.padding.right)) /
          1000,
      (Get.height -
          (Get.mediaQuery.padding.top + Get.mediaQuery.padding.bottom)) /
          1000,
    );

    width = getSizeConfig.width.value;
    height = getSizeConfig.height.value;
  }

  Future initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(status) async {
    currentStatus = status;
    switch (currentStatus) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        if (_dialog != null) {
          _dialog = null;
          Navigator.pop(context);
        }
        break;
      case ConnectivityResult.none:
        _dialog = showDialog();
        break;
      default:
        print(currentStatus.toString());
        break;
    }
    var connection = await checkConnection();
    if (!connection) {
      Get.snackbar('Connection Issue', 'Fluctuating Network Detected!',
          backgroundColor: Colors.black,
          colorText: Colors.white,
          margin: EdgeInsets.only(
              bottom: height * 20, left: width * 15, right: width * 15),
          snackPosition: SnackPosition.BOTTOM);
    } else {
      // print('123');
      // Get.snackbar('Connected to Network', 'Internet Connection Established!',backgroundColor: Colors.black,colorText: Colors.white,
      //     margin: EdgeInsets.only(bottom: height*20,left: width*15,right:width*15),snackPosition: SnackPosition.BOTTOM);
    }
    print('init result: ${currentStatus.toString()}');
  }

  Future showDialog() {
    return AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.WARNING,
      body: Center(
        child: Text(
          'No connection to Internet found!',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      title: 'Network Issue',
      desc: 'No Stable connection found!',
      btnOkText: 'Settings',
      btnOkOnPress: () {
        AppSettings.openWIFISettings();
      },
      btnCancelText: 'Exit',
      btnCancelOnPress: () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop', true);
      },
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      onDissmissCallback: () {
        print('callback result: ${currentStatus.toString()}');
        if (ConnectivityResult.none == currentStatus) {
          _dialog = showDialog();
        } else {
          _dialog = null;
        }
      },
    ).show();
  }

  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    return hasConnection;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        return Future.value(null);
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: [
            ImageFiltered(
              imageFilter: crossFade?ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0):ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xff1E1E1F), Color(0xff4C4D51)]),
                ),
                child: Opacity(
                  opacity: .2,
                  child: CachedNetworkImage(
                    height: Get.height,
                    fit: BoxFit.cover,
                    imageUrl:
                    'https://i.pinimg.com/originals/ae/9f/4d/ae9f4dc00d333cf0f5a1d56bb50bcbc7.jpg',
                    //imageUrl: 'https://cutewallpaper.org/21/naruto-itachi-wallpaper-mobile/Uchiha-Itachi-Itachi-Uchiha-Akatsuki-Naruto-Love-.png',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height * 70, horizontal: width * 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedCrossFade(
                      firstChild: upperSide(),
                      secondChild: loginFields(),
                      crossFadeState: crossFade?CrossFadeState.showFirst:CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 500)),
                  lowerSide()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column loginFields() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: height * 20),
          child: Text(
            'Login',
            style: TextStyle(
                fontFamily: 'PermanentMarker-Regular',
                fontSize: getSizeConfig.getPixels(36),
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 60, vertical: height * 15),
          child: LightTextField(
            controller: username,
            hintText: 'Username',
            enabled: true,
            textColor: Colors.white,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 60, vertical: height * 15),
          child: LightTextField(
            controller: password,
            hintText: 'Password',
            enabled: true,
            textColor: Colors.white,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 30, vertical: height * 10),
          child: Row(
            children: [
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  activeColor: Color(0xffE8AA4F),
                  trackColor: Colors.white60,
                  value: _switchValue,
                  onChanged: (bool value) {
                    setState(() {
                      _switchValue = value;
                    });
                  },
                ),
              ),
              Text(
                'Remember Me',
                style: TextStyle(
                    fontFamily: 'PermanentMarker-Regular',
                    fontSize: getSizeConfig.getPixels(14),
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        )
      ],
    );
  }

  Column upperSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: height * 50,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: height * 30),
          child: GradientButton(
            iconSize: getSizeConfig.getPixels(70),
            mini: true,
            radius: width * 300,
            width: width * 270,
            icon: Icons.whatshot_outlined,
            onPressed: null,
            gradientColors: [Color(0xffE8AA4F), Color(0xffED5369)],
            text: 'Login',
            gradientStartDirection: Alignment.topCenter,
            gradientEndDirection: Alignment.bottomCenter,
          ),
        ),
        Text(
          'PURE',
          style: TextStyle(
              fontFamily: 'PermanentMarker-Regular',
              fontSize: getSizeConfig.getPixels(36),
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        Container(
          alignment: Alignment.center,
          width: width * 800,
          child: Text(
            'Memories ... \n Are Like Shadows In The Fog',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Pacifico-Regular',
                fontSize: getSizeConfig.getPixels(20),
                fontWeight: FontWeight.normal,
                color: Colors.white60),
          ),
        ),
        Divider(
          thickness: width * 20,
          color: Colors.white70,
          indent: width * 450,
          endIndent: width * 450,
        ),
      ],
    );
  }

  Column lowerSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GradientButton(
          width: width * 1000,
          height: height * 80,
          radius: width * 100,
          onPressed: () {
            setState(() {
              crossFade = !crossFade;
            });
          },
          gradientColors: [Color(0xffE8AA4F), Color(0xffED5369)],
          text: 'Login',
          textFontFamily: 'PermanentMarker-Regular',
          gradientStartDirection: Alignment.topCenter,
          gradientEndDirection: Alignment.bottomCenter,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: height * 20),
          child: OrDivider(
            text: 'OR',
            textStyle: 'Pacifico-Regular',
            leftIndent: width * 180,
            leftEndIndent: width * 40,
            rightIndent: width * 40,
            rightEndIndent: width * 180,
            dividerColor: Colors.white60,
            fontColor: Colors.white60,
            fontSize: getSizeConfig.getPixels(18),
          ),
        ),
        GradientButton(
          width: width * 1000,
          height: height * 80,
          radius: width * 100,
          onPressed: () {},
          borderColor: Colors.white,
          background: Colors.transparent,
          text: 'Sign Up',
          textFontFamily: 'PermanentMarker-Regular',
          gradientStartDirection: Alignment.topCenter,
          gradientEndDirection: Alignment.bottomCenter,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: height * 20),
          child: Divider(
            color: Colors.white60,
            indent: width * 100,
            endIndent: width * 100,
            thickness: width * 5,
          ),
        ),
        Text(
          'MADE BY WALEE,  V 1.0',
          style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: getSizeConfig.getPixels(18),
              fontWeight: FontWeight.normal,
              color: Colors.white60),
        ),
      ],
    );
  }
}
