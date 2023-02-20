import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button extends StatelessWidget {
  const Button(
      {super.key, required this.onTap,
      required this.buttonName,
      required this.nameColor,
      required this.buttonColor,
      this.focus,
      required this.elevation,
      required this.minHeight,
      required this.minWidth,
      required this.fontSize,
      required this.letterSpacing});

  final VoidCallback onTap;
  final String buttonName;
  final Color buttonColor;
  final Color nameColor;
  final FocusNode? focus;
  final double elevation;
  final double minWidth;
  final double minHeight;
  final double fontSize;
  final double letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: Colors.black,
      elevation: elevation,
      color: buttonColor,
      borderRadius: BorderRadius.circular(
        ScreenUtil().setWidth(120.0),
      ),
      child: MaterialButton(
        focusNode: focus,
        elevation: 1.0,
        onPressed: onTap,
        minWidth: minWidth,
        height: minHeight,
        child: Text(
          buttonName,
          style: TextStyle(
              fontFamily: 'Inter',
              fontSize: fontSize,
              color: nameColor,
              letterSpacing: letterSpacing,
              fontWeight: FontWeight.w700),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class ButtonSocial extends StatelessWidget {
  ButtonSocial(
      {required this.onTap,
      required this.buttonName,
      required this.buttonColor,
      this.focus,
      required this.imgURL,
      required this.minHeight,
      required this.minWidth,
      required this.nameColor,
      required this.fontSize,
      required this.letterSpacing,
      required this.elevation});

  final VoidCallback onTap;
  final String buttonName;
  final Color buttonColor;
  final Color nameColor;
  final FocusNode? focus;
  final double minWidth;
  final double minHeight;
  final String imgURL;
  final double elevation;
  final double fontSize;
  final double letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: Colors.black,
      elevation: elevation,
      color: buttonColor,
      borderRadius: BorderRadius.circular(
        ScreenUtil().setWidth(120.0),
      ),
      child: MaterialButton(
        focusNode: focus,
        elevation: 1.0,
        onPressed: onTap,
        minWidth: minWidth,
        height: minHeight,
//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
//        highlightElevation: 0,
//        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage(imgURL), height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  buttonName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: ScreenUtil().setSp(49.0),
                    color: nameColor,
                    letterSpacing: ScreenUtil().setSp(3.0),
                  ),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
