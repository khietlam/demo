import 'dart:async';
import 'dart:io';

import 'dart:ui';

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
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_offline/flutter_offline.dart';

import '../components/custom_icons_icons.dart';
import '../components/custom_route.dart';
import '../tflite/custom_classifier.dart';


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
  Classifier? _classifier;

  int _modelIndex = 0;

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
    // print('check model: ${modelList.elementAt(_modelIndex).modelName}');

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    controller = TabController(length: 2, vsync: this);

    _pageIndex = widget.pageIndex ?? 0;
    controller.index = _pageIndex;
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
    // print('xong GG');
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
        // print('xong Firebase');
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
      // print(e);
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

    return WillPopScope(
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
              physics: const NeverScrollableScrollPhysics(),
              // Add tabs as widgets
              controller: controller,
              // Add tabs as widgets
              children: <Widget>[
                HomeScreen(
                  title: modelList.elementAt(_modelIndex).modelName,
                  image: _image,
                  classifier: _classifier,
                  account: _account,
                  modelIndex: _modelIndex,
                ),
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
          bottomNavigationBar: Material(
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
        ),
      ),
    );
  }
}
