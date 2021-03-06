import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

@immutable
class GradientButton extends StatelessWidget {
  final Widget? icon;
  final Color iconColor;
  final double radius;
  final List<Color> gradientColors;
  final String text;
  final Color textColor;
  final Color? background;
  final Color? borderColor;
  final double? width;
  final double? height;
  final double? iconSize;
  final Function? onPressed;
  final double elevation;
  final bool mini;
  final double fontSize;
  final Alignment? gradientStartDirection;
  final Alignment? gradientEndDirection;
  final String? textFontFamily;

  const GradientButton(
      {Key? key,
      this.mini = false,
      this.radius = 4.0,
      this.elevation = 1.8,
      this.textColor = Colors.white,
      this.iconColor = Colors.white,
      this.borderColor,
      this.iconSize,
      this.width,
      this.height,
      this.textFontFamily,
      required this.onPressed,
      required this.text,
      this.background,
      this.gradientColors = const [],
      this.icon,
      this.fontSize = 23.0,
      this.gradientEndDirection,
      this.gradientStartDirection})
      : super(key: key);

  bool get existGradientColors => gradientColors.length > 0;

  LinearGradient get linearGradient => existGradientColors
      ? LinearGradient(
          colors: gradientColors,
          begin: gradientStartDirection ?? Alignment.topLeft,
          end: gradientEndDirection ?? Alignment.topRight)
      : LinearGradient(colors: [background!, background!]);

  BoxDecoration get boxDecoration => BoxDecoration(
      gradient: linearGradient,
      border: Border.all(color: borderColor ?? Colors.transparent),
      borderRadius: BorderRadius.circular(radius),
      color: background ?? Colors.black);

  TextStyle get textStyle => TextStyle(
      fontFamily: textFontFamily ?? 'PermanentMarker',
      color: textColor,
      fontSize: fontSize,
      fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      onPressed: onPressed as void Function()?,
      child: mini
          ? Container(
              decoration: boxDecoration,
              width: width ?? 65.0,
              height: width ?? 65.0,
              child: icon != null
                  ? Container(
                      width: iconSize ?? 60,
                      height: iconSize ?? 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [Color(0xffE8AA4F), Color(0xffED5369)]),
                        color: iconColor,
                      ),
                      child: Container(
                        width: 60,
                        height: 60,
                        padding: EdgeInsets.all(12),
                        child: icon,
                      ),
              )
                  : Center(
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://midnightoilstudios.files.wordpress.com/2017/10/1200px-yin_yang-svg.png",
                      ),
                    ),
            )
          : Container(
              width: width ?? 165.0,
              height: height ?? 65.0,
              decoration: boxDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: textStyle,
                  ),
                  if (icon != null)
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: icon,
                      width: iconSize ?? 60,
                      height: iconSize ?? 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: iconColor,
                      ),
                    )
                ],
              ),
            ),
    );
  }
}
