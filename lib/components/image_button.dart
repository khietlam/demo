import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({super.key,
    required this.imagePath,
    required this.onPress,
    required this.size,
  });

  final VoidCallback onPress;
  final String imagePath;
  final double size;

//  final Color color;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Image.asset(imagePath),
      onPressed: onPress,
      elevation: 2.0,
      constraints: BoxConstraints.tightFor(
        width: size,
        height: size,
      ),
      shape: const RoundedRectangleBorder(),
//      fillColor: color,
    );
  }
}
