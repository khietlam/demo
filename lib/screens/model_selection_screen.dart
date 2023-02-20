import 'dart:io';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/custom_icons_icons.dart';
import '../utils/utils.dart';
import '../data/model_and_label.dart';
import '../services/account_info.dart';
import '../tflite/custom_classifier.dart';

class ModelSelectionScreen extends StatefulWidget {
  ModelSelectionScreen(
      {Key? key, this.modelIndex, this.account, this.classifier, this.image})
      : super(key: key);

  int? modelIndex;
  AccountInfo? account;
  Classifier? classifier;
  File? image;

  @override
  _ModelSelectionScreenState createState() => _ModelSelectionScreenState();
}

class _ModelSelectionScreenState extends State<ModelSelectionScreen> {
  bool isOffline = false;

  int? _checkedIndex;

  String? deviceType;
  AccountInfo? _account;
  Classifier? _classifier;
  File? _image;

  @override
  void initState() {
    super.initState();
    _checkedIndex = widget.modelIndex;
    _account = widget.account;
    _classifier = widget.classifier;
    _image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    deviceType = 1.sh / 1.sw > 1.43 ? 'mobile' : 'tablet';

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: Container(
          color: Colors.blueGrey,
          height: height,
          width: width,
          child: LiveList(
            showItemInterval: const Duration(milliseconds: 150),
            showItemDuration: const Duration(milliseconds: 350),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            reAnimateOnVisibility: true,
            scrollDirection: Axis.vertical,
            itemCount: modelList.length,
            itemBuilder: animationItemBuilder((index) => buildCard(index)),
          ),
        ),
      ),
    );
  }

  Widget buildCard(int index) {
    bool checked = index == _checkedIndex;
    String name = modelList[index].modelName!;
    return GestureDetector(
      onTap: () async {
        setState(() {
          _checkedIndex = index;
          // print(index);
          Navigator.pop(context, _checkedIndex);

        });
      },
      child: Stack(
        children: [
          Card(
            color:
                checked ? HexColor('#B28B4B').withOpacity(0.9) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(10.0),
                horizontal: ScreenUtil().setWidth(30.0),
              ),
              height: ScreenUtil().setHeight(180.0),
              child: Center(
                  child: Text(
                name,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: deviceType == 'mobile'
                        ? ScreenUtil().setSp(45.0)
                        : ScreenUtil().setSp(28.0),
                    color: checked ? Colors.white : Colors.blueGrey,
                    letterSpacing: ScreenUtil().setSp(3.0),
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
