import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleIconButton extends StatelessWidget {
  CircleIconButton(
      {required this.icon,
      required this.onPress,
      required this.size,
      required this.color});

  final VoidCallback onPress;
  final IconData icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
      onPressed: onPress,
      elevation: 0.0,
      constraints: BoxConstraints.tightFor(
        width: ScreenUtil().setWidth(size * 3),
        height: ScreenUtil().setHeight(size * 3),
      ),
      shape: const CircleBorder(),
//      fillColor: Colors.white.withOpacity(0.0),
    );
  }
}
