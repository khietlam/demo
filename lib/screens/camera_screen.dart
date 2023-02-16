// import 'dart:async';
// import 'dart:io';
//
// import 'package:camera/camera.dart';
// import 'package:demo/components/custom_back_button.dart';
// import 'package:demo/screens/home.dart';
//
// // import 'package:demo/screens/gallery_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_offline/flutter_offline.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:gallery_saver/gallery_saver.dart';
//
// import '../components/circle_icon_button.dart';
//
// class CameraScreen extends StatefulWidget {
//   final List<CameraDescription>? cameras;
//
//   /// Default Constructor
//   const CameraScreen({Key? key, this.cameras}) : super(key: key);
//
//   @override
//   State<CameraScreen> createState() {
//     return _CameraScreenState();
//   }
// }
//
// class _CameraScreenState extends State<CameraScreen>
//     with WidgetsBindingObserver, TickerProviderStateMixin {
//
//   CameraController? controller;
//   XFile? imageFile;
//
//   bool enableAudio = true;
//   double _minAvailableExposureOffset = 0.0;
//   double _maxAvailableExposureOffset = 0.0;
//   double _currentExposureOffset = 0.0;
//   late AnimationController _flashModeControlRowAnimationController;
//   late Animation<double> _flashModeControlRowAnimation;
//   late AnimationController _exposureModeControlRowAnimationController;
//   late Animation<double> _exposureModeControlRowAnimation;
//   late AnimationController _focusModeControlRowAnimationController;
//   late Animation<double> _focusModeControlRowAnimation;
//   double _minAvailableZoom = 1.0;
//   double _maxAvailableZoom = 1.0;
//   double _currentScale = 1.0;
//   double _baseScale = 1.0;
//
//   // Counting pointers (number of user fingers on screen)
//   int _pointers = 0;
//
//   List<File> capturedImages = [];
//   Future<void>? _initializeControllerFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     try {
//       onNewCameraSelected(widget.cameras![0]);
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//
//     _ambiguate(WidgetsBinding.instance)?.addObserver(this);
//
//   }
//
//   void _logError(String code, String? message) {
//     // ignore: avoid_print
//     print('Error: $code${message == null ? '' : '\nError Message: $message'}');
//   }
//
//   @override
//   void dispose() {
//     _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
//
//     // _flashModeControlRowAnimationController.dispose();
//     // _exposureModeControlRowAnimationController.dispose();
//     controller!.dispose();
//     super.dispose();
//   }
//
//   // #docregion AppLifecycle
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     final CameraController? cameraController = controller;
//
//     // App state changed before we got the chance to initialize.
//     if (cameraController == null || !cameraController.value.isInitialized) {
//       return;
//     }
//
//     if (state == AppLifecycleState.inactive) {
//       cameraController.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       onNewCameraSelected(cameraController.description);
//     }
//   }
//
//   // #enddocregion AppLifecycle
//
//   @override
//   Widget build(BuildContext context) {
//     final deviceType = 1.sh / 1.sw > 1.43 ? 'mobile' : 'tablet';
//     final size = MediaQuery.of(context).size;
//
//     return Material(
//       type: MaterialType.transparency,
//       child: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // widget.analytics?.logEvent(
//             //   name: "camera_front_displayed",
//             // );
//             if (deviceType == 'mobile') {
//               return MediaQuery(
//                 data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//                 child: Center(
//                   child: Stack(
//                     // fit: StackFit.expand,
//                     children: <Widget>[
//                       Positioned.fill(
//                         child: ClipRect(
//                           child: OverflowBox(
//                             alignment: Alignment.center,
//                             child: FittedBox(
//                               fit: BoxFit.fitHeight,
//                               child: SizedBox(
//                                   height: size.height,
//                                   width: size.height /
//                                       controller!.value.aspectRatio,
//                                   child: CameraPreview(controller!)),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         left: 0.015.sh,
//                         top: 0.04.sh,
//                         child: CustomBackButton(),
//                       ),
//                       Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Container(
//                           height: 120,
//                           padding: const EdgeInsets.all(20.0),
//                           child: Stack(
//                             children: <Widget>[
//                               Align(
//                                 alignment: Alignment.center,
//                                 child: Material(
//                                   color: Colors.transparent,
//                                   child: controller != null
//                                       ? _captureControlRowWidget()
//                                       : Container(),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             } else {
//               return MediaQuery(
//                 data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//                 child: Center(
//                   child: Stack(
//                     children: <Widget>[
//                       Positioned.fill(
//                         child: ClipRect(
//                           child: OverflowBox(
//                             alignment: Alignment.center,
//                             child: FittedBox(
//                               fit: BoxFit.fitHeight,
//                               child: SizedBox(
//                                   height: size.height,
//                                   width: size.height /
//                                       controller!.value.aspectRatio,
//                                   child: CameraPreview(controller!)),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         left: 0.015.sh,
//                         top: 0.04.sh,
//                         child: CustomBackButton(),
//                       ),
//                       Align(
//                         alignment: Alignment.center,
//                         child: Material(
//                           color: Colors.transparent,
//                           child: controller != null
//                               ? _captureControlRowWidget()
//                               : Container(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//           } else {
//             // Otherwise, display a loading indicator.
//             return Center(
//               child: SpinKitFadingFour(
//                 color: Colors.blueGrey.withOpacity(0.6),
//                 size: 35.0,
//                 shape: BoxShape.rectangle,
//               ),
//             );
//           }
//         },
//       ),
//     );
//
//   }
//
//
//   /// Display the preview from the camera (or a message if the preview is not available).
//   Widget _cameraPreviewWidget() {
//     final CameraController? cameraController = controller;
//     final size = MediaQuery.of(context).size;
//     if (cameraController == null || !cameraController.value.isInitialized) {
//       return const Text(
//         'Camera is initializing...',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 24.0,
//           fontWeight: FontWeight.w900,
//         ),
//       );
//     } else {
//       return Material(
//         type: MaterialType.transparency,
//         child: FutureBuilder<void>(
//           future: _initializeControllerFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               // widget.analytics?.logEvent(
//               //   name: "camera_front_displayed",
//               // );
//               return Listener(
//                 onPointerDown: (_) => _pointers++,
//                 onPointerUp: (_) => _pointers--,
//                 child: SizedBox(
//                   height: size.height,
//                   width: size.width,
//                   child: CameraPreview(
//                     controller!,
//                     child: LayoutBuilder(builder:
//                         (BuildContext context, BoxConstraints constraints) {
//                       return GestureDetector(
//                         behavior: HitTestBehavior.opaque,
//                         onScaleStart: _handleScaleStart,
//                         onScaleUpdate: _handleScaleUpdate,
//                         onTapDown: (TapDownDetails details) =>
//                             onViewFinderTap(details, constraints),
//                       );
//                     }),
//                   ),
//                 ),
//               );
//             } else {
//               // Otherwise, display a loading indicator.
//               return Center(
//                 child: SpinKitFadingFour(
//                   color: Colors.blueGrey.withOpacity(0.6),
//                   size: 35.0,
//                   shape: BoxShape.rectangle,
//                 ),
//               );
//             }
//           },
//         ),
//       );
//       return Listener(
//         onPointerDown: (_) => _pointers++,
//         onPointerUp: (_) => _pointers--,
//         child: SizedBox(
//           height: size.height,
//           // width: size.width,
//           child: CameraPreview(
//             controller!,
//             child: LayoutBuilder(
//                 builder: (BuildContext context, BoxConstraints constraints) {
//               return GestureDetector(
//                 behavior: HitTestBehavior.opaque,
//                 onScaleStart: _handleScaleStart,
//                 onScaleUpdate: _handleScaleUpdate,
//                 onTapDown: (TapDownDetails details) =>
//                     onViewFinderTap(details, constraints),
//               );
//             }),
//           ),
//         ),
//       );
//     }
//   }
//
//   void _handleScaleStart(ScaleStartDetails details) {
//     _baseScale = _currentScale;
//   }
//
//   Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
//     // When there are not exactly two fingers on screen don't scale
//     if (controller == null || _pointers != 2) {
//       return;
//     }
//
//     _currentScale = (_baseScale * details.scale)
//         .clamp(_minAvailableZoom, _maxAvailableZoom);
//
//     await controller!.setZoomLevel(_currentScale);
//   }
//
//   /// Display the thumbnail of the captured image or video.
//   Widget _thumbnailWidget() {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: InkWell(
//         onTap: () {
//           print('aaa $capturedImages');
//           if (capturedImages.isEmpty) return; //Return if no image
//
//           Navigator.pushReplacement(context,
//               MaterialPageRoute(
//                   builder: (context) => Home(
//                       images: capturedImages.reversed.toList())));
//         },
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             if (imageFile == null)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.all(Radius.circular(10)),
//                   child: SizedBox(
//                     width: ScreenUtil().setHeight(120.0),
//                     height: ScreenUtil().setHeight(120.0),
//                     child:  Icon(
//                       Icons.photo_library_outlined,
//                       size: ScreenUtil().setHeight(90),
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               )
//             else
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.all(Radius.circular(10)),
//                   child: SizedBox(
//                       width: ScreenUtil().setHeight(120.0),
//                       height: ScreenUtil().setHeight(120.0),
//                       child: kIsWeb
//                           ? Image.network(
//                               imageFile!.path,
//                               fit: BoxFit.cover,
//                             )
//                           : Image.file(
//                               File(imageFile!.path),
//                               fit: BoxFit.cover,
//                             )),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void onChanged(CameraDescription? description) {
//     if (description == null) {
//       return;
//     }
//
//     onNewCameraSelected(description);
//   }
//
//   /// Display the control bar with buttons to take pictures and record videos.
//   Widget _captureControlRowWidget() {
//     CameraController? cameraController = controller;
//
//     return Container(
//       height: ScreenUtil().setHeight(270.0),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.6),
//         borderRadius: BorderRadius.circular(
//         ScreenUtil().setWidth(90.0),
//
//       ),),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           IconButton(
//             iconSize: ScreenUtil().setHeight(90.0),
//             icon: cameraController!.description.lensDirection ==
//                     CameraLensDirection.back
//                 ? const Icon(Icons.camera_front)
//                 : const Icon(Icons.camera_rear),
//             color: Colors.white,
//             onPressed: () {
//               if (cameraController.description.lensDirection ==
//                   CameraLensDirection.back) {
//                 try {
//                   onNewCameraSelected(widget.cameras![1]);
//                 } catch (e) {
//                   debugPrint(e.toString());
//                 }
//               } else {
//                 try {
//                   onNewCameraSelected(widget.cameras![0]);
//                 } catch (e) {
//                   debugPrint(e.toString());
//                 }
//               }
//             },
//           ),
//           IconButton(
//             iconSize: ScreenUtil().setHeight(160.0),
//             icon: const Icon(Icons.camera_alt),
//             color: Colors.white,
//             onPressed:
//                 cameraController != null && cameraController.value.isInitialized
//                     ? onTakePictureButtonPressed
//                     : null,
//           ),
//           _thumbnailWidget(),
//         ],
//       ),
//     );
//   }
//
//   String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
//
//   void showInSnackBar(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
//     if (controller == null) {
//       return;
//     }
//
//     final CameraController cameraController = controller!;
//
//     final Offset offset = Offset(
//       details.localPosition.dx / constraints.maxWidth,
//       details.localPosition.dy / constraints.maxHeight,
//     );
//     cameraController.setExposurePoint(offset);
//     cameraController.setFocusPoint(offset);
//   }
//
//   Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
//     final CameraController? oldController = controller;
//     if (oldController != null) {
//       // `controller` needs to be set to null before getting disposed,
//       // to avoid a race condition when we use the controller that is being
//       // disposed. This happens when camera permission dialog shows up,
//       // which triggers `didChangeAppLifecycleState`, which disposes and
//       // re-creates the controller.
//       controller = null;
//       await oldController.dispose();
//     }
//
//     final CameraController cameraController = CameraController(
//       cameraDescription,
//       kIsWeb ? ResolutionPreset.max : ResolutionPreset.max,
//       // enableAudio: enableAudio,
//       imageFormatGroup: ImageFormatGroup.jpeg,
//     );
//
//     controller = cameraController;
//
//     // If the controller is updated then update the UI.
//     cameraController.addListener(() {
//       if (mounted) {
//         setState(() {});
//       }
//       if (cameraController.value.hasError) {
//         showInSnackBar(
//             'Camera error ${cameraController.value.errorDescription}');
//       }
//     });
//
//     try {
//       _initializeControllerFuture = cameraController.initialize();
//       // await Future.wait(<Future<Object?>>[
//       //   // The exposure mode is currently not supported on the web.
//       //   ...!kIsWeb
//       //       ? <Future<Object?>>[
//       //           cameraController.getMinExposureOffset().then(
//       //               (double value) => _minAvailableExposureOffset = value),
//       //           cameraController
//       //               .getMaxExposureOffset()
//       //               .then((double value) => _maxAvailableExposureOffset = value)
//       //         ]
//       //       : <Future<Object?>>[],
//       //   cameraController
//       //       .getMaxZoomLevel()
//       //       .then((double value) => _maxAvailableZoom = value),
//       //   cameraController
//       //       .getMinZoomLevel()
//       //       .then((double value) => _minAvailableZoom = value),
//       // ]);
//     } on CameraException catch (e) {
//       switch (e.code) {
//         case 'CameraAccessDenied':
//           showInSnackBar('You have denied camera access.');
//           break;
//         case 'CameraAccessDeniedWithoutPrompt':
//           // iOS only
//           showInSnackBar('Please go to Settings app to enable camera access.');
//           break;
//         case 'CameraAccessRestricted':
//           // iOS only
//           showInSnackBar('Camera access is restricted.');
//           break;
//         case 'AudioAccessDenied':
//           showInSnackBar('You have denied audio access.');
//           break;
//         case 'AudioAccessDeniedWithoutPrompt':
//           // iOS only
//           showInSnackBar('Please go to Settings app to enable audio access.');
//           break;
//         case 'AudioAccessRestricted':
//           // iOS only
//           showInSnackBar('Audio access is restricted.');
//           break;
//         default:
//           _showCameraException(e);
//           break;
//       }
//     }
//
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   void onTakePictureButtonPressed() {
//     takePicture().then((XFile? file) {
//       if (mounted) {
//         setState(()  {
//           imageFile = file;
//
//           GallerySaver.saveImage(imageFile!.path, albumName: 'SGA')
//               .then((path) {
//             capturedImages.add(File(imageFile!.path));
//           });
//         });
//
//         // if (file != null) {
//         //   showInSnackBar('Picture saved to ${file.path}');
//         // }
//       }
//     });
//   }
//
//   Future<void> onCaptureOrientationLockButtonPressed() async {
//     try {
//       if (controller != null) {
//         final CameraController cameraController = controller!;
//         if (cameraController.value.isCaptureOrientationLocked) {
//           await cameraController.unlockCaptureOrientation();
//           showInSnackBar('Capture orientation unlocked');
//         } else {
//           await cameraController.lockCaptureOrientation();
//           showInSnackBar(
//               'Capture orientation locked to ${cameraController.value.lockedCaptureOrientation.toString().split('.').last}');
//         }
//       }
//     } on CameraException catch (e) {
//       _showCameraException(e);
//     }
//   }
//
//   Future<XFile?> takePicture() async {
//     final CameraController? cameraController = controller;
//     if (cameraController == null || !cameraController.value.isInitialized) {
//       showInSnackBar('Error: select a camera first.');
//       return null;
//     }
//
//     if (cameraController.value.isTakingPicture) {
//       // A capture is already pending, do nothing.
//       return null;
//     }
//
//     try {
//       final XFile file = await cameraController.takePicture();
//       return file;
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       return null;
//     }
//   }
//
//   void _showCameraException(CameraException e) {
//     _logError(e.code, e.description);
//     showInSnackBar('Error: ${e.code}\n${e.description}');
//
//   }
//
//   T? _ambiguate<T>(T? value) => value;
//
// }
