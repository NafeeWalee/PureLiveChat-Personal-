import 'dart:io';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:pure_live_chat/authentication/repo/authRepo.dart';
import 'package:pure_live_chat/utility/controller/sizeConfig.dart';
import 'package:pure_live_chat/utility/resources/stringResources.dart';
import 'package:pure_live_chat/utility/resources/validator.dart';
import 'package:pure_live_chat/utility/widgets/blueButton.dart';
import 'package:pure_live_chat/utility/widgets/customTextField.dart';
import 'package:pure_live_chat/utility/widgets/loader.dart';

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

  FocusNode? nameNode;
  FocusNode? emailNode;
  FocusNode? passwordNode;
  FocusNode? confPassNode;

  final picker = ImagePicker();
  File? image ;
  bool isLoading = false;


  bool rememberUser = false;

  @override
  void initState() {
    super.initState();
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
    Directory directory = await path_provider.getApplicationDocumentsDirectory();
    var dbPath = join(directory.path, "temp.jpg");
    ByteData data = await rootBundle.load("assets/images/demo_profile_image.jpg");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    image = await File(dbPath).writeAsBytes(bytes);
  }

  sendDataToFunction() async {
    setState(() {
      isLoading = true;
    });
    String userType = 'member';
    String loginType = 'regular';
    var hasExceptionOnCreation = await authController.createUser( name: nameController.text,email: emailController.text.trim(),password: passwordController.text.trim(), userPhoto: image,loginType:loginType,userType:  userType,);
    logger.i(hasExceptionOnCreation);
    setState(() {
      isLoading = false;
    });
    if (hasExceptionOnCreation != null) {
      getSnackbar(hasExceptionOnCreation);
    }
    else {
      print('here');
      var hasException =  await authController.login(emailController.text, passwordController.text,rememberUser);
      if(hasException != null){
        setState(() {
          isLoading = false;
        });
        getSnackbar(hasException);
      }
    }
  }

  getSnackbar(hasException){
    Get.snackbar(
      "Error",
      hasException,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      margin: EdgeInsets.only(left: sizeConfig.width * 10,
          right: sizeConfig.width * 10,
          bottom: sizeConfig.height * 15),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            IgnorePointer(
              ignoring: isLoading?true:false,
              child: Opacity(
                opacity: isLoading?0.5:1,
                child: Container(
                  color: isLoading?Colors.grey[50]:Color(0xffF2F2FF),
                  child: Center(
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          header(),
                          form(),
                          SizedBox(height: sizeConfig.height * 50,),
                          footer()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            isLoading?Loader():Container(),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      height: sizeConfig.height * 200,
      // color: Colors.red,
      child: Container(
        height: sizeConfig.width * 300,
        width: sizeConfig.width * 300,
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }

  Widget form() {

    return Obx((){
      return Form(
        key: formKey,
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: sizeConfig.getPixels(45),
                  backgroundImage: FileImage(image!),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: selectPic,
                    child: CircleAvatar(
                      radius: sizeConfig.getPixels(20),
                      backgroundColor: Colors.white60,
                      child: Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: sizeConfig.height * 10,),
            RoundedTextField(
              focusNode: nameNode!,
              labelText: StringResources.registrationTextFieldHintName,
              icon: Icons.person_outline,
              controller: nameController,
              validator: Validator().nullFieldValidate,
            ),
            SizedBox(height: sizeConfig.height * 10,),
            RoundedTextField(
              focusNode: emailNode!,
              labelText: StringResources.registrationTextFieldHintEmail,
              icon: Icons.email_outlined,
              controller: emailController,
              validator: Validator().validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: sizeConfig.height * 10,),
            RoundedTextField(
              focusNode: passwordNode!,
              labelText: StringResources.registrationTextFieldHintPassword,
              icon: Icons.lock_outline,
              controller: passwordController,
              obscureText: isObscure.value!,
              validator: Validator().validatePassword,
              suffixIcon: IconButton(
                icon: !isObscure.value!
                    ? Icon(
                  Icons.visibility,
                )
                    : Icon(
                  Icons.visibility_off,
                ),
                onPressed: () {
                  isObscure.value = !isObscure.value!;
                },
              ),
            ),
            SizedBox(height: sizeConfig.height * 10,),
            RoundedTextField(
              focusNode: confPassNode!,
              labelText: StringResources.registrationTextFieldHintConfirmPassword,
              icon: Icons.lock_outline,
              controller: confPasswordController,
              obscureText: isObscureConfirmPass.value!,
              suffixIcon: IconButton(
                icon: !isObscureConfirmPass.value!
                    ? Icon(
                  Icons.visibility,
                )
                    : Icon(
                  Icons.visibility_off,
                ),
                onPressed: () {
                  isObscureConfirmPass.value = !isObscureConfirmPass.value!;
                },
              ),
              validator: (v){
                return Validator().validateConfirmPassword(passwordController.text, v!);
              },
            ),
            SizedBox(height: sizeConfig.height * 30,),
            //signUpMethods(),
            SizedBox(height: sizeConfig.height * 30,),
            BlueButton(
                text: StringResources.registrationBtnRegister,
                onTap: () async {
                  FocusScope.of(this.context).unfocus();
                  if (formKey.currentState!.validate()) {
                    if (passwordController.text != confPasswordController.text) {
                      Get.snackbar(
                        "Text Field Error!",
                        "Password does not match",
                        backgroundColor: Colors.black,
                        colorText: Colors.white,
                        margin: EdgeInsets.only(left: sizeConfig.width * 10,
                            right: sizeConfig.width * 10,
                            bottom: sizeConfig.height * 15),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }else{
                      sendDataToFunction();
                    }
                  }
                }
            )
          ],
        ),
      );
    });
  }

/*  Widget signUpMethods() {
    return Container(
      height: sizeConfig.height * 100,
      width: sizeConfig.width * 750,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            StringResources.registrationSignUpMethodText,
            style: TextStyle(
                fontSize: sizeConfig.getPixels(16)
            ),
          ),
          signUpMethod(StringResources.loginImgSignInWithGoogle, 'google'),
          signUpMethod(StringResources.loginImgSignInWithFacebook, 'facebook'),
        ],
      ),
    );
  }

  Widget signUpMethod(String image, String identifier){
    return GestureDetector(
      onTap: () async {
        if(identifier == 'facebook'){
          setState(() {
            isLoading = true;
          });
          print('Checking Facebook...');
          AuthRepo authFacebook = Get.find();
          var hasException = await authFacebook.loginFacebook();
          if(hasException != null){
            setState(() {
              isLoading = false;
            });
            Get.snackbar(
              "Error signing in",
              hasException,
              backgroundColor: Colors.black,
              colorText: Colors.white,
              margin: EdgeInsets.only(left: 10,
                  right: 10,
                  bottom: 15),
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }else if(identifier == 'google'){
          setState(() {
            isLoading = true;
          });
          print('Checking Google...');
          AuthRepo authGoogle = Get.find();
          var hasException = await authGoogle.handleGoogleSignIn();
          if(hasException != null){
            setState(() {
              isLoading = false;
            });
            Get.snackbar(
              "Error signing in",
              hasException,
              backgroundColor: Colors.black,
              colorText: Colors.white,
              margin: EdgeInsets.only(left: 10,
                  right: 10,
                  bottom: 15),
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(111)),
        child: Padding(
            padding: EdgeInsets.all(sizeConfig.getPixels(4)),
            child: CircleAvatar(
              backgroundImage: AssetImage(image),
              backgroundColor: Colors.transparent,
              radius: sizeConfig.getPixels(30),
            )
        ),
      ),
    );
  }*/

  Widget footer() {
    return RichText(
      text: TextSpan(
          text: StringResources.registrationFooterTextNormal,
          style: TextStyle(
              color: Colors.black
          ),
          children: [
            TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Get.back(),
                text: StringResources.registrationFooterTextBold,
                style: TextStyle(
                    fontWeight: FontWeight.bold
                )
            )
          ]
      ),
    );
  }


}