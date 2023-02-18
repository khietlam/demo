import 'dart:io';

import 'package:demo/screens/home.dart';
import 'package:demo/screens/home_screen.dart';
import 'package:demo/services/account_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:demo/utils/firebase_auth_utils.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../components/button.dart';
import '../components/custom_back_button.dart';
import '../components/custom_icons_icons.dart';
import '../components/custom_route.dart';
import '../constraints.dart';
import '../tflite/custom_classifier.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({
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

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late FocusNode focusPassword, focusButton;

  bool _isProcessing = false;
  bool _showSpinner = false;
  bool _isOffline = false;
  late Image imageMobile;
  late Image imageIpad;

  AccountInfo _account = AccountInfo();

  FormGroup buildForm() => fb.group(<String, Object>{
        'currentPassword': ['', Validators.required, Validators.minLength(6)],
        'newPassword': ['', Validators.required, Validators.minLength(6)],
      });

  void _showErrorNetwork() {
    Fluttertoast.showToast(
      msg: "errors.error_network",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      webPosition: "center",
      webBgColor: "linear-gradient(to right, #ff7f00, #ff7f00)",
      webShowClose: true,
    );
  }

  void _showSuccess() {
    Fluttertoast.showToast(
      msg: "New password is updated successfully!",
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _account = widget.account!;
    print(_account.user);

    focusPassword = FocusNode();
    focusButton = FocusNode();
    imageMobile = Image.asset("assets/images/background@3x.png");
    imageIpad = Image.asset("assets/images/backgroundIpadPro@3x.png");
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusPassword.dispose();
    focusButton.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    precacheImage(imageMobile.image, context);
    precacheImage(imageIpad.image, context);
    super.didChangeDependencies();
  }

  void showErrorMessage(String message) {
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

  @override
  Widget build(BuildContext context) {
    final deviceType = 1.sh / 1.sw > 1.43 ? 'mobile' : 'tablet';

    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final bool connected = connectivity != ConnectivityResult.none;
        _isOffline = !connected;
        // debugPrint(isOffline);
        if (!connected) {
          _showErrorNetwork();
        }
        return child;
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: ModalProgressHUD(
              inAsyncCall: _showSpinner,
              progressIndicator: const CircularProgressIndicator(
                color: Colors.green,
                strokeWidth: 2.0,
              ),
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
                child: ReactiveFormBuilder(
                  form: buildForm,
                  builder: (context, form, child) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: 0.015.sh,
                            top: 0.04.sh,
                          ),
                          child: CustomBackButton(),
                        ),
                        Flexible(
                          child: SizedBox(
                            height: ScreenUtil().setHeight(260),
                          ),
                        ),
                        Container(
                          // Vien cach le trai 10px
                          margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(30.0),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.8),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            border: Border.all(
                              color: Colors.white70,
                              width: 0.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
//                             // Cach le trai 10px
                                margin: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(30.0),
                                ),
                                height: ScreenUtil().setHeight(150.0),
                                // Vien day duoi textbox
                                decoration: kTextFormDecoration,

                                child: ReactiveTextField<String>(
                                  onTap: (control) {
                                    // FocusScopeNode currentFocus =
                                    //     FocusScope.of(context);
                                    //
                                    // if (!currentFocus.hasPrimaryFocus) {
                                    //   currentFocus.unfocus();
                                    // }
                                  },
                                  formControlName: 'currentPassword',
                                  obscureText: true,
                                  maxLines: 1,
                                  onSubmitted: (control) {
                                    FocusScope.of(context)
                                        .requestFocus(focusPassword);
                                  },
                                  validationMessages: {
                                    ValidationMessage.required: (_) =>
                                        'Password can\'t be empty',
                                    ValidationMessage.minLength: (_) =>
                                        'Enter a password with length at least 6',
                                  },
                                  textInputAction: Platform.isIOS
                                      ? TextInputAction.next
                                      : TextInputAction.go,
                                  style: deviceType == 'mobile'
                                      ? kFormLoginActive
                                      : kFormLoginActiveIPAD,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 0,
                                        top: ScreenUtil().setHeight(10.0),
                                        right: 0,
                                        bottom: ScreenUtil().setHeight(16.0)),
                                    alignLabelWithHint: true,
                                    labelText: 'Current Password',
                                    floatingLabelStyle: deviceType == 'mobile'
                                        ? kfloatingLabelStyle
                                        : kfloatingLabelStyleIPAD,
                                    labelStyle: deviceType == 'mobile'
                                        ? kFormLoginInactive
                                        : kFormLoginInactiveIPAD,
                                    border: InputBorder.none,
                                    helperText: '',
                                    helperStyle: const TextStyle(height: 0.7),
                                    errorStyle: deviceType == 'mobile'
                                        ? kerrorStyle
                                        : kerrorStyleIPAD,
                                    icon: Padding(
                                      padding: EdgeInsets.fromLTRB(0,
                                          ScreenUtil().setHeight(25.0), 0, 0),
                                      child: Icon(
                                        CustomIcons.lock,
                                        color: Colors.white70,
                                        size: ScreenUtil().setHeight(60.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
//                             // Cach le trai 10px
                                margin: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(30.0),
                                ),
                                height: ScreenUtil().setHeight(150.0),
                                // Vien day duoi textbox
                                decoration: kTextFormDecoration,

                                child: ReactiveTextField<String>(
                                  onTap: (control) {
                                    // FocusScopeNode currentFocus =
                                    //     FocusScope.of(context);
                                    //
                                    // if (!currentFocus.hasPrimaryFocus) {
                                    //   currentFocus.unfocus();
                                    // }
                                  },
                                  focusNode: focusPassword,
                                  formControlName: 'newPassword',
                                  obscureText: true,
                                  maxLines: 1,
                                  onSubmitted: (control) {
                                    FocusScope.of(context)
                                        .requestFocus(focusButton);
                                  },
                                  validationMessages: {
                                    ValidationMessage.required: (_) =>
                                    'Password can\'t be empty',
                                    ValidationMessage.minLength: (_) =>
                                    'Enter a password with length at least 6',
                                  },
                                  textInputAction: Platform.isIOS
                                      ? TextInputAction.next
                                      : TextInputAction.go,
                                  style: deviceType == 'mobile'
                                      ? kFormLoginActive
                                      : kFormLoginActiveIPAD,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 0,
                                        top: ScreenUtil().setHeight(10.0),
                                        right: 0,
                                        bottom: ScreenUtil().setHeight(16.0)),
                                    alignLabelWithHint: true,
                                    labelText: 'New Password',
                                    floatingLabelStyle: deviceType == 'mobile'
                                        ? kfloatingLabelStyle
                                        : kfloatingLabelStyleIPAD,
                                    labelStyle: deviceType == 'mobile'
                                        ? kFormLoginInactive
                                        : kFormLoginInactiveIPAD,
                                    border: InputBorder.none,
                                    helperText: '',
                                    helperStyle: const TextStyle(height: 0.7),
                                    errorStyle: deviceType == 'mobile'
                                        ? kerrorStyle
                                        : kerrorStyleIPAD,
                                    icon: Padding(
                                      padding: EdgeInsets.fromLTRB(0,
                                          ScreenUtil().setHeight(25.0), 0, 0),
                                      child: Icon(
                                        CustomIcons.lock,
                                        color: Colors.white70,
                                        size: ScreenUtil().setHeight(60.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(90),
                        ),
                        Button(
                          focus: focusButton,
                          buttonName: 'Update',
                          minHeight: 0.06.sh,
                          minWidth: 0.18.sh,
                          onTap: () async {
                            FocusScope.of(context).unfocus();

                            if (form.valid) {
                              setState(() {
                                _showSpinner = true;
                              });
                              // print(form.value);
                              Map<String, dynamic> formOut = form.value;
                              _account.password = formOut['currentPassword']
                                  .replaceAll(' ', '');
                              _account.newPassword =
                                  formOut['newPassword'].replaceAll(' ', '');

                              print(_account.user!.email);
                              print(_account.password);
                              print(_account.newPassword);

                              if (_isOffline) {
                                _showErrorNetwork();
                              } else {
                                User? user = FirebaseAuth.instance.currentUser;

                                final cred = await EmailAuthProvider.credential(
                                    email: user!.email!,
                                    password: _account.password);

                                await user
                                    .reauthenticateWithCredential(cred)
                                    .then((value) async {
                                  await user
                                      .updatePassword(_account.newPassword)
                                      .then((_) {
                                    _account.user = user;
                                    _showSuccess();
                                    Future.delayed(const Duration(seconds: 1))
                                        .then((value) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => Home(
                                            account: _account,
                                            pageIndex: 1,
                                            classifier: widget.classifier,
                                            image: widget.image,
                                            modelIndex: widget.modelIndex,
                                          ),
                                        ),
                                      );
                                    });

                                    setState(() {
                                      _showSpinner = false;
                                    });
                                    print(user);
                                  }).catchError((error) {
                                    _showErrorMessage(error.toString());
                                    print(error);
                                    setState(() {
                                      _showSpinner = false;
                                    });
                                  });
                                }).catchError((err) {
                                  _showErrorMessage(err.toString());

                                  print(err);
                                  setState(() {
                                    _showSpinner = false;
                                  });
                                });
                              }
                            } else {
                              form.markAllAsTouched();
                            }
                          },
                          buttonColor: Colors.cyan,
                          elevation: 1,
                          nameColor: Colors.white,
                          fontSize: deviceType == 'mobile' ? 40.sp : 30.sp,
                          letterSpacing: deviceType == 'mobile' ? 6.sp : 3.sp,
                        ),
                        Flexible(
                          child: SizedBox(
                            height: ScreenUtil().setHeight(380),
                          ),
                        ),
//                Column(
//                  children: <Widget>[
//                    Text('- or sign in with -',
//                        style: TextStyle(
//                          fontFamily: 'Inter',
//                          fontSize: ScreenUtil()
//                              .setSp(49.0 * rateWidthNewIOSDevices),
//                          color: Colors.white,
//                          letterSpacing: ScreenUtil()
//                              .setSp(3.0 * rateWidthNewIOSDevices),
//                        )),
//                    SizedBox(
//                      height: ScreenUtil().setHeight(90),
//                    ),
//                    Row(
//                      mainAxisSize: MainAxisSize.min,
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        _signInGoogleButton(),
//                        SizedBox(
//                          width: ScreenUtil().setHeight(30),
//                        ),
//                        _signInFBButton(),
//                      ],
//                    ),
//                  ],
//                ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
