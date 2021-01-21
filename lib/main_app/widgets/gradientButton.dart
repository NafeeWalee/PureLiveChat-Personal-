import 'package:flutter/material.dart';

@immutable
class GradientButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double radius;
  final List<Color> gradientColors;
  final String text;
  final Color textColor;
  final Color background;
  final Color borderColor;
  final double width;
  final double height;
  final double iconSize;
  final Function onPressed;
  final double elevation;
  final bool mini;
  final double fontSize;
  final Alignment gradientStartDirection;
  final Alignment gradientEndDirection;
  final String textFontFamily;

  const GradientButton(
      {Key key,
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
      @required this.onPressed,
      @required this.text,
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
      : LinearGradient(colors: [background, background]);

  BoxDecoration get boxDecoration => BoxDecoration(
      gradient: linearGradient,
      border: Border.all(color: borderColor??Colors.transparent),
      borderRadius: BorderRadius.circular(radius),
      color: background ?? Colors.black);

  TextStyle get textStyle => TextStyle(
      fontFamily: textFontFamily ?? 'PermanentMarker',
      color: textColor,
      fontSize: fontSize,
      fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape:
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
          ),
      onPressed: onPressed,
      child: mini
          ? Container(
              decoration: boxDecoration,
              width: width ?? 65.0,
              height: width ?? 65.0,
              child: Icon(
                icon,
                color: iconColor ?? Colors.white,
                size: iconSize ?? 60,
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
                    Icon(
                      icon,
                      color: Colors.white,
                    ),
                ],
              ),
            ),
    );
  }
}
