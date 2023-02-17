import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kTextFormDecoration = BoxDecoration(
  border: Border(
    bottom: BorderSide(
      color: Colors.white24,
      width: 0.5,
    ),
  ),
);

const kFormFieldTextStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 15.0,
  color: Colors.white,
  letterSpacing: 1.8,
);

const kFormScroll = TextStyle(
  fontFamily: 'Inter',
  fontSize: 15.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  letterSpacing: 1.8,
);

const kShowMessageTextStyle = TextStyle(
  fontFamily: 'Inter',
  color: Colors.white,
  letterSpacing: 1.2,
);

const kCupertinoTextStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 20.0,
  letterSpacing: 1.8,
);

const kErrorTextStyle = TextStyle(
  fontFamily: 'Inter',
  fontStyle: FontStyle.italic,
  color: Colors.greenAccent,
  letterSpacing: 1.2,
);

const kHeaderStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32.0,
    letterSpacing: 3.0,
    color: Colors.white);

const kTitleHomeScreen = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18.0,
    letterSpacing: 2.16,
    color: Colors.white);

const kSubHeading = TextStyle(
  fontFamily: 'Inter',
  fontSize: 18.0,
  color: Colors.white,
  letterSpacing: 1.8,
);

const kSubHeadingSetup = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18.0,
    color: Colors.white,
    letterSpacing: 1.8,
    wordSpacing: 1.5);

const kHeaderCamera = TextStyle(
    decoration: TextDecoration.none,
    fontFamily: 'Inter',
    fontSize: 15.0,
    letterSpacing: 1.8,
    color: Colors.white);

const kTextBoxPadding = EdgeInsets.only(top: 20.0, right: 30.0, bottom: 20.0);

const kAppbar = TextStyle(
  fontFamily: 'Inter',
  fontSize: 18.0,
  fontWeight: FontWeight.normal,
  color: Colors.white,
  letterSpacing: 1.8,
);

const kTabbar = TextStyle(
  fontFamily: 'Inter',
  fontSize: 10.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  letterSpacing: 1.8,
);

final kMeasurement = TextStyle(
  fontFamily: 'Inter',
  fontSize: 40.sp,
  fontWeight: FontWeight.normal,
  color: Colors.white,
  letterSpacing: 1.8,
);

final kMeasurementIPAD = TextStyle(
  fontFamily: 'Inter',
  fontSize: 20.sp,
  fontWeight: FontWeight.normal,
  color: Colors.white,
  letterSpacing: 1.8,
);

const kBrand = TextStyle(
  fontFamily: 'Inter',
  fontSize: 15.0,
  fontWeight: FontWeight.normal,
  color: Colors.white,
  letterSpacing: 6,
);

const kCountry = TextStyle(
  fontFamily: 'Inter',
  fontSize: 15.0,
  fontWeight: FontWeight.normal,
  color: Colors.white,
  letterSpacing: 6,
);

const kCountrySelect = TextStyle(
  fontFamily: 'Inter',
  fontSize: 15.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  letterSpacing: 6,
);

final kMeasurementSub = TextStyle(
  fontFamily: 'Inter',
  fontSize: 35.sp,
  fontWeight: FontWeight.normal,
  color: Colors.white,
  letterSpacing: 1.8,
);

final kMeasurementSubIPAD = TextStyle(
  fontFamily: 'Inter',
  fontSize: 15.sp,
  fontWeight: FontWeight.normal,
  color: Colors.white,
  letterSpacing: 1.8,
);

final kResultTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 55.sp,
    letterSpacing: 6.sp,
    color: Colors.lightGreenAccent);

final kResultTextStyleIPAD = TextStyle(
    fontFamily: 'Inter',
    fontSize: 35.sp,
    letterSpacing: 3.sp,
    color: Colors.lightGreenAccent);

final kBMITextStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 150.sp,
    fontWeight: FontWeight.w900,
    letterSpacing: 6.sp,
    color: Colors.white);

final kBMITextStyleIPAD = TextStyle(
    fontFamily: 'Inter',
    fontSize: 120.sp,
    fontWeight: FontWeight.w900,
    letterSpacing: 3.sp,
    color: Colors.white);

final kBodyTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 45.sp,
    letterSpacing: 6.sp,
    color: Colors.white);

final kBodyTextStyleIPAD = TextStyle(
    fontFamily: 'Inter',
    fontSize: 25.sp,
    letterSpacing: 3.sp,
    color: Colors.white);

final kBodyTextStyleBLACK = TextStyle(
    fontFamily: 'Inter',
    fontSize: 45.sp,
    letterSpacing: 6.sp,
    color: Colors.black);

final kBodyTextStyleBLACKIPAD = TextStyle(
    fontFamily: 'Inter',
    fontSize: 25.sp,
    letterSpacing: 3.sp,
    color: Colors.black);

const kBodyTextStyleSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0,
    letterSpacing: 2.0,
    color: Colors.white);

final kBodyTextStyleBodyFat = TextStyle(
    fontFamily: 'Inter',
    fontSize: 45.sp,
    letterSpacing: 6.sp,
    color: Colors.white);

final kBodyTextStyleBodyFatIPAD = TextStyle(
    fontFamily: 'Inter',
    fontSize: 35.sp,
    letterSpacing: 3.sp,
    color: Colors.white);

const kBodyTextStyleGreen = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18.0,
    letterSpacing: 3.0,
    color: Colors.lightGreenAccent);

final kBodyTextStyleGreenBodyShape = TextStyle(
    fontFamily: 'Inter',
    fontSize: 45.sp,
    letterSpacing: 6.sp,
    color: Colors.lightGreenAccent);

final kBodyTextStyleGreenBodyShapeIPAD = TextStyle(
    fontFamily: 'Inter',
    fontSize: 43.sp,
    letterSpacing: 3.sp,
    color: Colors.lightGreenAccent);

const kCommentFormat = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.0,
    letterSpacing: 2.0,
    color: Colors.lightGreenAccent);

const kSize = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.0,
    letterSpacing: 3.0,
    color: Colors.white);

const kSizeValue = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0,
    letterSpacing: 3.0,
    color: Colors.white);

const kCelebTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0,
    letterSpacing: 3.0,
    color: Colors.white);

const kMainCelebTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 3.0,
    color: Colors.white);

const kOpenSettingsTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 3.0);

const kOpenSettingsButtonStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    letterSpacing: 3.0);

// add slider

const kRegular = TextStyle(
  fontFamily: 'DMSans-Regular',
  fontSize: 16.0,
  color: Colors.white,
  height: 1.8,
  // shadows: <Shadow>[
  //   Shadow(
  //     offset: Offset(0.5, 0.5),
  //     blurRadius: 3.0,
  //     color: Color.fromARGB(255, 0, 0, 0),
  //   ),
  // ],
  // letterSpacing: 1.2,
);
const kRegularGreenSmall = TextStyle(
  fontFamily: 'DMSans-Regular',
  fontSize: 14.0,
  color: Color(0xff70FFB8),
);
const kRegularGreenBig = TextStyle(
  fontFamily: 'DMSans-Bold',
  fontSize: 16.0,
  color: Color(0xff70FFB8),
);
const kRegularWhiteSmall = TextStyle(
  fontFamily: 'DMSans-Regular',
  fontSize: 14.0,
  color: Colors.white,
);
const kRegularWhiteBig = TextStyle(
  fontFamily: 'DMSans-Bold',
  fontSize: 16.0,
  color: Colors.white,
);

const kBold = TextStyle(
  height: 2,
  fontFamily: 'DMSans-Bold',
  fontSize: 35.0,
  color: Colors.white,
  fontWeight: FontWeight.w700,
  // letterSpacing: 1.3,
);

const kMediumBigBlack = TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: 32.0,
  color: Color(0xff212529),
  fontWeight: FontWeight.w500,
  // letterSpacing: 1.3,
);

const kRegularVerySmallBlack = TextStyle(
  fontFamily: 'DMSans-Regular',
  fontSize: 12.0,
  color: Color(0xff212529),
  fontWeight: FontWeight.w500,
  // letterSpacing: 1.3,
);

const kMediumSmallBoldBlack = TextStyle(
  fontFamily: 'DMSans-Bold',
  fontSize: 18.0,
  color: Color(0xff212529),
  fontWeight: FontWeight.w700,
  // letterSpacing: 1.3,
);

const kSignItTitleBlack = TextStyle(
  fontFamily: 'DMSans-Medium',
  fontSize: 24.0,
  color: Color(0xff212529),
  fontWeight: FontWeight.w500,
  // letterSpacing: 1.3,
);

const kSignItBlack = TextStyle(
  fontFamily: 'DMSans-Regular',
  fontSize: 16.0,
  color: Color(0xff212529),
  fontWeight: FontWeight.w400,
  // letterSpacing: 1.3,
);

const kMediumSmallCTBlack = TextStyle(
  fontFamily: 'DMSans-Medium',
  fontSize: 14.0,
  color: Color(0xff212529),
  fontWeight: FontWeight.w500,
  // letterSpacing: 1.3,
);

const kTitilliumWebBoldSmallBlack = TextStyle(
    fontFamily: 'Inter-Medium',
    fontSize: 16.0,
    color: Colors.black,
    fontWeight: FontWeight.w700);

const kTitilliumWebItalicBlack = TextStyle(
    fontFamily: 'TitilliumWeb-ExtraLightItalic',
    fontSize: 16.0,
    color: Color(0xff3B424A),
    fontWeight: FontWeight.w900,
    fontStyle: FontStyle.italic);

const kBoldGreenSmall = TextStyle(
  fontFamily: 'DMSans-Bold',
  fontSize: 16.0,
  color: Color(0xff70FFB8),
  fontWeight: FontWeight.w700,
  // letterSpacing: 1.3,
);
const kBoldGreenBig = TextStyle(
  fontFamily: 'DMSans-Bold',
  fontSize: 14.0,
  color: Color(0xff70FFB8),
  fontWeight: FontWeight.w700,
  // letterSpacing: 1.3,
);

const kCompleteColor = Color(0xff212529);
const kInProgressColor = Color(0xffC4C4C4);
const kTodoColor = Color(0xffd1d2d7);

const kNewTextFormDecoration = BoxDecoration(
  border: Border(
    bottom: BorderSide(
      color: Color(0xff3683FC),
      width: 2,
    ),
  ),
);

const kFormBlueRegularSmall = TextStyle(
    fontFamily: 'DMSans-Regular',
    fontSize: 16.0,
    color: Color(0xff3683FC),
    fontWeight: FontWeight.w400);

const kDescAlertButtonBlack = TextStyle(
  fontFamily: 'DMSans-Medium',
  fontSize: 18.0,
  color: Color(0xff212529),
  fontWeight: FontWeight.w500,
  // letterSpacing: 1.3,
);

const kDoneAlertButtonBlack = TextStyle(
  fontFamily: 'DMSans-Bold',
  fontSize: 18.0,
  color: Colors.white,
  fontWeight: FontWeight.w700,
  // letterSpacing: 1.3,
);

const kContactTitleMediumBlack = TextStyle(
    fontFamily: 'Inter-Medium',
    color: Color(0xff212529),
    fontSize: 16.0,
    height: 1.5);

const kServicesRegularWhite = TextStyle(
  fontFamily: 'Inter',
  fontSize: 16.0,
  color: Colors.white,
  fontWeight: FontWeight.w500,
  // letterSpacing: 1.3,
);

const kServicesMediumWhite = TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: 16.0,
  color: Colors.white,
  fontWeight: FontWeight.w700,
  // letterSpacing: 1.3,
);

const kServicesBoldWhite = TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: 24.0,
  color: Colors.white,
  fontWeight: FontWeight.w700,
  // letterSpacing: 1.3,
);

////////////////////////////////////////////////////

final kTitleAppBar = TextStyle(
    fontFamily: 'Inter',
    fontSize: 48.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white);

final kTitleAppBarIPAD = TextStyle(
    fontFamily: 'Inter',
    fontSize: 28.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white);

final kSlider = TextStyle(
  fontFamily: 'Inter',
  fontSize: 42.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white,
  height: ScreenUtil().setHeight(3.0),
);

final kSliderIPAD = TextStyle(
  fontFamily: 'Inter',
  fontSize: 28.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white,
  height: ScreenUtil().setHeight(3.0),
);

final kPoweredBy = TextStyle(
  fontFamily: 'Inter',
  fontSize: 32.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

final kPoweredByIPAD = TextStyle(
  fontFamily: 'Inter',
  fontSize: 18.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

final kButtonMobile = TextStyle(
    fontFamily: 'Inter',
    fontSize: 42.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 15.sp);

final kHomeRegularWhite = TextStyle(
    fontFamily: 'Inter', color: Colors.white, fontSize: 42.sp, height: 1.5);

final kHomeRegularWhiteIPAD = TextStyle(
    fontFamily: 'Inter', color: Colors.white, fontSize: 22.sp, height: 1.5);

final kHomeMediumWhite = TextStyle(
    fontFamily: 'Inter-Medium',
    color: Colors.white,
    fontSize: 50.sp,
    fontWeight: FontWeight.bold);

final kHomeMediumWhiteIPAD = TextStyle(
    fontFamily: 'Inter-Medium',
    color: Colors.white,
    fontSize: 30.sp,
    fontWeight: FontWeight.bold);

final kHomeItalicWhite = TextStyle(
    fontFamily: 'OpenSans-Italic',
    color: Colors.white,
    fontSize: 40.sp,
    fontStyle: FontStyle.italic);

final kHomeItalicWhiteIPAD = TextStyle(
    fontFamily: 'OpenSans-Italic',
    color: Colors.white,
    fontSize: 28.sp,
    fontStyle: FontStyle.italic);

final kAboutUsBoldBlack = TextStyle(
    fontFamily: 'Inter-Medium',
    fontSize: 80.sp,
    color: const Color(0xff212529),
    fontWeight: FontWeight.w700,
    letterSpacing: 12.sp
    // letterSpacing: 1.3,
    );

final kAboutUsBoldBlackIPAD = TextStyle(
    fontFamily: 'Inter-Medium',
    fontSize: 60.sp,
    color: const Color(0xff212529),
    fontWeight: FontWeight.w700,
    letterSpacing: 6.sp
    // letterSpacing: 1.3,
    );

final kAboutUsBoldWhite = TextStyle(
    fontFamily: 'Inter-Medium',
    fontSize: 80.sp,
    color: Colors.white,
    fontWeight: FontWeight.w700,
    letterSpacing: 12.sp
    // letterSpacing: 1.3,
    );

final kAboutUsBoldWhiteIPAD = TextStyle(
    fontFamily: 'Inter-Medium',
    fontSize: 60.sp,
    color: Colors.white,
    fontWeight: FontWeight.w700,
    letterSpacing: 12.sp
    // letterSpacing: 1.3,
    );

final kAboutUsRegularBlack = TextStyle(
    fontFamily: 'Inter-Regular',
    fontSize: 44.sp,
    color: const Color(0xff3B424A),
    height: 2,
    fontWeight: FontWeight.w400,
    letterSpacing: 2.sp);

final kAboutUsRegularBlackIPAD = TextStyle(
    fontFamily: 'Inter-Regular',
    fontSize: 24.sp,
    color: const Color(0xff3B424A),
    height: 2,
    fontWeight: FontWeight.w400,
    letterSpacing: 2.sp);

final kAboutUsMediumBlack = TextStyle(
    fontFamily: 'Inter-Medium',
    fontSize: 50.sp,
    color: const Color(0xff3B424A),
    fontWeight: FontWeight.w700,
    letterSpacing: 2.sp);

final kAboutUsMediumBlackIPAD = TextStyle(
    fontFamily: 'Inter-Medium',
    fontSize: 30.sp,
    color: const Color(0xff3B424A),
    fontWeight: FontWeight.w700,
    letterSpacing: 2.sp);

final kTeamMediumBlack = TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: 44.sp,
  color: Colors.black,
  fontWeight: FontWeight.w500,
  letterSpacing: 2.sp,
  height: 2,
);

final kTeamMediumBlackIPAD = TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: 24.sp,
  color: Colors.black,
  fontWeight: FontWeight.w500,
  letterSpacing: 2.sp,
  height: 2,
);

final kTeamRegularBlack = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 44.sp,
  color: const Color(0xff212529),
  fontWeight: FontWeight.w500,
  letterSpacing: 2.sp,
  height: 2,
);

final kTeamRegularBlackIPAD = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 24.sp,
  color: const Color(0xff212529),
  fontWeight: FontWeight.w500,
  letterSpacing: 2.sp,
  height: 2,
);

final kHomeRegularBlack = TextStyle(
  fontFamily: 'Inter',
  color: const Color(0xff212529),
  fontSize: 42.sp,
  height: 1.5,
);

final kHomeRegularBlackIPAD = TextStyle(
  fontFamily: 'Inter',
  color: const Color(0xff212529),
  fontSize: 22.sp,
  height: 1.5,
);

final kHomeMediumBlack = TextStyle(
  fontFamily: 'Inter-Medium',
  color: const Color(0xff212529),
  fontSize: 44.sp,
  height: 1.5,
);

final kHomeMediumBlackIPAD = TextStyle(
  fontFamily: 'Inter-Medium',
  color: const Color(0xff212529),
  fontSize: 24.sp,
  height: 1.5,
);

final kHomeItalicBlack = TextStyle(
  fontFamily: 'OpenSans-Italic',
  color: const Color(0xff212529),
  fontSize: 44.sp,
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.w400,
  height: 1.5,
);

final kHomeItalicBlackIPAD = TextStyle(
  fontFamily: 'OpenSans-Italic',
  color: const Color(0xff212529),
  fontSize: 24.sp,
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.w400,
  height: 1.5,
);

final kServicesMediumBlack = TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: 44.sp,
  color: const Color(0xff212529),
  fontWeight: FontWeight.w700,
  letterSpacing: 2.sp,
);

final kServicesMediumBlackIPAD = TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: 24.sp,
  color: const Color(0xff212529),
  fontWeight: FontWeight.w700,
  letterSpacing: 2.sp,
);

final kServicesRegularBlack = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 42.sp,
  color: const Color(0xff212529),
  fontWeight: FontWeight.w500,
  letterSpacing: 2.sp,
);

final kServicesRegularBlackIPAD = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 22.sp,
  color: const Color(0xff212529),
  fontWeight: FontWeight.w500,
  letterSpacing: 2.sp,
);

final kFormRegular = TextStyle(
    fontFamily: 'Inter-Regular',
    fontSize: 48.sp,
    color: const Color(0xff707D8B),
    fontWeight: FontWeight.w500);

final kFormRegularIPAD = TextStyle(
    fontFamily: 'Inter-Regular',
    fontSize: 28.sp,
    color: const Color(0xff707D8B),
    fontWeight: FontWeight.w500);

final kFormRegularBlack = TextStyle(
    fontFamily: 'Inter-Regular',
    fontSize: 48.sp,
    color: const Color(0xff212529),
    fontWeight: FontWeight.w500);

final kFormRegularBlackIPAD = TextStyle(
    fontFamily: 'Inter-Regular',
    fontSize: 28.sp,
    color: const Color(0xff212529),
    fontWeight: FontWeight.w500);

final kFormRegularSmall = TextStyle(
    fontFamily: 'Inter-Regular',
    fontSize: 40.sp,
    color: const Color(0xff707D8B),
    fontWeight: FontWeight.w400);

final kFormRegularSmallIPAD = TextStyle(
    fontFamily: 'Inter-Regular',
    fontSize: 20.sp,
    color: const Color(0xff707D8B),
    fontWeight: FontWeight.w400);

final kFormBlueRegular = TextStyle(
    fontFamily: 'Inter-Regular',
    fontSize: 40.sp,
    color: const Color(0xff3683FC),
    fontWeight: FontWeight.w400);

final kFormBlueRegularIPAD = TextStyle(
    fontFamily: 'Inter-Regular',
    fontSize: 20.sp,
    color: const Color(0xff3683FC),
    fontWeight: FontWeight.w400);

final kButtonBold = TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: 40.sp,
  color: Colors.white,
  fontWeight: FontWeight.w700,
  // letterSpacing: 1.3,
);

final kButtonBoldIPAD = TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: 28.sp,
  color: Colors.white,
  fontWeight: FontWeight.w700,
  // letterSpacing: 1.3,
);

final kLangsWhite = TextStyle(
  fontFamily: 'Inter-Regular',
  fontWeight: FontWeight.w700,
  fontSize: 48.sp,
  letterSpacing: 4.sp,
  color: Colors.white,
);

final kLangsWhiteIPAD = TextStyle(
  fontFamily: 'Inter-Regular',
  fontWeight: FontWeight.w700,
  fontSize: 28.sp,
  letterSpacing: 4.sp,
  color: Colors.white,
);

final kLangsBlack = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 48.sp,
  letterSpacing: 4.sp,
  color: const Color(0xff212529),
);

final kLangsBlackIPAD = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 28.sp,
  letterSpacing: 4.sp,
  color: const Color(0xff212529),
);

////////////////////////////////////////ABODY///////////

final kFormLoginActive = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 48.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white,
  letterSpacing: 6.sp,
);

final kFormLoginActiveIPAD = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 28.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white,
  letterSpacing: 6.sp,
);

final kfloatingLabelStyle = TextStyle(
    fontFamily: 'Inter-Regular',
    fontSize: 34.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.5),
    letterSpacing: 4.sp,
    height: 0.7);

final kfloatingLabelStyleIPAD = TextStyle(
    fontFamily: 'Inter-Regular',
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.5),
    letterSpacing: 4.sp,
    height: 0.7);

final kerrorStyle = TextStyle(
  fontFamily: 'Inter',
  fontStyle: FontStyle.italic,
  color: Colors.yellow,
  fontSize: 28.sp,
  fontWeight: FontWeight.w500,
  letterSpacing: 2.sp,
);

final kerrorStyleIPAD = TextStyle(
  fontFamily: 'Inter',
  fontStyle: FontStyle.italic,
  color: Colors.yellow,
  fontSize: 20.sp,
  fontWeight: FontWeight.w500,
  letterSpacing: 2.sp,
);

final kFormLoginActiveBold = TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: 48.sp,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  letterSpacing: 6.sp,
);

final kFormLoginActiveBoldIPAD = TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: 28.sp,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  letterSpacing: 6.sp,
);

final kFormLoginInactive = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 48.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white.withOpacity(0.8),
  letterSpacing: 6.sp,
);

final kFormLoginInactiveIPAD = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 28.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white.withOpacity(0.8),
  letterSpacing: 6.sp,
);

final kFormLoginTitle = TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: 48.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white,
  letterSpacing: 6.sp,
);

final kFormLoginTitleIPAD = TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: 28.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white,
  letterSpacing: 6.sp,
);

final kBottomPicker = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 48.sp,
  fontWeight: FontWeight.w500,
  color: Colors.black,
  letterSpacing: 6.sp,
);

final kBottomPickerIPAD = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 28.sp,
  fontWeight: FontWeight.w500,
  color: Colors.black,
  letterSpacing: 6.sp,
);

final kHomeTittle = TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: 76.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white,
  letterSpacing: 6.sp,
);

final kHomeTittleIPAD = TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: 56.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white,
  letterSpacing: 6.sp,
);

final kWelcomeTitleBoldWhite = TextStyle(
    fontFamily: 'Inter-Regular',
    fontSize: 80.sp,
    color: Colors.white,
    fontWeight: FontWeight.w500,
    letterSpacing: 12.sp
    // letterSpacing: 1.3,
    );

final kWelcomeTitleBoldWhiteIPAD = TextStyle(
    fontFamily: 'Inter-Regular',
    fontSize: 60.sp,
    color: Colors.white,
    fontWeight: FontWeight.w500,
    letterSpacing: 6.sp
    // letterSpacing: 1.3,
    );

final kNotesTextStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 48.sp,
  fontWeight: FontWeight.w500,
  color: Colors.black54,
  letterSpacing: 6.sp,
);

final kNotesTextStyleIPAD = TextStyle(
  fontFamily: 'Inter',
  fontSize: 48.sp,
  fontWeight: FontWeight.w500,
  color: Colors.black54,
  letterSpacing: 6.sp,
);

final kNotesHintTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 48.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 6.sp,
    color: Colors.white);

final kNotesHintTextStyleIPAD = TextStyle(
    fontFamily: 'Inter',
    fontSize: 48.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 6.sp,
    color: Colors.white);

final kTitleCameraWhite = TextStyle(
    fontFamily: 'Inter-Medium',
    fontSize: 48.sp,
    color: Colors.white,
    fontWeight: FontWeight.w500,
    letterSpacing: 6.sp
    // letterSpacing: 1.3,
    );

final kTitleCameraWhiteIPAD = TextStyle(
    fontFamily: 'Inter-Medium',
    fontSize: 38.sp,
    color: Colors.white,
    fontWeight: FontWeight.w500,
    letterSpacing: 3.sp
    // letterSpacing: 1.3,
    );

final kDescCameraWhite = TextStyle(
    fontFamily: 'Inter',
    fontSize: 48.sp,
    color: Colors.white,
    fontWeight: FontWeight.w500,
    letterSpacing: 6.sp
    // letterSpacing: 1.3,
    );

final kDescCameraWhiteIPAD = TextStyle(
    fontFamily: 'Inter',
    fontSize: 38.sp,
    color: Colors.white,
    fontWeight: FontWeight.w500,
    letterSpacing: 3.sp
    // letterSpacing: 1.3,
    );

final kDescOptionsBlack = TextStyle(
    fontFamily: 'Inter',
    fontSize: 38.sp,
    color: Colors.black,
    fontWeight: FontWeight.w500,
    letterSpacing: 3.sp
    // letterSpacing: 1.3,
    );

final kDescOptionsWhite = TextStyle(
    fontFamily: 'Inter',
    fontSize: 38.sp,
    color: Colors.white,
    fontWeight: FontWeight.w500,
    letterSpacing: 3.sp
    // letterSpacing: 1.3,
    );

final kDescMetricsKeyBlack = TextStyle(
    fontFamily: 'Inter',
    fontSize: 38.sp,
    color: Colors.black,
    fontWeight: FontWeight.w500,
    letterSpacing: 3.sp
    // letterSpacing: 1.3,
    );

final kDescMetricsKeyBoldBlack = TextStyle(
    fontFamily: 'Inter',
    fontSize: 40.sp,
    color: Colors.black,
    fontWeight: FontWeight.w500,
    letterSpacing: 3.sp
    // letterSpacing: 1.3,
    );

final kOptionsMediumBlack = TextStyle(
    fontFamily: 'Inter-Medium',
    color: const Color(0xff212529),
    fontSize: 44.sp,
    height: 1.5,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.3.sp);

final kOptionsMediumBlackIPAD = TextStyle(
    fontFamily: 'Inter-Medium',
    color: const Color(0xff212529),
    fontSize: 38.sp,
    height: 1.5,
    fontWeight: FontWeight.w500,
    letterSpacing: 3.sp);

final kPopUpTitleMetricsKeyBlack = TextStyle(
    fontFamily: 'Inter',
    fontSize: 40.sp,
    color: Colors.black,
    fontWeight: FontWeight.w700,
    letterSpacing: 3.sp
    // letterSpacing: 1.3,
    );

const kIconHealth = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('images/Icon - Apple Health.png'),
    fit: BoxFit.cover,
  ),
);

final kNoContent = TextStyle(
  fontFamily: 'Inter',
  fontSize: 48.sp,
  color: Colors.white,
  letterSpacing: 6.sp,
);

final kNoContentIPAD = TextStyle(
  fontFamily: 'Inter',
  fontSize: 38.sp,
  color: Colors.white,
  letterSpacing: 3.sp,
);

//////////////////////////////////////////////////////////////////////////////// Abody.ai //////////////////////////

final kSignInWhite = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 48.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white,
  letterSpacing: 6.sp,
);

final kSignInWhiteIpad = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 28.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white.withOpacity(0.5),
  letterSpacing: 6.sp,
);

final kSetup = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 54.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white,
  letterSpacing: 6.sp,
);

final kSetupIpad = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 34.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white,
  letterSpacing: 3.sp,
);

final kSetUpTitle = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 48.sp,
  fontWeight: FontWeight.w500,
  color: Colors.black,
  letterSpacing: 6.sp,
);

final kSetUpTitleIpad = TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: 28.sp,
  fontWeight: FontWeight.w500,
  color: Colors.black,
  letterSpacing: 3.sp,
);

final kImageDescription = TextStyle(
  fontFamily: 'Inter',
  fontSize: 33.sp,
  color: Colors.white,
  letterSpacing: 4.sp,
);

final kImageDescriptionIPAD = TextStyle(
  fontFamily: 'Inter',
  fontSize: 23.sp,
  color: Colors.white,
  letterSpacing: 2.sp,
);

final kCountDown = TextStyle(
  fontSize: 500.sp,
  decoration: TextDecoration.none,
  fontFamily: 'Inter-Regular',
  fontWeight: FontWeight.w500,
  color: const Color(0xffed1c24),
);

final kCountDownIPAD = TextStyle(
  fontSize: 400.sp,
  decoration: TextDecoration.none,
  fontFamily: 'Inter-Regular',
  fontWeight: FontWeight.w500,
  color: const Color(0xffed1c24),
);

final kHealthDesc = TextStyle(
    fontFamily: 'Inter',
    height: 1.7,
    fontWeight: FontWeight.normal,
    fontSize: 45.sp,
    letterSpacing: 6.sp,
    color: Colors.white);

final kHealthDescIPAD = TextStyle(
    fontFamily: 'Inter',
    height: 1.7,
    fontWeight: FontWeight.normal,
    fontSize: 35.sp,
    letterSpacing: 3.sp,
    color: Colors.white);

final kHealthDescBold = TextStyle(
    fontFamily: 'Inter-Regular',
    height: 1.7,
    fontWeight: FontWeight.bold,
    fontSize: 45.sp,
    letterSpacing: 6.sp,
    color: Colors.white);

final kHealthDescBoldIPAD = TextStyle(
    fontFamily: 'Inter-Regular',
    height: 1.7,
    fontWeight: FontWeight.bold,
    fontSize: 35.sp,
    letterSpacing: 3.sp,
    color: Colors.white);

final kReviewDesc = TextStyle(
    fontFamily: 'Inter',
    height: 1.5,
    fontWeight: FontWeight.normal,
    fontSize: 45.sp,
    letterSpacing: 6.sp,
    color: Colors.white);

final kReviewDescIPAD = TextStyle(
    fontFamily: 'Inter',
    height: 1.5,
    fontWeight: FontWeight.normal,
    fontSize: 35.sp,
    letterSpacing: 3.sp,
    color: Colors.white);

const kBackGroundWelcome = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('images/background@3x.jpg'),
    fit: BoxFit.cover,
  ),
);

const kBackGroundWelcomeIpad = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('images/backgroundIpadPro@3x.jpg'),
    fit: BoxFit.cover,
  ),
);

const kBackGround2 = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('images/background2@3x.jpg'),
    fit: BoxFit.cover,
  ),
);

const kBackGround2Ipad = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('images/backgroundIpadPro2@2x.jpg'),
    fit: BoxFit.cover,
  ),
);

final kTableMini = TextStyle(
    fontFamily: 'Inter',
    height: 1.7,
    fontWeight: FontWeight.normal,
    fontSize: 35.sp,
    letterSpacing: 6.sp,
    color: Colors.white);

final kTableMiniIPAD = TextStyle(
    fontFamily: 'Inter',
    height: 1.7,
    fontWeight: FontWeight.normal,
    fontSize: 25.sp,
    letterSpacing: 3.sp,
    color: Colors.white);

final kTableMiniBOLD = TextStyle(
    fontFamily: 'Inter-Regular',
    height: 1.7,
    fontWeight: FontWeight.bold,
    fontSize: 35.sp,
    letterSpacing: 6.sp,
    color: Colors.white);

final kTableMiniBOLDIPAD = TextStyle(
    fontFamily: 'Inter-Regular',
    height: 1.7,
    fontWeight: FontWeight.bold,
    fontSize: 25.sp,
    letterSpacing: 3.sp,
    color: Colors.white);

final kButtonCancel = TextStyle(
    fontFamily: 'Inter',
    fontSize: 35.sp,
    color: Colors.white,
    letterSpacing: 6.sp,
    fontWeight: FontWeight.w700);

final kButtonCancelIpad = TextStyle(
    fontFamily: 'Inter',
    fontSize: 25.sp,
    color: Colors.white,
    letterSpacing: 3.sp,
    fontWeight: FontWeight.w700);

final kChooseDayTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 35.sp,
    letterSpacing: 6.sp,
    color: Colors.black);

final kChooseDayTextStyleIPAD = TextStyle(
    fontFamily: 'Inter',
    fontSize: 25.sp,
    letterSpacing: 3.sp,
    color: Colors.black);

const kActiveCardColour = Color(0xFF1D1E33);
const kInactiveCardColour = Color(0xFF111328);

final kPopTDEETitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 55.sp,
    letterSpacing: 6.sp,
    color: Colors.black);

final kPopTDEETitleIPAD = TextStyle(
    fontFamily: 'Inter',
    fontSize: 45.sp,
    letterSpacing: 3.sp,
    color: Colors.black);

final kPopTDEEDesc = TextStyle(
    fontFamily: 'Inter',
    fontSize: 45.sp,
    letterSpacing: 6.sp,
    color: Colors.black);

final kPopTDEEDescIPAD = TextStyle(
    fontFamily: 'Inter',
    fontSize: 35.sp,
    letterSpacing: 3.sp,
    color: Colors.black);

final kCategory = TextStyle(
  fontFamily: 'Inter',
  fontSize: 40.sp,
  color: Colors.white,
  letterSpacing: 6.sp,
);

final kCategoryIPAD = TextStyle(
  fontFamily: 'Inter',
  fontSize: 25.sp,
  color: Colors.white,
  letterSpacing: 3.sp,
);

final kCategoryDesc = TextStyle(
  fontFamily: 'Inter',
  fontSize: 35.sp,
  color: Colors.white,
  letterSpacing: 6.sp,
);

final kCategoryIPADDesc = TextStyle(
  fontFamily: 'Inter',
  fontSize: 20.sp,
  color: Colors.white,
  letterSpacing: 3.sp,
);
