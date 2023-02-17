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
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../components/button.dart';
import '../components/custom_back_button.dart';
import '../components/custom_icons_icons.dart';
import '../components/custom_route.dart';
import '../constraints.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late FocusNode focusPassword, focusButton;

  bool _isProcessing = false;
  bool _showSpinner = false;
  bool _isOffline = false;
  late Image imageMobile;
  late Image imageIpad;

  AccountInfo _account = AccountInfo();

  FormGroup buildForm() => fb.group(<String, Object>{
        'username': FormControl<String>(
          validators: [
            Validators.required,
            Validators.minLength(6),
            Validators.maxLength(40)
          ],
        ),
        'password': ['', Validators.required, Validators.minLength(6)],
      });

  void _showErrorNetwork() {
    Fluttertoast.showToast(
      msg: "errors.error_network",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 4,
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

  String? _deviceType;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageMobile = Image.asset("assets/images/background@3x.png");
    imageIpad = Image.asset("assets/images/backgroundIpadPro@3x.png");
    focusPassword = FocusNode();
    focusButton = FocusNode();
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

  @override
  Widget build(BuildContext context) {
    _deviceType = 1.sh / 1.sw > 1.43 ? 'mobile' : 'tablet';

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
                decoration: _deviceType == 'mobile'
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
                                  formControlName: 'username',
                                  maxLines: 1,
                                  onSubmitted: (control) {
                                    FocusScope.of(context)
                                        .requestFocus(focusPassword);
                                  },
                                  validationMessages: {
                                    ValidationMessage.required: (_) =>
                                        'Username can\'t be empty',
                                    ValidationMessage.minLength: (_) =>
                                        'Enter a username with length at least 6',
                                    ValidationMessage.maxLength: (_) =>
                                        'Enter a username with max length at 40',
                                  },
                                  textInputAction: Platform.isIOS
                                      ? TextInputAction.next
                                      : TextInputAction.go,
                                  style: _deviceType == 'mobile'
                                      ? kFormLoginActive
                                      : kFormLoginActiveIPAD,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 0,
                                        top: ScreenUtil().setHeight(10.0),
                                        right: 0,
                                        bottom: ScreenUtil().setHeight(10.0)),
                                    alignLabelWithHint: true,
                                    floatingLabelStyle: _deviceType == 'mobile'
                                        ? kfloatingLabelStyle
                                        : kfloatingLabelStyleIPAD,
                                    labelText: 'Username',
                                    labelStyle: _deviceType == 'mobile'
                                        ? kFormLoginInactive
                                        : kFormLoginInactiveIPAD,
                                    border: InputBorder.none,
                                    helperText: '',
                                    helperStyle: const TextStyle(height: 0.7),
                                    errorStyle: _deviceType == 'mobile'
                                        ? kerrorStyle
                                        : kerrorStyleIPAD,
                                    icon: Padding(
                                      padding: EdgeInsets.fromLTRB(0,
                                          ScreenUtil().setHeight(45.0), 0, 0),
                                      child: Icon(
                                        CustomIcons.couple,
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
                                  formControlName: 'password',
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
                                  style: _deviceType == 'mobile'
                                      ? kFormLoginActive
                                      : kFormLoginActiveIPAD,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 0,
                                        top: ScreenUtil().setHeight(10.0),
                                        right: 0,
                                        bottom: ScreenUtil().setHeight(10.0)),
                                    alignLabelWithHint: true,
                                    labelText: 'Password',
                                    floatingLabelStyle: _deviceType == 'mobile'
                                        ? kfloatingLabelStyle
                                        : kfloatingLabelStyleIPAD,
                                    labelStyle: _deviceType == 'mobile'
                                        ? kFormLoginInactive
                                        : kFormLoginInactiveIPAD,
                                    border: InputBorder.none,
                                    helperText: '',
                                    helperStyle: const TextStyle(height: 0.7),
                                    errorStyle: _deviceType == 'mobile'
                                        ? kerrorStyle
                                        : kerrorStyleIPAD,
                                    icon: Padding(
                                      padding: EdgeInsets.fromLTRB(0,
                                          ScreenUtil().setHeight(45.0), 0, 0),
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
                          buttonName: 'Sign In',
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
                              _account.username =
                                  formOut['username'].replaceAll(' ', '');
                              _account.password =
                                  formOut['password'].replaceAll(' ', '');

                              if (_isOffline) {
                                _showErrorNetwork();
                              } else {
                                AccountInfo? user = await AuthenticationService
                                    .signInUsingEmailPassword(
                                  email: _account.username,
                                  password: _account.password,
                                );

                                print(user);

                                if (user!.message != null) {
                                  switch (user.message) {
                                    case 'user-not-found':
                                      setState(() {
                                        _showSpinner = false;
                                        _showErrorMessage('User not found!');
                                      });
                                      break;
                                    case 'wrong-password':
                                      setState(() {
                                        _showSpinner = false;
                                        _showErrorMessage('Wrong password!');
                                      });

                                      break;
                                  }
                                } else {
                                  setState(() {
                                    _showSpinner = false;
                                    Future.delayed(const Duration(seconds: 0))
                                        .then((value) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => Home(
                                            account: _account,
                                          ),
                                        ),
                                      );
                                    });
                                  });
                                }
                              }
                            } else {
                              form.markAllAsTouched();
                            }
                          },
                          buttonColor: Colors.green.shade400,
                          elevation: 1,
                          nameColor: Colors.white,
                          fontSize: _deviceType == 'mobile' ? 40.sp : 30.sp,
                          letterSpacing: _deviceType == 'mobile' ? 6.sp : 3.sp,
                        ),
                        Flexible(
                          child: SizedBox(
                            height: ScreenUtil().setHeight(380),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Text('- or sign in with -',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: ScreenUtil().setSp(49.0),
                                  color: Colors.white,
                                  letterSpacing: ScreenUtil().setSp(3.0),
                                )),
                            SizedBox(
                              height: ScreenUtil().setHeight(90),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _signInGoogleButton(),
                                // SizedBox(
                                //   width: ScreenUtil().setHeight(30),
                                // ),
                                // _signInFBButton(),
                              ],
                            ),
                          ],
                        ),
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

  Widget _signInGoogleButton() {
    return ButtonSocial(
      imgURL: 'assets/images/google_logo.png',
      buttonName: 'Google',
      minHeight: 0.06.sh,
      minWidth: 0.18.sh,
      fontSize: _deviceType == 'mobile' ? 40.sp : 30.sp,
      letterSpacing: _deviceType == 'mobile' ? 6.sp : 3.sp,
      onTap: () async {
        if (_isOffline) {
          _showErrorNetwork();
        } else {
          _signInwithGoogle();
        }
      },
      nameColor: Colors.blue,
      buttonColor: Colors.white.withOpacity(0.8),
      elevation: 2,
    );
  }

  Future<String?> _signInwithGoogle() async {
    setState(() {
      _showSpinner = true;
    });
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential).then((value) {
        // print(value.user);
        if (value.user!.email != null) {
          _account.user = value.user;
          setState(() {
            _showSpinner = false;
            Future.delayed(const Duration(seconds: 0)).then((value) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Home(
                    account: _account,
                  ),
                ),
              );
            });
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      // print(e.message);
      _showErrorMessage(e.message!);
      throw e;
    }
  }

// void signInWithGoogle() async {
//   _showSpinner = true;
//
//   try {
//     final GoogleSignInAccount? googleSignInAccount =
//         await googleSignIn.signIn();
//     final GoogleSignInAuthentication? googleSignInAuthentication =
//         await googleSignInAccount?.authentication;
//     if (googleSignInAuthentication?.idToken != null) {
//       account.token = googleSignInAuthentication?.idToken;
//       if (mounted) {
//         setState(() {
//           _showSpinner = true;
//         });
//       }
//       _screenLoading(context);
//       var loginService = GoogleService();
//       loginService.ggAccountInfo(account).then((value) {
//         if (value?.status == 'fail') {
//           _status = value?.status;
//           account.error_code = value?.error_code;
//           _showSpinner = false;
//           showMessage('${value?.message}', Colors.red);
//           widget.analytics?.logEvent(
//             name: "login_fail",
//             parameters: {
//               "login_method": 'google_login',
//               "error_code": value?.error_code,
//             },
//           );
//         } else {
//           _status = value?.status;
//           account.username = value?.username;
//           account.token = value?.token;
//           account.expireTime = value?.expireTime;
//           account.email = value?.email;
//           account.height = value?.height;
//           account.weight = value?.weight;
//           account.primaryAvatarId = value?.primaryAvatarId;
//           account.gender = value?.gender;
//           account.birth_year = value?.birth_year;
//           account.expireTimeOfToken =
//               DateTime.now().millisecondsSinceEpoch + value?.expireTime;
//           account.typeLogin = value?.typeLogin;
//           account.lastScanId = value?.lastScanId;
//           account.verify_valid_info = value?.verify_valid_info;
//           _encryptToken(secure_token, account.token);
//           // debugPrint('Token sau khi login ${account.token}');
//           // debugPrint(
//           //      'Expire Time sau khi login Google ${account.expireTimeOfToken}');
//           // debugPrint(
//           //      'verify_valid_info sau khi login Google ${account.verify_valid_info}');
//           // debugPrint('Username ${account.username}');
//           // debugPrint('Email ${account.email}');
//
//         }
//       });
//     }
//   } catch (e) {
//     // debugPrint('loi ne $e');
//     _showSpinner = false;
//   }
// }
}
