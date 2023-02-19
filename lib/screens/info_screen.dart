import 'package:demo/screens/about_screen.dart';
import 'package:demo/screens/change_password_screen.dart';
import 'package:demo/screens/contact_us_screen.dart';
import 'package:demo/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:demo/constraints.dart';

import 'package:demo/components/custom_icons_icons.dart';
import 'package:demo/components/button.dart';
import 'package:demo/components/row_button.dart';
import 'package:demo/components/custom_route.dart';

import 'package:demo/services/account_info.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_offline/flutter_offline.dart';

import '../tflite/custom_classifier.dart';
import 'home.dart';

const String secure_token = "secure_token";

class InfoScreen extends StatefulWidget {
  InfoScreen({
    super.key,
    this.title,
    this.image,
    this.classifier,
    this.account,
    this.modelIndex,
  });

  String? title;
  File? image;
  Classifier? classifier;
  AccountInfo? account;
  int? modelIndex;

  // final GoogleSignIn googleSignIn;
  // final FacebookLogin facebookLogin;

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  bool _isOffline = false;

  bool _showSpinner = false;
  AccountInfo _account = AccountInfo();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _account = widget.account!;
    print(_account.user);
    print(_account.googleSignIn);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    super.dispose();
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
  Widget build(BuildContext context) {
    final deviceType = 1.sh / 1.sw > 1.43 ? 'mobile' : 'tablet';

    return WillPopScope(
      onWillPop: () async => false,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor('#B28B4B').withOpacity(0.9), //aaa
            leading: Container(),
            actions: [
              IconButton(
                onPressed: () async {
                  logOut();
                },
                icon: const Icon(Icons.exit_to_app_rounded),
              )
            ],
            title: const Text('Info'),
          ),
          resizeToAvoidBottomInset: false,
          body: ModalProgressHUD(
            inAsyncCall: _showSpinner,
            progressIndicator: SpinKitFadingFour(
              color: Colors.green.withOpacity(0.6),
              size: 35.0,
              shape: BoxShape.rectangle,
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: ScreenUtil().setHeight(120.0),
                      ),
                      RowButton(
                        icon: Icons.password_outlined,
                        title: 'Change Password',
                        iconSize: ScreenUtil().setHeight(70.0),
                        fontSize: deviceType == 'mobile' ? 48.sp : 32.sp,
                        letterSpacing: deviceType == 'mobile' ? 6.sp : 3.sp,
                        onTap: () {
                          Future.delayed(const Duration(seconds: 0))
                              .then((value) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChangePasswordScreen(
                                  title: widget.title,
                                  image: widget.image,
                                  classifier: widget.classifier,
                                  account: _account,
                                  modelIndex: widget.modelIndex,
                                ),
                              ),
                            );
                          });
                        },
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(30.0),
                      ),
                      RowButton(
                        icon: Icons.info_outline,
                        title: 'About Us',
                        iconSize: ScreenUtil().setHeight(70.0),
                        fontSize: deviceType == 'mobile' ? 48.sp : 32.sp,
                        letterSpacing: deviceType == 'mobile' ? 6.sp : 3.sp,
                        onTap: () {
                          Future.delayed(const Duration(seconds: 0))
                              .then((value) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AboutScreen(),
                              ),
                            );
                          });
                        },
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(30.0),
                      ),
                      RowButton(
                        icon: Icons.phone,
                        title: 'Contact Us',
                        iconSize: ScreenUtil().setHeight(70.0),
                        fontSize: deviceType == 'mobile' ? 48.sp : 32.sp,
                        letterSpacing: deviceType == 'mobile' ? 6.sp : 3.sp,
                        onTap: () {
                          Future.delayed(const Duration(seconds: 0))
                              .then((value) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ContactUsScreen(),
                              ),
                            );
                          });
                        },
                      ),
                    ],
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
