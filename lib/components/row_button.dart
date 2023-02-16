import 'package:flutter/material.dart';
import 'package:demo/constraints.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RowButton extends StatelessWidget {
  RowButton(
      {required this.icon,
      required this.title,
      required this.onTap,
      required this.iconSize,
      required this.letterSpacing,
      required this.fontSize});

  final VoidCallback onTap;
  final IconData icon;
  final double iconSize;
  final double fontSize;
  final double letterSpacing;
  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 1.0,
      onPressed: onTap,
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.blueGrey,
          size: iconSize,
        ),
        title: Text(
          title,
          style: TextStyle(
              fontFamily: 'Inter',
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              color: Colors.blueGrey),
        ),
        trailing: Icon(
          Icons.chevron_right,
          size: iconSize,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
