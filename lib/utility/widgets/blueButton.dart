import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pure_live_chat/utility/controller/sizeConfig.dart';
import 'package:pure_live_chat/utility/resources/appConst.dart';

class BlueButton extends StatelessWidget {
  final GetSizeConfig sizeConfig = Get.find();
  final String text;
  final Function onTap;
  BlueButton({
    required this.text,
    required this.onTap
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        height: sizeConfig.getPixels(60),
        width: sizeConfig.width * 500,
        decoration: BoxDecoration(
            color: AppConst.blue,
            borderRadius: BorderRadius.circular(111)
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: sizeConfig.getPixels(22)
            ),
          ),
        ),
      ),
    );
  }
}