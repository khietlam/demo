import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorizontalItem extends StatelessWidget {
  HorizontalItem(
      {super.key, required this.title, required this.onTap, required this.isTrue});

  String title;
  FocusNode? focus;
  VoidCallback onTap;
  bool isTrue = false;

  @override
  Widget build(index) => Container(
        width: 140,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Material(
            color: Colors.white,
            child: Center(
              child: MaterialButton(
                focusNode: focus,
                elevation: 2.0,
                onPressed: onTap,
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: ScreenUtil().setSp(56.0),
                      color: Colors.blueGrey,
                      letterSpacing: ScreenUtil().setSp(9.0),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      );
}

/// Wrap Ui item with animation & padding
Widget Function(
  BuildContext context,
  int index,
  Animation<double> animation,
) animationItemBuilder(
  Widget Function(int index) child, {
  EdgeInsets padding = EdgeInsets.zero,
}) =>
    (
      BuildContext context,
      int index,
      Animation<double> animation,
    ) =>
        FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, -0.1),
              end: Offset.zero,
            ).animate(animation),
            child: Padding(
              padding: padding,
              child: child(index),
            ),
          ),
        );
