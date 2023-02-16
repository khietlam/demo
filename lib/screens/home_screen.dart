import 'dart:async';

import 'package:camera/camera.dart';
import 'package:demo/screens/camera_screen.dart';
import 'package:demo/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:demo/tflite/recognition.dart';
import 'package:demo/tflite/stats.dart';
import 'package:demo/screens/box_widget.dart';
import 'package:demo/screens/camera_view_singleton.dart';
import 'package:images_picker/images_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../components/custom_icons_icons.dart';
import '../components/custom_route.dart';
import '../data/model_and_label.dart';
import '../services/account_info.dart';
import '../tflite/custom_classifier.dart';
import 'camera_view.dart';
import 'package:demo/components/custom_dialog.dart' as customDialog;

import 'dart:io';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:image/image.dart' as img;
import 'dart:io' as Io;

import 'home.dart';
import 'model_selection_screen.dart';

/// [HomeView] stacks [CameraView] and [BoxWidget]s with bottom sheet for stats
class HomeView extends StatefulWidget {
  String? title;
  File? image;
  Classifier? classifier;
  AccountInfo? account;
  int? modelIndex;

  HomeView({
    super.key,
    this.title,
    this.image,
    this.classifier,
    this.account,
    this.modelIndex,
  });

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  /// Results to draw bounding boxes
  List<Recognition>? _results;

  /// Realtime stats
  Stats? _stats;

  /// Scaffold Key
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // Test with image picker
  File? _image;
  String? _path;
  final _picker = ImagePicker();
  XFile? _pickedFile;

  Classifier? _classifier;
  List<Recognition> _recognitionList = [];

  Stats _displayStats =
      Stats(totalPredictTime: 0, inferenceTime: 0, preProcessingTime: 0);

  Size? _sizeImagePicked;

  bool _isLandScapeImage = false;

  Size? _deviceSize;

  img.Image? _imageInput;

  // List<CameraDescription> _cameras = <CameraDescription>[];
  bool _showSpinner = false;

  int _start = 0;

  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var rmicons = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.up;
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);
  var selectedfABLocation = FloatingActionButtonLocation.startDocked;
  var items = [
    FloatingActionButtonLocation.startFloat,
    FloatingActionButtonLocation.startDocked,
    FloatingActionButtonLocation.centerFloat,
    FloatingActionButtonLocation.endFloat,
    FloatingActionButtonLocation.endDocked,
    FloatingActionButtonLocation.startTop,
    FloatingActionButtonLocation.centerTop,
    FloatingActionButtonLocation.endTop,
  ];

  var _bottomNavIndex = 0; //default index of a first screen

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;

  String? _deviceType;
  AccountInfo _account = AccountInfo();

  int _modelIndex = 0;
  dynamic _pickImageError;

  @override
  void initState() {
    super.initState();
    _image = widget.image;
    _account = widget.account!;
    _modelIndex = widget.modelIndex ?? 0;
    if (widget.classifier == null) {
      Classifier.fileModelName = modelList.elementAt(_modelIndex).fileModelName;
      Classifier.fileLabelName = modelList.elementAt(_modelIndex).fileLabelName;
      _classifier = Classifier();
    } else {
      _classifier = widget.classifier;
    }

    print(
        'check model trang home detail: ${modelList.elementAt(_modelIndex).modelName}');
  }

  // void getDataAndRun() {
  //
  //   if (widget.image != null) {
  //     print('check thoa dieu kien');
  //
  //     setState(() {
  //       _image = widget.image;
  //       _classifier = widget.classifier;
  //       _getImage();
  //     });
  //   }
  // }

  // Future _getImage(ImageSource source) async {
  //   setState(() {
  //     _showSpinner = true;
  //
  //     _imageInput = img.decodeImage(_image!.readAsBytesSync())!;
  //
  //
  //     _sizeImagePicked =
  //         Size(_imageInput!.width.toDouble(), _imageInput!.height.toDouble());
  //
  //     if (_imageInput!.width > _imageInput!.height) {
  //       setState(() {
  //         _isLandScapeImage = true;
  //       });
  //     } else if (_imageInput!.width < _imageInput!.height) {
  //       print('portrait image');
  //       setState(() {
  //         _isLandScapeImage = false;
  //       });
  //     }
  //
  //     _predict(_imageInput!);
  //   });
  //
  //   // setState(() {
  //   //   _image = null;
  //   //   recognitionList = [];
  //   //   sizeImagePicked = null;
  //   //   imageInput = null;
  //   // });
  //
  //   // pickedFile = (await picker.pickImage(source: source))!;
  //   //
  //   // if (pickedFile != null) {
  //   //   setState(() {
  //   //     showSpinner = true;
  //   //     _image = File(pickedFile.path);
  //   //     print(pickedFile.path);
  //   //
  //   //     imageInput = img.decodeImage(_image!.readAsBytesSync())!;
  //   //
  //   //     print('kich thuoc anh raw-width: ${imageInput!.width}');
  //   //     print('kich thuoc anh raw-height: ${imageInput!.height}');
  //   //     print('check deviceSize: $deviceSize');
  //   //
  //   //     sizeImagePicked =
  //   //         Size(imageInput!.width.toDouble(), imageInput!.height.toDouble());
  //   //
  //   //     if (imageInput!.width > imageInput!.height) {
  //   //       setState(() {
  //   //         isLandScapeImage = true;
  //   //       });
  //   //     } else if (imageInput!.width < imageInput!.height) {
  //   //       print('portrait image');
  //   //       setState(() {
  //   //         isLandScapeImage = false;
  //   //       });
  //   //     }
  //   //
  //   //     _predict(imageInput!);
  //   //   });
  //   // }
  // }

  // Future _getImageNew() async {
  //   setState(() {
  //     _image = null;
  //     _recognitionList = [];
  //     _sizeImagePicked = null;
  //     _imageInput = null;
  //   });
  //
  //   List<Media>? res = await ImagesPicker.openCamera(
  //     // pickType: PickType.video,
  //     pickType: PickType.image,
  //     quality: 1,
  //     maxSize: 800,
  //     // cropOpt: CropOption(
  //     //   aspectRatio: CropAspectRatio.wh16x9,
  //     // ),
  //     maxTime: 15,
  //   );
  //   print(res);
  //   if (res != null) {
  //     print(res[0].path);
  //     setState(() {
  //       _path = res[0].thumbPath;
  //     });
  //   }
  //
  //   pickedFile = XFile(_path!);
  //
  //   if (pickedFile != null) {
  //     setState(() {
  //       showSpinner = true;
  //       _image = File(pickedFile.path);
  //       print(pickedFile.path);
  //
  //       imageInput = img.decodeImage(_image!.readAsBytesSync())!;
  //
  //       print('kich thuoc anh raw-width: ${imageInput!.width}');
  //       print('kich thuoc anh raw-height: ${imageInput!.height}');
  //
  //       sizeImagePicked =
  //           Size(imageInput!.width.toDouble(), imageInput!.height.toDouble());
  //
  //       if (imageInput!.width > imageInput!.height) {
  //         setState(() {
  //           isLandScapeImage = true;
  //         });
  //       } else if (imageInput!.width < imageInput!.height) {
  //         print('portrait image');
  //         setState(() {
  //           isLandScapeImage = false;
  //         });
  //       }
  //
  //       _predict(imageInput!);
  //     });
  //   }
  // }

  void _predict(img.Image inputImage) async {
    Map<String, dynamic>? result = _classifier?.predict(inputImage);

    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (result == null && _start < 7) {
        _start = _start + 1;
      } else {
        if (mounted) {
          setState(() {
            timer.cancel();
            _start = 0;
            _showSpinner = false;
            // print('-----------------check----------------:$result');
            _recognitionList = result!['recognitions'];
            _displayStats = result['stats'];

            print('-----------------check----------------:$_recognitionList');
            print(
                '-----------------length----------------:${_recognitionList.length}');
          });
        }
      }
    });
  }

  /// Returns Stack of bounding boxes
  Widget boundingBoxes(List<Recognition> results, Size sizeImagePicked,
      Size deviceSize, bool isLandScape) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results
          .map((e) => BoxWidget(
                result: e,
                sizeImagePicked: sizeImagePicked,
                deviceSize: deviceSize,
                isLandscapeImage: isLandScape,
              ))
          .toList(),
    );
  }

  /// Callback to get inference results from [CameraView]
  void resultsCallback(List<Recognition> results) {
    setState(() {
      _results = results;
    });
  }

  /// Callback to get inference stats from [CameraView]
  void statsCallback(Stats stats) {
    setState(() {
      _stats = stats;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _showProcessing() {
    Fluttertoast.showToast(
      msg: "A.I is processing...",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.green.shade400,
      textColor: Colors.white,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 5,
      webPosition: "center",
      webBgColor: "linear-gradient(to right, #ff7f00, #ff7f00)",
      webShowClose: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    _deviceType = 1.sh / 1.sw > 1.43 ? 'mobile' : 'tablet';
    _deviceSize = MediaQuery.of(context).size;

    // print('check device w: ${deviceSize!.width}');
    // print('check device h: ${deviceSize!.height}');

    return GestureDetector(
      onVerticalDragUpdate: (details) {},
      onHorizontalDragUpdate: (details) {
        if (details.delta.direction > 0) {
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
          debugPrint('swipe left');
        } else if (details.delta.direction <= 0) {
          debugPrint('swipe right');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor('#B28B4B').withOpacity(0.9),
          leading: Container(),
          actions: [
            Container(),
            // IconButton(
            //   onPressed: () async {
            //     setState(() {
            //       _showSpinner = true;
            //     });
            //     await FirebaseAuth.instance.signOut();
            //     Future.delayed(const Duration(seconds: 0)).then((value) {
            //       _showSpinner = false;
            //       Navigator.pushReplacement(
            //           context, FadeRoute(page: WelcomeScreen()));
            //     });
            //   },
            //   icon: const Icon(Icons.exit_to_app_rounded),
            // )
          ],
          title: Text(widget.title!),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: ModalProgressHUD(
          inAsyncCall: _showSpinner,
          progressIndicator: SpinKitFadingFour(
            color: Colors.green.withOpacity(0.6),
            size: 35.0,
            shape: BoxShape.rectangle,
          ),
          child: Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.width),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: Colors.blueGrey.withOpacity(0.5),
                  ),
                ),
                child: Stack(
                  children: [
                    _image == null
                        ? Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image,
                              size: MediaQuery.of(context).size.width,
                              color: Colors.blueGrey.withOpacity(0.5),
                            ),
                          )
                        : Container(
                            constraints: BoxConstraints.expand(
                                height: MediaQuery.of(context).size.width),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: Image.file(_image!).image,
                                fit: _isLandScapeImage
                                    ? BoxFit.fitWidth
                                    : BoxFit.fitHeight,
                                // fit: BoxFit.fitHeight,
                              ),
                            ),
                            // child: _imageWidget,
                          ),
                    _recognitionList.isNotEmpty
                        ? boundingBoxes(_recognitionList, _sizeImagePicked!,
                            _deviceSize!, _isLandScapeImage)
                        : Container(),
                  ],
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _recognitionList.isNotEmpty
                          ? 'Total: ${_recognitionList.length}'
                          : 'Select a photo to run with model ${widget.title}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      _recognitionList.isNotEmpty
                          ? 'Total Predict Time: ${_displayStats.totalPredictTime} ms'
                          : '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    // Text(
                    //   recognitionList.isNotEmpty
                    //       ? 'Inference Time: ${displayStats.inferenceTime} ms'
                    //       : '',
                    //   style: TextStyle(fontSize: 16),
                    // ),
                    // Text(
                    //   recognitionList.isNotEmpty
                    //       ? 'PreProcessing Time: ${displayStats.preProcessingTime} ms'
                    //       : '',
                    //   style: TextStyle(fontSize: 16),
                    // ),
                  ],
                ),
              )
              // Text(
              //   category != null ? category!.label : '',
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              // ),
              // SizedBox(
              //   height: 8,
              // ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(90.0)),
          child: SpeedDial(
            backgroundColor: HexColor('#B28B4B'),
            // icon: Icons.add,
            animatedIcon: AnimatedIcons.menu_close,
            activeIcon: Icons.close,
            spacing: 3,
            openCloseDial: isDialOpen,
            childPadding: EdgeInsets.all(ScreenUtil().setHeight(10.0)),
            spaceBetweenChildren: ScreenUtil().setHeight(60.0),
            dialRoot: customDialRoot
                ? (ctx, open, toggleChildren) {
                    return ElevatedButton(
                      onPressed: toggleChildren,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0B413D),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 18),
                      ),
                      child: Text(
                        "Custom Dial Root",
                        style: TextStyle(
                            // height: 2,
                            fontFamily: 'Inter',
                            fontSize: ScreenUtil().setSp(30.0),
                            color: Colors.lightGreenAccent,
                            letterSpacing: ScreenUtil().setSp(9.0),
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                : null,
            buttonSize: buttonSize,
            // it's the SpeedDial size which defaults to 56 itself
            // iconTheme: IconThemeData(size: 22),
            label: extend ? const Text("Open") : null,
            // The label of the main button.
            /// The active label of the main button, Defaults to label if not specified.
            activeLabel: extend ? const Text("Close") : null,

            /// Transition Builder between label and activeLabel, defaults to FadeTransition.
            // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
            /// The below button size defaults to 56 itself, its the SpeedDial childrens size
            childrenButtonSize: childrenButtonSize,
            visible: visible,
            direction: speedDialDirection,
            switchLabelPosition: switchLabelPosition,

            /// If true user is forced to close dial manually
            closeManually: closeManually,

            /// If false, backgroundOverlay will not be rendered.
            renderOverlay: renderOverlay,
            // overlayColor: Colors.black,
            // overlayOpacity: 0.5,
            // onOpen: () => debugPrint('OPENING DIAL'),
            // onClose: () => debugPrint('DIAL CLOSED'),
            useRotationAnimation: useRAnimation,
            // tooltip: 'Open Speed Dial',
            // heroTag: 'speed-dial-hero-tag',
            // foregroundColor: Colors.black,
            // backgroundColor: Colors.white,
            // activeForegroundColor: Colors.red,
            // activeBackgroundColor: Colors.blue,
            elevation: 5.0,
            isOpenOnStart: false,
            shape: customDialRoot
                ? const RoundedRectangleBorder()
                : const StadiumBorder(),
            // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            children: [
              SpeedDialChild(
                label: 'Photo album',
                labelBackgroundColor: Colors.cyan,
                labelStyle: TextStyle(
                  // height: 2,
                  fontFamily: 'Inter',
                  fontSize: _deviceType == 'mobile'
                      ? ScreenUtil().setSp(35.0)
                      : ScreenUtil().setSp(25.0),
                  color: Colors.white,
                  letterSpacing: ScreenUtil().setSp(6.0),
                ),
                child: Icon(
                  Icons.photo_library_outlined,
                  size: ScreenUtil().setHeight(90),
                ),
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
                visible: true,
                onTap: () async {
                  _getImageFromGallery(ImageSource.gallery);
                },
              ),
              SpeedDialChild(
                label: 'Take a photo',
                labelBackgroundColor: Colors.green.shade400,
                labelStyle: TextStyle(
                  // height: 2,
                  fontFamily: 'Inter',
                  fontSize: _deviceType == 'mobile'
                      ? ScreenUtil().setSp(35.0)
                      : ScreenUtil().setSp(25.0),
                  color: Colors.white,
                  letterSpacing: ScreenUtil().setSp(6.0),
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: ScreenUtil().setHeight(90),
                ),
                backgroundColor: Colors.green.shade400,
                foregroundColor: Colors.white,
                visible: true,
                onTap: () async {
                  _getImageFromCapture();
                },
              ),
              SpeedDialChild(
                label: 'Change model',
                labelBackgroundColor: Colors.blueGrey,
                labelStyle: TextStyle(
                  // height: 2,
                  fontFamily: 'Inter',
                  fontSize: _deviceType == 'mobile'
                      ? ScreenUtil().setSp(35.0)
                      : ScreenUtil().setSp(25.0),
                  color: Colors.white,
                  letterSpacing: ScreenUtil().setSp(6.0),
                ),
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  size: ScreenUtil().setHeight(90),
                ),
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                visible: true,
                onTap: () async {
                  _chooseModel(_modelIndex, _account, _classifier, _image);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _getImageFromGallery(ImageSource source) async {
    _image = null;

    try {
      _pickedFile = (await _picker.pickImage(source: source))!;
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }

    if (_pickedFile != null) {
      _showProcessing();
      _image = File(_pickedFile!.path);
      print(_pickedFile!.path);

      if (_image != null) {
        print('check hang sau gallery');
        setState(() {
          _showSpinner = true;
          _imageInput = img.decodeImage(_image!.readAsBytesSync())!;

          _sizeImagePicked = Size(
              _imageInput!.width.toDouble(), _imageInput!.height.toDouble());

          if (_imageInput!.width > _imageInput!.height) {
            setState(() {
              _isLandScapeImage = true;
            });
          } else if (_imageInput!.width < _imageInput!.height) {
            print('portrait image');
            setState(() {
              _isLandScapeImage = false;
            });
          }

          _predict(_imageInput!);
        });
      }
    }

    // List<Media>? res = await ImagesPicker.pick(
    //   count: 1,
    //   pickType: PickType.image,
    // );

    // print(res);
    // if (res != null) {
    //   print(res[0].path);
    //   _path = res[0].thumbPath;
    //   _pickedFile = XFile(_path!);
    //   _image = File(_pickedFile.path);
    //
    //   setState(() {
    //     _showSpinner = true;
    //     _imageInput = img.decodeImage(_image!.readAsBytesSync())!;
    //
    //     _sizeImagePicked =
    //         Size(_imageInput!.width.toDouble(), _imageInput!.height.toDouble());
    //
    //     if (_imageInput!.width > _imageInput!.height) {
    //       setState(() {
    //         _isLandScapeImage = true;
    //       });
    //     } else if (_imageInput!.width < _imageInput!.height) {
    //       print('portrait image');
    //       setState(() {
    //         _isLandScapeImage = false;
    //       });
    //     }
    //
    //     _predict(_imageInput!);
    //   });
    // }
  }

  Future _getImageFromCapture() async {
    _image = null;
    _path = null;

    List<Media>? res = await ImagesPicker.openCamera(
      // pickType: PickType.video,
      pickType: PickType.image,
      quality: 1,
      maxSize: 1024,
      // cropOpt: CropOption(
      //   aspectRatio: CropAspectRatio.wh16x9,
      // ),
      maxTime: 15,
    );
    print(res);
    if (res != null) {
      _showProcessing();
      print(res[0].path);
      _path = res[0].thumbPath;
      _pickedFile = XFile(_path!);
      _image = File(_pickedFile!.path);
      await ImagesPicker.saveImageToAlbum(File(_pickedFile!.path),
          albumName: "SGA.ai");
      setState(() {
        _showSpinner = true;
        _imageInput = img.decodeImage(_image!.readAsBytesSync())!;
        _sizeImagePicked =
            Size(_imageInput!.width.toDouble(), _imageInput!.height.toDouble());

        if (_imageInput!.width > _imageInput!.height) {
          setState(() {
            _isLandScapeImage = true;
          });
        } else if (_imageInput!.width < _imageInput!.height) {
          print('portrait image');
          setState(() {
            _isLandScapeImage = false;
          });
        }

        _predict(_imageInput!);
      });
    }
  }

  _chooseModel(int? modelIndex, AccountInfo? account, Classifier? classifier,
      File? image) async {
    final modelIndexReturn = await showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return customDialog.AlertDialog(
            titlePadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
//            backgroundColor: Colors.black,
            title: Center(
              child: Text(
                "PLEASE CHOOSE MODEL",
                style: TextStyle(
                    // height: 2,
                    fontFamily: 'Inter',
                    fontSize: _deviceType == 'mobile'
                        ? ScreenUtil().setSp(50.0)
                        : ScreenUtil().setSp(20.0),
                    color: Colors.blueGrey,
                    letterSpacing: ScreenUtil().setSp(9.0),
                    fontWeight: FontWeight.bold),
              ),
            ),
            contentPadding: const EdgeInsets.all(0.0),
            content: ModelSelectionScreen(
              modelIndex: modelIndex,
              classifier: classifier,
              account: account,
              image: image,
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: MaterialButton(
                  elevation: 2,
                  color: HexColor('#B28B4B'),
                  child: Text(
                    "CLOSE",
                    style: TextStyle(
                        // height: 2,
                        fontFamily: 'Inter',
                        fontSize: _deviceType == 'mobile'
                            ? ScreenUtil().setSp(35.0)
                            : ScreenUtil().setSp(25.0),
                        color: Colors.white,
                        letterSpacing: ScreenUtil().setSp(9.0),
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        });

    if (!mounted) return;

    setState(() {
      _modelIndex = modelIndexReturn;
      print('day la index return: $modelIndexReturn');
      // Navigator.pushReplacement(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (BuildContext context) => super.widget));

      Future.delayed(const Duration(seconds: 0)).then((value) {
        Navigator.pushReplacement(
            context,
            FadeRoute(
              page: Home(
                account: _account,
                classifier: _classifier,
                image: _image,
                modelIndex: _modelIndex,
              ),
            ));
      });
    });
  }
}

/// Row for one Stats field
class StatsRow extends StatelessWidget {
  final String left;
  final String right;

  StatsRow(this.left, this.right);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(left), Text(right)],
      ),
    );
  }
}
