import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:pure_live_chat/authentication/repo/authRepo.dart';
import 'package:pure_live_chat/authentication/view/loginPage.dart';
import 'package:pure_live_chat/utility/controller/sizeConfig.dart';
import 'package:pure_live_chat/utility/resources/appConst.dart';
import 'package:pure_live_chat/utility/resources/stringResources.dart';
import 'package:pure_live_chat/utility/resources/validator.dart';
import 'package:pure_live_chat/utility/widgets/blueButton.dart';
import 'package:pure_live_chat/utility/widgets/gradientButton.dart';
import 'package:pure_live_chat/utility/widgets/lightTextField.dart';
import 'package:pure_live_chat/utility/widgets/loader.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:pure_live_chat/utility/widgets/loadingScreen.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  final GetSizeConfig sizeConfig = Get.find();
  final AuthRepo authController = Get.find();
  var logger = Logger();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confPasswordController = TextEditingController();
  var isObscure = true.obs;
  var isObscureConfirmPass = true.obs;

  double? width;
  double? height;
  FocusNode? nameNode;
  FocusNode? emailNode;
  FocusNode? passwordNode;
  FocusNode? confPassNode;

  final picker = ImagePicker();
  File? image;
  bool isLoading = true;

  bool rememberUser = false;

  @override
  void initState() {
    if (!mounted) {
      return;
    } else {
      super.initState();
      setInitialScreenSize();
      convertAssetToFile();
      nameNode = FocusNode();
      emailNode = FocusNode();
      passwordNode = FocusNode();
      confPassNode = FocusNode();
      nameNode?.addListener(() {
        setState(() {});
      });
      emailNode?.addListener(() {
        setState(() {});
      });
      passwordNode?.addListener(() {
        setState(() {});
      });
      confPassNode?.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confPasswordController.dispose();

    nameNode?.dispose();
    emailNode?.dispose();
    passwordNode?.dispose();
    confPassNode?.dispose();
  }

  setInitialScreenSize() {
    width = sizeConfig.width.value;
    height = sizeConfig.height.value;
  }

  void selectPic() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> convertAssetToFile() async {
    //Converting Asset to File for profile picture
    Directory directory =
        await path_provider.getApplicationDocumentsDirectory();
    var dbPath = join(directory.path, "temp.jpg");
    ByteData data = await rootBundle.load("assets/images/sasuke.jpg");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    image = await File(dbPath).writeAsBytes(bytes);
    setState(() {
      isLoading = false;
    });
  }

  sendDataToFunction() async {
    setState(() {
      isLoading = true;
    });
    String userType = 'member';
    String loginType = 'regular';
    var hasExceptionOnCreation = await authController.createUser(
      name: nameController.text,
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      userPhoto: image,
      loginType: loginType,
      userType: userType,
    );
    logger.i(hasExceptionOnCreation);
    if (hasExceptionOnCreation != null) {
      getSnackbar(hasExceptionOnCreation);
    } else {
      print('here');
      var hasException = await authController.login(
          emailController.text, passwordController.text, rememberUser);
      if (hasException != null) {
        getSnackbar(hasException);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  getSnackbar(hasException) {
    Get.snackbar(
      "Error",
      hasException,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      margin: EdgeInsets.only(
          left: sizeConfig.width * 10,
          right: sizeConfig.width * 10,
          bottom: sizeConfig.height * 15),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: IsScreenLoading(
              isLoading: isLoading,
              child: Stack(
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
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
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          form(),
                          SizedBox(
                            height: sizeConfig.height * 50,
                          ),
                          footer()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget form() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Stack(
            children: [
              image == null
                  ? Container(
                      width: sizeConfig.width * 250,
                      height: sizeConfig.width * 250,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppConst.white),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: ExactAssetImage('assets/images/sasuke.jpg'),
                          )),
                    )
                  : Container(
                      width: sizeConfig.width * 250,
                      height: sizeConfig.width * 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppConst.white),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: FileImage(image!),
                        ),
                      ),
                    ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: 0,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.6),
                    ),
                    child: IconButton(
                      onPressed: selectPic,
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: AppConst.gradientSecond,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: sizeConfig.height * 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width! * 60, vertical: height! * 15),
            child: LightTextField(
              focusNode: nameNode!,
              controller: nameController,
              icon: Icons.person_outline,
              enabled: true,
              textColor: Colors.white,
              validator: Validator().nullFieldValidate,
              hintText: 'Username',
            ),
          ),
          SizedBox(
            height: sizeConfig.height * 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width! * 60, vertical: height! * 15),
            child: LightTextField(
              focusNode: emailNode!,
              icon: Icons.email_outlined,
              controller: emailController,
              enabled: true,
              textColor: Colors.white,
              hintText: 'Email Address',
              validator: Validator().validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          SizedBox(
            height: sizeConfig.height * 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width! * 60, vertical: height! * 15),
            child: LightTextField(
              focusNode: passwordNode!,
              icon: Icons.lock_outline,
              controller: passwordController,
              obscure: isObscure.value!,
              enabled: true,
              textColor: Colors.white,
              hintText: 'Password',
              validator: Validator().validatePassword,
              suffixIcon: IconButton(
                icon: !isObscure.value!
                    ? Icon(
                        Icons.visibility,
                        color: AppConst.gradientFirst,
                      )
                    : Icon(Icons.visibility_off,
                        color: AppConst.gradientSecond),
                onPressed: () {
                  isObscure.value = !isObscure.value!;
                },
              ),
            ),
          ),
          SizedBox(
            height: sizeConfig.height * 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width! * 60, vertical: height! * 15),
            child: LightTextField(
              focusNode: confPassNode!,
              icon: Icons.lock_outline,
              controller: confPasswordController,
              obscure: isObscureConfirmPass.value!,
              suffixIcon: IconButton(
                icon: !isObscureConfirmPass.value!
                    ? Icon(
                        Icons.visibility,
                        color: AppConst.gradientFirst,
                      )
                    : Icon(
                        Icons.visibility_off,
                        color: AppConst.gradientSecond,
                      ),
                onPressed: () {
                  isObscureConfirmPass.value = !isObscureConfirmPass.value!;
                },
              ),
              validator: (v) {
                return Validator()
                    .validateConfirmPassword(passwordController.text, v!);
              },
              enabled: true,
              textColor: Colors.white,
              hintText: 'Confirm Password',
            ),
          ),
          SizedBox(
            height: sizeConfig.height * 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width! * 60, vertical: height! * 15),
            child: GradientButton(
              width: width! * 1000,
              height: height! * 80,
              radius: width! * 100,
              onPressed: () async {
                FocusScope.of(this.context).unfocus();
                if (formKey.currentState!.validate()) {
                  if (passwordController.text != confPasswordController.text) {
                    Get.snackbar(
                      "Text Field Error!",
                      "Password does not match",
                      backgroundColor: Colors.black,
                      colorText: Colors.white,
                      margin: EdgeInsets.only(
                          left: sizeConfig.width * 10,
                          right: sizeConfig.width * 10,
                          bottom: sizeConfig.height * 15),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    sendDataToFunction();
                  }
                }
              },
              gradientColors: [AppConst.gradientFirst, AppConst.gradientSecond],
              text: 'Sign Up',
              textFontFamily: 'PermanentMarker-Regular',
              gradientStartDirection: Alignment.topCenter,
              gradientEndDirection: Alignment.bottomCenter,
            ),
          ),
        ],
      ),
    );
  }

  Widget footer() {
    return RichText(
      text: TextSpan(
          text: StringResources.registrationFooterTextNormal,
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(
                recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                text: StringResources.registrationFooterTextBold,
                style: TextStyle(fontWeight: FontWeight.bold))
          ]),
    );
  }
}
