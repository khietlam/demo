import 'dart:io';

import 'package:demo/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:demo/components/button.dart';
import 'package:demo/components/custom_route.dart';

import 'package:demo/screens/signin_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../constraints.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _showSpinner = false;


  late Image imageMobile;
  late Image imageIpad;

  @override
  void initState() {
    super.initState();
    imageMobile = Image.asset("assets/images/background@3x.png");
    imageIpad = Image.asset("assets/images/backgroundIpadPro@3x.png");
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure'),
            content: const Text('Do you want to exit Demo app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);

                  if (Platform.isIOS) {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                        overlays: [
                          SystemUiOverlay.top,
                        ]);
                    SystemChrome.setSystemUIOverlayStyle(
                        const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                    ));
                  } else if (Platform.isAndroid) {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                        overlays: []);
                  }

                  Navigator.of(context).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    precacheImage(imageMobile.image, context);
    precacheImage(imageIpad.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = 1.sh / 1.sw > 1.43 ? 'mobile' : 'tablet';
    return WillPopScope(
      onWillPop: _onWillPop,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: ModalProgressHUD(
            inAsyncCall: _showSpinner,
            child: Container(
              decoration: deviceType == 'mobile'
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: imageMobile.image,
                        fit: BoxFit.cover,
                      ),
                    )
                  : BoxDecoration(
                      image: DecorationImage(
                        image: imageIpad.image,
                        fit: BoxFit.cover,
                      ),
                    ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: 0.015.sh,
                      top: 0.04.sh,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 0.015.sh,
                            top: 0.05.sh,
                          ),
                          child: Text(
                            "Welcome to SGA.ai",
                            style: deviceType == 'mobile'
                                ? kWelcomeTitleBoldWhite
                                : kWelcomeTitleBoldWhiteIPAD,
                          ),
                        ),
                      ],
                    ),
                  ),
//
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: ScreenUtil().setHeight(90),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Button(
                              buttonName: "Sign In",
                              onTap: () {
                                Navigator.push(context,
                                    FadeRoute(page: const SignInScreen()));
                              },
                              buttonColor: Colors.green.shade400,
                              elevation: 1,
                              nameColor: Colors.white,
                              minHeight: 0.06.sh,
                              minWidth: 0.18.sh,
                              fontSize:
                                  deviceType == 'mobile' ? 40.sp : 30.sp,
                              letterSpacing:
                                  deviceType == 'mobile' ? 6.sp : 3.sp,
                            ),
                            SizedBox(width: ScreenUtil().setWidth(90)),
                            Button(
                              buttonName: "Sign Up",
                              onTap: () {
                                Navigator.push(context,
                                    FadeRoute(page: const SignUpScreen()));
                              },
                              buttonColor: Colors.cyan,
                              elevation: 1,
                              nameColor: Colors.white,
                              fontSize:
                                  deviceType == 'mobile' ? 40.sp : 30.sp,
                              letterSpacing:
                                  deviceType == 'mobile' ? 6.sp : 3.sp,
                              minHeight: 0.06.sh,
                              minWidth: 0.18.sh,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: ScreenUtil().setHeight(140),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
