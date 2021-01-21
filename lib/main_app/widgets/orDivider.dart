import 'package:flutter/material.dart';
import 'package:pure_live_chat/main_app/utils/controller/sizeConfig.dart';
import 'package:get/get.dart';

class OrDivider extends StatelessWidget {
  final String text;
  final String textStyle;
  final double fontSize;
  final double thickness;
  final double leftIndent;
  final double rightIndent;
  final double leftEndIndent;
  final double rightEndIndent;
  final Color fontColor;
  final Color dividerColor;
  final GetSizeConfig getSizeConfig = Get.find();
  OrDivider({this.fontColor,this.dividerColor,this.text,this.textStyle,this.leftIndent,this.rightIndent,this.leftEndIndent,this.rightEndIndent,this.fontSize,this.thickness});
  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Expanded(
              child: Divider(color: dividerColor??Colors.white60,thickness: thickness??getSizeConfig.width.value*5,indent: leftIndent??getSizeConfig.width.value*180,endIndent: leftEndIndent??getSizeConfig.width.value*40,)
          ),
          Text(
            text??'OR',
            style: TextStyle(
                fontFamily: textStyle??'Pacifico-Regular',
                fontSize: fontSize??getSizeConfig.getPixels(18),
                fontWeight: FontWeight.normal,
                color: fontColor??Colors.white60
            ),
          ),
          Expanded(
              child: Divider(color: dividerColor??Colors.white60,thickness: thickness??getSizeConfig.width.value*5,indent: rightIndent??getSizeConfig.width.value*40,endIndent: rightEndIndent??getSizeConfig.width.value*180,)
          ),
        ]
    );
  }
}
