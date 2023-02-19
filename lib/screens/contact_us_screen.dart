import 'package:flutter/material.dart';
import 'package:demo/constraints.dart';
import 'package:demo/components/custom_back_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  _ContactUsScreenState();

  late final WebViewController _controller;

  late Image imageMobile;
  late Image imageIpad;

  @override
  void initState() {
    super.initState();
    imageMobile = Image.asset("assets/images/background@3x.png");
    imageIpad = Image.asset("assets/images/backgroundIpadPro@3x.png");

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://sga.ai/contact/'));
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

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: Container(
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
          child: Column(
            children: <Widget>[
              Padding(
                padding:  EdgeInsets.only(left: 0.015.sh,
                  top: 0.08.sh,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Contact Us',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: ScreenUtil().setSp(76.0),
                            letterSpacing: ScreenUtil().setSp(9.0),
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setHeight(120.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Expanded(
                child: WebViewWidget(controller: _controller),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
