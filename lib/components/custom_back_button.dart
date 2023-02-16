import 'package:flutter/material.dart';
import 'circle_icon_button.dart';
import 'custom_icons_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: CircleIconButton(
        icon: FontAwesomeIcons.chevronLeft,
        color: Colors.white,
        size: ScreenUtil().setHeight(70.0),
        onPress: () {
          Navigator.pop(context);
          // Navigator.of(context, rootNavigator: true).pop();
        },
      ),
    );
  }
}
