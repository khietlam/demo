import 'package:demo/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:demo/components/custom_route.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../components/firebase_options.dart';
import '../services/account_info.dart';
import '../utils/firebase_auth_utils.dart';
import 'home.dart';

const String secure_token = "secure_token";

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  bool isOffline = false;
  bool isReady = false;

  String APP_STORE_URL = '';
  String PLAY_STORE_URL = '';

  late String deviceType;
  late Image imageMobile;
  late Image imageIpad;

  AccountInfo account = AccountInfo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    imageMobile = Image.asset("assets/images/background@3x.png");
    imageIpad = Image.asset("assets/images/backgroundIpadPro@3x.png");

    _initializeFirebase();
  }

  Future<FirebaseApp> _initializeFirebase() async {


    FirebaseApp firebaseApp = await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform,);


    account.user = FirebaseAuth.instance.currentUser;

    if (account.user != null) {
      // print(account.user);
      Future.delayed(const Duration(seconds: 0)).then((value) {
        FlutterNativeSplash.remove();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Home(
              account: account,
            ),
          ),
        );
      });
    } else {
      Future.delayed(const Duration(seconds: 0)).then((value) {
        FlutterNativeSplash.remove();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(),
          ),
        );
      });
    }

    return firebaseApp;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _controller.dispose();
    // _chewieController.dispose();
    // debugPrint('da dispose splash video');
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
    deviceType = 1.sh / 1.sw > 1.43 ? 'mobile' : 'tablet';

    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: isReady,
        progressIndicator: Center(
          child: SpinKitFadingFour(
            color: Colors.blue.withOpacity(0.6),
            size: 35.0,
            shape: BoxShape.rectangle,
          ),
        ),
        child: Center(
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
                )),
        )),
      ),
    );
  }
}
