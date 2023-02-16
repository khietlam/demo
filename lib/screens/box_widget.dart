import 'package:flutter/material.dart';
import 'package:demo/tflite/recognition.dart';

/// Individual bounding box
class BoxWidget extends StatelessWidget {
  final Recognition? result;
  final Size? sizeImagePicked;
  final Size? deviceSize;
  final bool? isLandscapeImage;

  const BoxWidget(
      {this.result,
      this.sizeImagePicked,
      this.deviceSize,
      this.isLandscapeImage});

  @override
  Widget build(BuildContext context) {
    // Color for bounding box
    Color color = Colors.primaries[
        (result!.label.length + result!.label.codeUnitAt(0) + result!.id) %
            Colors.primaries.length];

    if (isLandscapeImage!) {
      var smallHeight = deviceSize!.width / sizeImagePicked!.aspectRatio;
      var widthRatio = deviceSize!.width / sizeImagePicked!.width;
      var heightRatio = smallHeight / sizeImagePicked!.height;

      // print(smallHeight);
      // print(widthRatio);
      // print(heightRatio);

      // print('id: ${result.id}');
      // print('check LEFT: ${result.location.left * widthRatio}');
      // print('check TOP: ${(result.location.top * heightRatio +
      //     ((deviceSize.width - smallHeight) / 2))}');
      // print('check WIDTH: ${result.location.width * widthRatio}');
      // print('check HEIGHT: ${result.location.height * heightRatio}');

      return Positioned(
        left: result!.location.left * widthRatio,
        top: result!.location.top * heightRatio +
            ((deviceSize!.width - smallHeight) / 2),
        width: result!.location.width * widthRatio,
        height: result!.location.height * heightRatio,
        child: Container(
          width: result!.location.width * widthRatio,
          height: result!.location.height * heightRatio,
          decoration: BoxDecoration(
              border: Border.all(color: color, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(2))),
          child: Align(
            alignment: Alignment.topLeft,
            child: FittedBox(
              child: Container(
                color: color,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(result!.label),
                    Text(" ${result!.id}-${result!.score.toStringAsFixed(2)}"),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      var smallWidth = deviceSize!.width /
          (sizeImagePicked!.height / sizeImagePicked!.width);
      var heightRatio = deviceSize!.width / sizeImagePicked!.height;
      var widthRatio = smallWidth / sizeImagePicked!.width;

      // print(smallHeight);
      // print(widthRatio);
      // print(heightRatio);

      // print('id: ${result.id}');
      // print('check LEFT: ${result.location.left * widthRatio}');
      // print('check TOP: ${(result.location.top * heightRatio +
      //     ((deviceSize.width - smallHeight) / 2))}');
      // print('check WIDTH: ${result.location.width * widthRatio}');
      // print('check HEIGHT: ${result.location.height * heightRatio}');

      return Positioned(
        left: result!.location.left * heightRatio +
            ((deviceSize!.width - smallWidth) / 2),
        top: result!.location.top * widthRatio,
        width: result!.location.width * widthRatio,
        height: result!.location.height * heightRatio,
        child: Container(
          width: result!.location.width * widthRatio,
          height: result!.location.height * heightRatio,
          decoration: BoxDecoration(
              border: Border.all(color: color, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(2))),
          child: Align(
            alignment: Alignment.topLeft,
            child: FittedBox(
              child: Container(
                color: color,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(result!.label),
                    Text(" ${result!.id}-${result!.score.toStringAsFixed(2)}"),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
