import 'dart:async';
import 'dart:io';

import 'dart:ui';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:demo/data/model_and_label.dart';
import 'package:demo/screens/home_screen.dart';
import 'package:demo/screens/info_screen.dart';
import 'package:demo/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:demo/constraints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:demo/components/custom_dialog.dart' as customDialog;

import 'package:demo/services/account_info.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image/image.dart' as img;

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_offline/flutter_offline.dart';

import '../components/custom_icons_icons.dart';
import '../components/custom_route.dart';
import '../components/utils.dart';
import '../tflite/custom_classifier.dart';
import '../tflite/recognition.dart';
import '../tflite/stats.dart';

const String secure_token = "secure_token";

const EVENTS_KEY = "fetch_events";

class Home extends StatefulWidget {
  Home({
    super.key,
    this.pageIndex,
    this.account,
    this.classifier,
    this.image,
    this.modelIndex,
  });

  int? pageIndex;
  AccountInfo? account;
  Classifier? classifier;
  File? image;
  int? modelIndex;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool _isOffline = false;

  late TabController controller;
  int _pageIndex = 0;

  AccountInfo _account = AccountInfo();

  bool _showSpinner = false;

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

  final _iconList = <IconData>[
    Icons.qr_code_scanner_rounded,
    // Icons.warehouse_outlined,
    // Icons.dashboard_outlined,
    // Icons.filter_b_and_w,
    Icons.info_outline,
  ];

  final _bottomMenuList = <String>[
    'Detection',
    // 'Warehouse',
    // Icons.dashboard_outlined,
    // Icons.filter_b_and_w,
    'Info',
  ];

  File? _image;
  String? _path;
  ImagePicker? _picker = ImagePicker();
  late XFile _pickedFile;

  Size? _deviceSize;
  Classifier? _classifier;

  // var index = modelList.indexWhere(
  //         (Model) => Mode.locale == EasyLocalization.of(context)?.locale);
  // selectedIndex = index;

  int _modelIndex = 0;
  dynamic _pickImageError;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _image = widget.image;
    _account = widget.account!;
    _modelIndex = widget.modelIndex ?? 0;
    Classifier.fileModelName = modelList.elementAt(_modelIndex).fileModelName;
    Classifier.fileLabelName = modelList.elementAt(_modelIndex).fileLabelName;
    _classifier = Classifier();
    print('check model: ${modelList.elementAt(_modelIndex).modelName}');

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    controller = TabController(length: 2, vsync: this);

    _pageIndex = widget.pageIndex ?? 0;
    controller.index = _pageIndex;

    // final systemTheme = SystemUiOverlayStyle.light.copyWith(
    //   systemNavigationBarColor: HexColor('#373A36'),
    //   systemNavigationBarIconBrightness: Brightness.light,
    // );
    // SystemChrome.setSystemUIOverlayStyle(systemTheme);
    //
    // _fabAnimationController = AnimationController(
    //   duration: const Duration(milliseconds: 100),
    //   vsync: this,
    // );
    // _borderRadiusAnimationController = AnimationController(
    //   duration: const Duration(milliseconds: 100),
    //   vsync: this,
    // );
    // fabCurve = CurvedAnimation(
    //   parent: _fabAnimationController,
    //   curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    // );
    // borderRadiusCurve = CurvedAnimation(
    //   parent: _borderRadiusAnimationController,
    //   curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    // );
    //
    // fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    // borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
    //   borderRadiusCurve,
    // );
    //
    // _hideBottomBarAnimationController = AnimationController(
    //   duration: const Duration(milliseconds: 100),
    //   vsync: this,
    // );
    //
    // Future.delayed(
    //   const Duration(seconds: 1),
    //   () => _fabAnimationController.forward(),
    // );
    // Future.delayed(
    //   const Duration(seconds: 1),
    //   () => _borderRadiusAnimationController.forward(),
    // );
  }

  void showErrorNetwork() {
    Fluttertoast.showToast(
      msg: "errors.error_network",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      gravity: ToastGravity.CENTER,
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to logout Demo app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => logOut(),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void _showSuccess() {
    Fluttertoast.showToast(
      msg: "Logged out successfully!",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.green.shade400,
      textColor: Colors.white,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      webPosition: "center",
      webBgColor: "linear-gradient(to right, #ff7f00, #ff7f00)",
      webShowClose: true,
    );
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    print('xong GG');
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      webPosition: "center",
      webBgColor: "linear-gradient(to right, #ff7f00, #ff7f00)",
      webShowClose: true,
    );
  }

  void logOut() {
    setState(() {
      _showSpinner = true;
    });

    try {
      if (_account.user!.uid != null) {
        FirebaseAuth.instance.signOut();
        print('xong Firebase');
      }

      if (_account.googleSignIn != null) {
        signOutFromGoogle();
      }

      _showSuccess();

      Future.delayed(const Duration(seconds: 1)).then((value) {
        _showSpinner = false;
        Navigator.pushReplacement(context, FadeRoute(page: WelcomeScreen()));
      });
    } on FirebaseAuthException catch (e) {
      // print(e.message);
      _showErrorMessage(e.message!);
      setState(() {
        _showSpinner = false;
      });
      throw e;
    } on Error catch (e) {
      print(e);
      setState(() {
        _showSpinner = false;
      });
    }
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    debugPrint('da dispose trang Home');
    super.dispose();
  }

  String? deviceType;

  @override
  Widget build(BuildContext context) {
    deviceType = 1.sh / 1.sw > 1.43 ? 'mobile' : 'tablet';

    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final bool connected = connectivity != ConnectivityResult.none;
        _isOffline = !connected;
        // debugPrint(isOffline);
        // if (!connected) {
        //   showErrorNetwork();
        // }
        return child;
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Scaffold(
            body: ModalProgressHUD(
              inAsyncCall: _showSpinner,
              progressIndicator: SpinKitFadingFour(
                color: Colors.green.withOpacity(0.6),
                size: 35.0,
                shape: BoxShape.rectangle,
              ),
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                // Add tabs as widgets
                controller: controller,
                // Add tabs as widgets
                children: <Widget>[
                  HomeView(
                    title: modelList.elementAt(_modelIndex).modelName,
                    image: _image,
                    classifier: _classifier,
                    account: _account,
                    modelIndex: _modelIndex,
                  ),
                  // HomeView(
                  //   title: modelList.elementAt(_modelIndex).modelName,
                  //   image: _image,
                  //   classifier: _classifier,
                  //   account: _account,
                  //   modelIndex: _modelIndex,
                  // ),
                  InfoScreen(
                    title: modelList.elementAt(_modelIndex).modelName,
                    image: _image,
                    classifier: _classifier,
                    account: _account,
                    modelIndex: _modelIndex,
                  ),
                ],
              ),
            ),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.endDocked,
            bottomNavigationBar:
                // Container(
                //   color: Colors.transparent,
                //   child: AnimatedBottomNavigationBar.builder(
                //     itemCount: _bottomMenuList.length,
                //     tabBuilder: (int index, bool isActive) {
                //       final color = isActive
                //           ? HexColor('#F4D19B')
                //           : Colors.blueGrey.withOpacity(0.6);
                //
                //       return Column(
                //         mainAxisSize: MainAxisSize.min,
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Icon(
                //             _iconList[index],
                //             size: 0.035.sh,
                //             color: color,
                //           ),
                //           const SizedBox(height: 4),
                //           Padding(
                //             padding: const EdgeInsets.symmetric(horizontal: 8),
                //             child: AutoSizeText(
                //               _bottomMenuList[index],
                //               maxLines: 1,
                //               style: TextStyle(color: color),
                //             ),
                //           )
                //         ],
                //       );
                //     },
                //     backgroundColor: HexColor('#222F33'),
                //     activeIndex: _bottomNavIndex,
                //     splashColor: HexColor('#FFA400'),
                //     notchAndCornersAnimation: borderRadiusAnimation,
                //     splashSpeedInMilliseconds: 300,
                //     notchSmoothness: NotchSmoothness.defaultEdge,
                //     gapLocation: GapLocation.end,
                //     leftCornerRadius: 0,
                //     rightCornerRadius: 0,
                //     onTap: (index) {
                //       setState(() {
                //         _bottomNavIndex = index;
                //         controller.index = index;
                //         debugPrint('check index $index');
                //         debugPrint('controller index ${controller.index}');
                //       });
                //     },
                //     hideAnimationController: _hideBottomBarAnimationController,
                //     shadow: const BoxShadow(
                //       offset: Offset(0, 1),
                //       blurRadius: 12,
                //       spreadRadius: 0.5,
                //       color: Colors.grey,
                //     ),
                //   ),
                // ),
                Material(
              elevation: 5.0,
              shadowColor: Colors.grey,
              color: HexColor('#222F33'),
              child: TabBar(
                labelPadding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(15.0),
                    right: ScreenUtil().setWidth(15.0),
                    bottom: 0.001.sh,
                    top: 0.001.sh),
                indicatorPadding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(45.0),
                    right: ScreenUtil().setWidth(45.0)),
                labelStyle: kTabbar,
                controller: controller,
                indicatorWeight: 4.0,
                indicatorColor: HexColor('#F4D19B'),
                labelColor: HexColor('#F4D19B'),
                unselectedLabelColor: Colors.blueGrey.withOpacity(0.6),
                tabs: const <Widget>[
                  Tab(
                      text: 'Detection',
                      icon: Icon(
                        Icons.qr_code_scanner_rounded,
                      )),
                  Tab(
                    text: 'Info',
                    icon: Icon(
                      Icons.info_outline,
                    ),
                  ),
                ],
              ),
            ),
            // floatingActionButton: SpeedDial(
            //   backgroundColor: HexColor('#B28B4B'),
            //   // icon: Icons.add,
            //   animatedIcon: AnimatedIcons.menu_close,
            //   activeIcon: Icons.close,
            //   spacing: 3,
            //   openCloseDial: isDialOpen,
            //   childPadding: EdgeInsets.all(ScreenUtil().setHeight(10.0)),
            //   spaceBetweenChildren: ScreenUtil().setHeight(60.0),
            //   dialRoot: customDialRoot
            //       ? (ctx, open, toggleChildren) {
            //           return ElevatedButton(
            //             onPressed: toggleChildren,
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: const Color(0xff0B413D),
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 22, vertical: 18),
            //             ),
            //             child: Text(
            //               "Custom Dial Root",
            //               style: TextStyle(
            //                   // height: 2,
            //                   fontFamily: 'Inter',
            //                   fontSize: ScreenUtil().setSp(30.0),
            //                   color: Colors.lightGreenAccent,
            //                   letterSpacing: ScreenUtil().setSp(9.0),
            //                   fontWeight: FontWeight.bold),
            //             ),
            //           );
            //         }
            //       : null,
            //   buttonSize: buttonSize,
            //   // it's the SpeedDial size which defaults to 56 itself
            //   // iconTheme: IconThemeData(size: 22),
            //   label: extend ? const Text("Open") : null,
            //   // The label of the main button.
            //   /// The active label of the main button, Defaults to label if not specified.
            //   activeLabel: extend ? const Text("Close") : null,
            //
            //   /// Transition Builder between label and activeLabel, defaults to FadeTransition.
            //   // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
            //   /// The below button size defaults to 56 itself, its the SpeedDial childrens size
            //   childrenButtonSize: childrenButtonSize,
            //   visible: visible,
            //   direction: speedDialDirection,
            //   switchLabelPosition: switchLabelPosition,
            //
            //   /// If true user is forced to close dial manually
            //   closeManually: closeManually,
            //
            //   /// If false, backgroundOverlay will not be rendered.
            //   renderOverlay: renderOverlay,
            //   // overlayColor: Colors.black,
            //   // overlayOpacity: 0.5,
            //   // onOpen: () => debugPrint('OPENING DIAL'),
            //   // onClose: () => debugPrint('DIAL CLOSED'),
            //   useRotationAnimation: useRAnimation,
            //   // tooltip: 'Open Speed Dial',
            //   // heroTag: 'speed-dial-hero-tag',
            //   // foregroundColor: Colors.black,
            //   // backgroundColor: Colors.white,
            //   // activeForegroundColor: Colors.red,
            //   // activeBackgroundColor: Colors.blue,
            //   elevation: 5.0,
            //   isOpenOnStart: false,
            //   shape: customDialRoot
            //       ? const RoundedRectangleBorder()
            //       : const StadiumBorder(),
            //   // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //   children: [
            //     SpeedDialChild(
            //       label: 'Photo album',
            //       labelBackgroundColor: Colors.cyan,
            //       labelStyle: TextStyle(
            //         // height: 2,
            //         fontFamily: 'Inter',
            //         fontSize: deviceType == 'mobile'
            //             ? ScreenUtil().setSp(35.0)
            //             : ScreenUtil().setSp(25.0),
            //         color: Colors.white,
            //         letterSpacing: ScreenUtil().setSp(6.0),
            //       ),
            //       child: Icon(
            //         Icons.photo_library_outlined,
            //         size: ScreenUtil().setHeight(90),
            //       ),
            //       backgroundColor: Colors.cyan,
            //       foregroundColor: Colors.white,
            //       visible: true,
            //       onTap: () async {
            //         _getImageFromGallery(ImageSource.gallery);
            //       },
            //     ),
            //     SpeedDialChild(
            //       label: 'Take a photo',
            //       labelBackgroundColor: Colors.lightGreen,
            //       labelStyle: TextStyle(
            //         // height: 2,
            //         fontFamily: 'Inter',
            //         fontSize: deviceType == 'mobile'
            //             ? ScreenUtil().setSp(35.0)
            //             : ScreenUtil().setSp(25.0),
            //         color: Colors.white,
            //         letterSpacing: ScreenUtil().setSp(6.0),
            //       ),
            //       child: Icon(
            //         Icons.camera_alt_outlined,
            //         size: ScreenUtil().setHeight(90),
            //       ),
            //       backgroundColor: Colors.lightGreen,
            //       foregroundColor: Colors.white,
            //       visible: true,
            //       onTap: () async {
            //         _getImageFromCapture();
            //       },
            //     ),
            //     SpeedDialChild(
            //       label: 'Choose model',
            //       labelBackgroundColor: Colors.blueGrey,
            //       labelStyle: TextStyle(
            //         // height: 2,
            //         fontFamily: 'Inter',
            //         fontSize: deviceType == 'mobile'
            //             ? ScreenUtil().setSp(35.0)
            //             : ScreenUtil().setSp(25.0),
            //         color: Colors.white,
            //         letterSpacing: ScreenUtil().setSp(6.0),
            //       ),
            //       child: Icon(
            //         Icons.remove_red_eye_outlined,
            //         size: ScreenUtil().setHeight(90),
            //       ),
            //       backgroundColor: Colors.blueGrey,
            //       foregroundColor: Colors.white,
            //       visible: true,
            //       onTap: () async {
            //         _chooseModel(_modelIndex, _account, _classifier, _image);
            //       },
            //     ),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }

// Future _getImageFromGallery(ImageSource source) async {
//   _image = null;
//
//   try {
//     _pickedFile = (await _picker!.pickImage(source: source))!;
//   } catch (e) {
//     setState(() {
//       _pickImageError = e;
//     });
//   }
//
//
//   // List<Media>? res = await ImagesPicker.pick(
//   //   count: 1,
//   //   pickType: PickType.image,
//   // );
//
//   // if (res != null) {
//   //   print(res[0].path);
//   //   _path = res[0].thumbPath;
//   //
//   //   _pickedFile = XFile(_path!);
//   //   _image = File(_pickedFile.path);
//   //   if (_image != null) {
//   //     print('check hang sau camera');
//   //     Future.delayed(const Duration(seconds: 0)).then((value) {
//   //       Navigator.pushReplacement(
//   //           context,
//   //           FadeRoute(
//   //             page: Home(
//   //               account: _account,
//   //               classifier: _classifier,
//   //               image: _image,
//   //               modelIndex: _modelIndex,
//   //             ),
//   //           ));
//   //     });
//   //   }
//   // }
//
//
//   if (_pickedFile != null) {
//     _image = File(_pickedFile.path);
//     print(_pickedFile.path);
//
//     if (_image != null) {
//       print('check hang sau gallery');
//
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (BuildContext context) => super.widget));
//
//       // Future.delayed(const Duration(seconds: 0)).then((value) {
//         // Navigator.pushReplacement(
//         //     context,
//         //     FadeRoute(
//         //       page: Home(
//         //         account: _account,
//         //         classifier: _classifier,
//         //         image: _image,
//         //         modelIndex: _modelIndex,
//         //       ),
//         //     ));
//
//
//       // });
//     }
//
//   }
//
// }

// Future _getImageFromCapture() async {
//   _image = null;
//   _path = null;
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
//     _path = res[0].thumbPath;
//
//     _pickedFile = XFile(_path!);
//     _image = File(_pickedFile.path);
//     if (_image != null) {
//       print('check hang sau camera');
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (BuildContext context) => super.widget));
//       // Future.delayed(const Duration(seconds: 0)).then((value) {
//       //   Navigator.pushReplacement(
//       //       context,
//       //       FadeRoute(
//       //         page: Home(
//       //           account: _account,
//       //           classifier: _classifier,
//       //           image: _image,
//       //           modelIndex: _modelIndex,
//       //         ),
//       //       ));
//       // });
//     }
//   }
// }

//   _chooseModel(int? modelIndex, AccountInfo? account, Classifier? classifier,
//       File? image) async {
//     showDialog(
//         context: context,
//         barrierColor: Colors.black.withOpacity(0.9),
//         builder: (BuildContext context) {
//           //Here we will build the content of the dialog
//           return customDialog.AlertDialog(
//             titlePadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//             shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0))),
// //            backgroundColor: Colors.black,
//             title: Center(
//               child: Text(
//                 "PLEASE CHOOSE MODEL",
//                 style: TextStyle(
//                     // height: 2,
//                     fontFamily: 'Inter',
//                     fontSize: deviceType == 'mobile'
//                         ? ScreenUtil().setSp(50.0)
//                         : ScreenUtil().setSp(20.0),
//                     color: Colors.blueGrey,
//                     letterSpacing: ScreenUtil().setSp(9.0),
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//             contentPadding: const EdgeInsets.all(0.0),
//             content: ModelSelectionScreen(
//               modelIndex: modelIndex,
//               classifier: classifier,
//               account: account,
//               image: image,
//             ),
//             actions: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(right: 5),
//                 child: MaterialButton(
//                   elevation: 2,
//                   color: HexColor('#B28B4B'),
//                   child: Text(
//                     "CLOSE",
//                     style: TextStyle(
//                         // height: 2,
//                         fontFamily: 'Inter',
//                         fontSize: deviceType == 'mobile'
//                             ? ScreenUtil().setSp(35.0)
//                             : ScreenUtil().setSp(25.0),
//                         color: Colors.white,
//                         letterSpacing: ScreenUtil().setSp(9.0),
//                         fontWeight: FontWeight.bold),
//                   ),
//                   onPressed: () async {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ),
//             ],
//           );
//         });
//   }
}
