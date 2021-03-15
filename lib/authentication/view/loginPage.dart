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
import 'package:flutter/foundation.dart';
import 'package:pure_live_chat/authentication/repo/authRepo.dart';
import 'package:pure_live_chat/authentication/view/registerPage.dart';
import 'package:pure_live_chat/utility/controller/sizeConfig.dart';
import 'package:pure_live_chat/utility/widgets/gradientButton.dart';
import 'package:pure_live_chat/utility/widgets/lightTextField.dart';
import 'package:pure_live_chat/utility/widgets/orDivider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pure_live_chat/utility/widgets/loadingScreen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AutomaticKeepAliveClientMixin,TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  GetSizeConfig getSizeConfig = Get.find();
  double? width;
  double? height;
  bool _switchValue = false;
  bool? hasConnection;
  Future? _dialog;
  var currentStatus;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  bool crossFade = true;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool rememberMe = false;
  bool isLoading = false;

  @override
  void initState() {
    if (!mounted) {
      return;
    } else {
      super.initState();
      setInitialScreenSize();
      if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
        initConnectivity();
        _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

      }
      else if ((defaultTargetPlatform == TargetPlatform.linux) || (defaultTargetPlatform == TargetPlatform.macOS) || (defaultTargetPlatform == TargetPlatform.windows) ) {
        // Some desktop specific code there
      }
      else {
        // Some web specific code there
      }
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    username.dispose();
    password.dispose();
    super.dispose();
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
    ConnectivityResult? result;
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
    bool connection = (await checkConnection())!;
    if (!connection) {
      Get.snackbar('Connection Issue', 'Fluctuating Network Detected!',
          backgroundColor: Colors.black,
          colorText: Colors.white,
          margin: EdgeInsets.only(
              bottom: height! * 20, left: width! * 15, right: width! * 15),
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Connected to Network', 'Internet Connection Established!',backgroundColor: Colors.black,colorText: Colors.white,
          margin: EdgeInsets.only(bottom: height!*20,left: width!*15,right:width!*15),snackPosition: SnackPosition.BOTTOM);
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

  Future<bool?> checkConnection() async {
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
        resizeToAvoidBottomInset: false,
        body: IsScreenLoading(
          isLoading: isLoading,
          child: Stack(
            children: [
              ImageFiltered(
                imageFilter: crossFade?ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0):ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xff1E1E1F), Color(0xff4C4D51)]),
                  ),
                  child: Opacity(
                    opacity: .3,
                    child: CachedNetworkImage(
                      height: Get.height,
                      fit: BoxFit.fill,
                      imageUrl:
                      'https://images.unsplash.com/photo-1606613992706-02a0f77643f4?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
                      // 'https://i.pinimg.com/originals/ae/9f/4d/ae9f4dc00d333cf0f5a1d56bb50bcbc7.jpg',
                      //imageUrl: 'https://cutewallpaper.org/21/naruto-itachi-wallpaper-mobile/Uchiha-Itachi-Itachi-Uchiha-Akatsuki-Naruto-Love-.png',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width! * 50, right: width! * 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedCrossFade(
                        firstChild: upperSide(),
                        secondChild: loginUpperSide(),
                        crossFadeState: crossFade?CrossFadeState.showFirst:CrossFadeState.showSecond,
                        duration: Duration(milliseconds: 200)),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientButton(
                          width: width! * 1000,
                          height: height! * 80,
                          radius: width! * 100,
                          onPressed: () async {
                            if(crossFade){
                              setState(() {
                                crossFade = !crossFade;
                              });
                            }else{
                              setState(() {
                                isLoading = true;
                              });
                              var hasException =  await AuthRepo().login(username.text, password.text,rememberMe);
                              if(hasException != null){
                                setState(() {
                                  isLoading = false;
                                });
                                Get.snackbar('Error', hasException);
                              }
                            }
                          },
                          gradientColors: [Color(0xff1E1E1F), Color(0xff4C4D51)],
                          text: 'Login',
                          textFontFamily: 'PermanentMarker-Regular',
                          gradientStartDirection: Alignment.topCenter,
                          gradientEndDirection: Alignment.bottomCenter,
                        ),
                      ],
                    ),
                    !crossFade?SizedBox(height: Get.height/30,):Container(),
                    AnimatedCrossFade(
                        firstChild: lowerSide(),
                        secondChild: registerLowerSide(),
                        crossFadeState: crossFade?CrossFadeState.showFirst:CrossFadeState.showSecond,
                        firstCurve: Curves.linear,
                        secondCurve: Curves.linear,
                        duration: Duration(milliseconds: 400)),
                    SizedBox(height: Get.height/120,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column upperSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: height! * 50,
        ),
        icon(iconWidth: 300,iconHeight: 270),
        Text(
          'Welcome',
          style: TextStyle(
              fontFamily: 'PermanentMarker-Regular',
              fontSize: getSizeConfig.getPixels(36),
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        Container(
          alignment: Alignment.center,
          width: width! * 1000,
          child: Text(
            'Connect your words around the world',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Pacifico-Regular',
                fontSize: getSizeConfig.getPixels(20),
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
        ),
        SizedBox(height: height!*100,),
      ],
    );
  }

  icon({iconWidth,iconHeight}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height! * 30),
      child: GradientButton(
        mini: true,
        radius: width! * iconWidth,
        width: width! * iconHeight,
        svgIcon: 'assets/images/pawprint.svg',
        // icon: Icons.whatshot_outlined,
        iconColor: Colors.white,
        iconSize: getSizeConfig.getPixels(iconWidth/(5)),
        onPressed: null,
        gradientColors: [Color(0xffE8AA4F), Color(0xffED5369)],
        text: '',
        gradientStartDirection: Alignment.topCenter,
        gradientEndDirection: Alignment.bottomCenter,
      ),
    );
  }

  Column lowerSide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: height! * 20),
          child: OrDivider(
            text: 'OR',
            textStyle: 'Pacifico-Regular',
            leftIndent: width! * 180,
            leftEndIndent: width! * 40,
            rightIndent: width! * 40,
            rightEndIndent: width! * 180,
            dividerColor: Colors.white60,
            fontColor: Colors.white60,
            fontSize: getSizeConfig.getPixels(18),
          ),
        ),
        GradientButton(
          width: width! * 1000,
          height: height! * 80,
          radius: width! * 100,
          onPressed: () {
            Get.to(()=>RegisterPage());
          },
          borderColor: Colors.white,
          background: Colors.transparent,
          text: 'Sign Up',
          textFontFamily: 'PermanentMarker-Regular',
          gradientStartDirection: Alignment.topCenter,
          gradientEndDirection: Alignment.bottomCenter,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: height! * 20),
          child: Divider(
            color: Colors.white60,
            indent: width! * 100,
            endIndent: width! * 100,
            thickness: width! * 5,
          ),
        ),
        Text(
          'Welcome to PureChat',
          style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: getSizeConfig.getPixels(18),
              fontWeight: FontWeight.normal,
              color: Colors.white60),
        ),
      ],
    );
  }

  Column loginUpperSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: height! * 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon(iconWidth: 150,iconHeight: 130),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height! * 20),
              child: Text(
                'Login',
                style: TextStyle(
                    fontFamily: 'PermanentMarker-Regular',
                    fontSize: getSizeConfig.getPixels(36),
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            SizedBox(width: width!*150,)
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width! * 60, vertical: height! * 15),
          child: LightTextField(
            controller: username,
            hintText: 'Username',
            enabled: true,
            textColor: Colors.white,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width! * 60, vertical: height! * 15),
          child: LightTextField(
            controller: password,
            hintText: 'Password',
            enabled: true,
            textColor: Colors.white,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width! * 30),
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
        ),

      ],
    );
  }

  Column registerLowerSide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: height! * 20),
          child: OrDivider(
            text: 'OR',
            textStyle: 'Pacifico-Regular',
            leftIndent: width! * 180,
            leftEndIndent: width! * 40,
            rightIndent: width! * 40,
            rightEndIndent: width! * 180,
            dividerColor: Colors.white60,
            fontColor: Colors.white60,
            fontSize: getSizeConfig.getPixels(18),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: height! * 20),
          child: GradientButton(
            width: width! * 1000,
            height: height! * 80,
            radius: width! * 100,
            onPressed: () {
            },
            gradientColors: [Color(0xff596FF3), Color(0xffE34133)],
            text: 'Login with Google',
            textFontFamily: 'PermanentMarker-Regular',
            gradientStartDirection: Alignment.topCenter,
            gradientEndDirection: Alignment.bottomCenter,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: height! * 20),
          child: Divider(
            color: Colors.white60,
            indent: width! * 100,
            endIndent: width! * 100,
            thickness: width! * 5,
          ),
        ),
        Text(
          'CREATED BY WALEE,  V 1.0',
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
