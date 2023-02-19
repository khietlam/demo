import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;
import 'package:demo/tflite/recognition.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
//
import 'stats.dart';

/// Classifier
class Classifier {
  /// Instance of Interpreter
  Interpreter? _interpreter;

  //Interpreter Options (Settings)
  final int numThreads = 4;
  final bool isNNAPI = false;
  final bool isGPU = true;

  /// Labels file loaded as list
  List<String>? _labels;

  static String? fileModelName;

  static String? fileLabelName;

  /// Get input size of image (height = width = 300)
  List<int>? _inputShape;

  /// Non-maximum suppression threshold
  static double mNmsThresh = 0.3;

  /// [ImageProcessor] used to pre-process the image
  ImageProcessor? imageProcessor;

  /// Padding the image to transform into square
  int? padSize;

  /// Shapes of output tensors
  List<List<int>>? _outputShapes;

  /// Types of output tensors
  List<TfLiteType>? _outputTypes;

  static const int clsNum = 4;
  static const double objectConfTh = 0.6;
  static const double classConfTh = 0.6;

  Classifier({Interpreter? interpreter, List<String>? labels}) {
    loadModel(interpreter: interpreter);
    loadLabels(labels: labels);
  }

  /// Loads interpreter from asset
  void loadModel({Interpreter? interpreter}) async {
    try {
      //Still working on it
      /*InterpreterOptions myOptions = new InterpreterOptions();
      myOptions.threads = numThreads;
      if (isNNAPI) {
        NnApiDelegate nnApiDelegate;
        bool androidApiThresholdMet = true;
        if (androidApiThresholdMet) {
          nnApiDelegate = new NnApiDelegate();
          myOptions.addDelegate(nnApiDelegate);
          myOptions.useNnApiForAndroid = true;
        }
      }
      if (isGPU) {
        GpuDelegateV2 gpuDelegateV2 = new GpuDelegateV2();
        myOptions.addDelegate(gpuDelegateV2);
      }*/

      _interpreter = interpreter ??
          await Interpreter.fromAsset(
            "models/$fileModelName",
            options: InterpreterOptions()..threads = numThreads, //myOptions,
          );

      // if ( Platform.isIOS) {
      //   //iOS Metal Delegate (GpuDelegate)
      //   // final gpuDelegate = GpuDelegate(
      //   //     options: GpuDelegateOptions(allowPrecisionLoss: true, waitType: TFLGpuDelegateWaitType.active));
      //   // var interpreterOptions = InterpreterOptions()..addDelegate(gpuDelegate);
      //
      //   _interpreter = interpreter ??
      //       await Interpreter.fromAsset(
      //         "models/$fileModelName",
      //         options: InterpreterOptions()..threads = numThreads, //myOptions,
      //       );
      //
      // } else if (Platform.isAndroid) {
      //   //Android GpuDelegateV2
      //   final gpuDelegateV2 = GpuDelegateV2(
      //       options: GpuDelegateOptionsV2(
      //         isPrecisionLossAllowed:true,
      //         inferencePreference:TfLiteGpuInferenceUsage.preferenceSustainSpeed,
      //         inferencePriority1:TfLiteGpuInferencePriority.minMemoryUsage,
      //         inferencePriority2:TfLiteGpuInferencePriority.auto,
      //         inferencePriority3:TfLiteGpuInferencePriority.auto,
      //       )
      //   );
      //
      //   // var interpreterOptions = InterpreterOptions()..addDelegate(gpuDelegateV2);
      //   // var interpreterOptions = InterpreterOptions()..useNnApiForAndroid = true;
      //
      //
      //   // _interpreter = interpreter ??
      //   //     await Interpreter.fromAsset(
      //   //       "models/$fileModelName",
      //   //       options: interpreterOptions, //myOptions,
      //   //     );
      //
      //   _interpreter = interpreter ??
      //       await Interpreter.fromAsset(
      //         "models/$fileModelName",
      //         options: InterpreterOptions()..threads = numThreads, //myOptions,
      //       );
      //
      // }


      var outputTensors = _interpreter!.getOutputTensors();
      //print("the length of the output Tensors is ${outputTensors.length}");
      _outputShapes = [];
      _outputTypes = [];
      for (var tensor in outputTensors) {
        _outputShapes!.add(tensor.shape);
        _outputTypes!.add(tensor.type);
      }

      print(_interpreter!.getInputTensor(0));
      print(_interpreter!.getOutputTensor(0));
      print(outputTensors[0].params);
      print(outputTensors[0].shape);
      print(outputTensors[0].type);

      _inputShape = _interpreter!.getInputTensor(0).shape;
    } catch (e) {
      print("Error while creating interpreter: $e");
    }
  }

  /// Pre-process the image
  /// Only does something to the image if it doesn't meet the specified input sizes.
  TensorImage getProcessedImage(TensorImage inputImage) {
    padSize = max(inputImage.height, inputImage.width);

    imageProcessor ??= ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(padSize!, padSize!))
        .add(ResizeOp(_inputShape![1], _inputShape![1], ResizeMethod.BILINEAR))
        .build();

    inputImage = imageProcessor!.process(inputImage);

    return inputImage;
  }

  /// Loads labels from assets
  void loadLabels({List<String>? labels}) async {
    try {
      _labels =
          labels ?? await FileUtil.loadLabels("assets/models/$fileLabelName");
    } catch (e) {
      print("Error while loading labels: $e");
    }
  }

  /// Runs object detection on the input image
  Map<String, dynamic>? predict(imageLib.Image image) {
    var predictStartTime = DateTime.now().millisecondsSinceEpoch;

    if (_interpreter == null) {
      return null;
    }

    var preProcessStart = DateTime.now().millisecondsSinceEpoch;

    // Initializing TensorImage as the needed model input type
    // of TfLiteType.float32. Then, creating TensorImage from image
    TensorImage inputImage = TensorImage(TfLiteType.float32);
    inputImage.loadImage(image);

    // Do not use static methods, fromImage(Image) or fromFile(File),
    // of TensorImage unless the desired input TfLiteDataType is Uint8.

    // Create TensorImage from image
    //TensorImage inputImage = TensorImage.fromImage(image);

    // Pre-process TensorImage
    inputImage = getProcessedImage(inputImage);

    var preProcessElapsedTime =
        DateTime.now().millisecondsSinceEpoch - preProcessStart;

    ///  normalize from zero to one
    List<double> normalizedInputImage = [];
    for (var pixel in inputImage.tensorBuffer.getDoubleList()) {
      normalizedInputImage.add(pixel / 255.0);
    }

    var normalizedTensorBuffer = TensorBuffer.createDynamic(TfLiteType.float32);
    normalizedTensorBuffer.loadList(normalizedInputImage,
        shape: [_inputShape![1], _inputShape![1], 3]);

    // Inputs object for runForMultipleInputs
    // Use [TensorImage.buffer] or [TensorBuffer.buffer] to pass by reference
    final inputs = [normalizedTensorBuffer.buffer];

    // TensorBuffers for output tensors
    TensorBuffer outputLocations = TensorBufferFloat(
        _outputShapes![0]); // The location of each detected object

    // Outputs map
    Map<int, Object> outputs = {
      0: outputLocations.buffer,
    };

    var inferenceTimeStart = DateTime.now().millisecondsSinceEpoch;

    // run inference
    _interpreter!.runForMultipleInputs(inputs, outputs);

    var inferenceTimeElapsed =
        DateTime.now().millisecondsSinceEpoch - inferenceTimeStart;

    // bool isLandScapeImage;

    // if (image.width > image.height) {
    //   print('landscape image');
    //   isLandScapeImage = true;
    // } else if (image.width < image.height) {
    //   print('portrait image');
    //   isLandScapeImage = false;
    // }

    // var smallHeight = deviceSize.width / (image.width / image.height);
    // var minTop =
    //     (deviceSize.width - smallHeight) / 2;
    // print('check minTop: $minTop');
    // var maxTop = smallHeight + ((deviceSize.width - smallHeight));
    // print('check maxTop: $maxTop');
    // var smallWidth = deviceSize.width / (image.height / image.width);
    // var minLeft =
    //     (deviceSize.width - smallWidth) / 2;
    // print('check minLeft: $minLeft');
    //
    // var maxLeft = smallWidth + ((deviceSize.width - smallWidth) / 2);
    // print('check maxLeft: $maxLeft');

    /// make recognition
    final recognitions = <Recognition>[];
    List<double> results = outputLocations.getDoubleList();
    print('check result: ${results.length}');
    print('check result: ${results[0]}');

    List label0 = [];
    List label1 = [];
    List label2 = [];
    List label3 = [];

    for (var i = 0; i < results.length; i += (5 + clsNum)) {
      // check obj conf
      if (results[i + 4] < objectConfTh || results[i + 4] > 1) continue;

      /// check cls conf
      // double maxClsConf = results[i + 5];
      double maxClsConf =
          results.sublist(i + 5, i + 5 + clsNum - 1).reduce(max);
      // print('check maxClsConf:$maxClsConf');
      if (maxClsConf < classConfTh || maxClsConf > 1) continue;

      /// add detects
      // int cls = 0;
      int cls = results.sublist(i + 5, i + 5 + clsNum - 1).indexOf(maxClsConf) %
          clsNum;
      // print('------------check cls:----------- $cls');

      if (cls == 0) label0.add(cls);
      if (cls == 1) label1.add(cls);
      if (cls == 2) label2.add(cls);
      if (cls == 3) label3.add(cls);

      if (results[i + 2] * _inputShape![1] < (_inputShape![1] / 3) &&
          results[i + 3] * _inputShape![1] < (_inputShape![1] / 3)) {
        Rect outputRect = Rect.fromCenter(
          center: Offset(
            results[i] * _inputShape![1],
            results[i + 1] * _inputShape![1],
          ),
          width: results[i + 2] * _inputShape![1],
          height: results[i + 3] * _inputShape![1],
        );
        Rect transformRect = imageProcessor!
            .inverseTransformRect(outputRect, image.height, image.width);

        recognitions
            .add(Recognition(i, cls.toString(), maxClsConf, transformRect));
      }
    }
    // return recognitions;

    print('day la label0 ${label0.length}');
    print('day la label1 ${label1.length}');
    print('day la label2 ${label2.length}');
    print('day la label3 ${label3.length}');
    print('check zin: ${recognitions.length}');

    // End of for loop and added all recognitions
    List<Recognition> recognitionsNMS = nms(recognitions);

    var predictElapsedTime =
        DateTime.now().millisecondsSinceEpoch - predictStartTime;

    return {
      "recognitions": recognitionsNMS,
      "stats": Stats(
          totalPredictTime: predictElapsedTime,
          inferenceTime: inferenceTimeElapsed,
          preProcessingTime: preProcessElapsedTime)
    };
  }

  /// Gets the interpreter instance
  Interpreter get interpreter => _interpreter!;

  /// Gets the loaded labels
  List<String> get labels => _labels!;

  // non-maximum suppression
  List<Recognition> nms(
      List<Recognition> list) // Turned from Java's ArrayList to Dart's List.
  {
    List<Recognition> nmsList = [];

    for (int k = 0; k < _labels!.length; k++) {
      // 1.find max confidence per class
      PriorityQueue<Recognition> pq = HeapPriorityQueue<Recognition>();
      for (int i = 0; i < list.length; ++i) {
        if (list[i].label == _labels![k]) {
          // Changed from comparing #th class to class to string to string
          pq.add(list[i]);
        }
      }

      // 2.do non maximum suppression
      while (pq.length > 0) {
        // insert detection with max confidence
        List<Recognition> detections = pq.toList(); //In Java: pq.toArray(a)
        Recognition max = detections[0];
        nmsList.add(max);
        pq.clear();
        for (int j = 1; j < detections.length; j++) {
          Recognition detection = detections[j];
          Rect b = detection.location;
          if (boxIou(max.location, b) < mNmsThresh) {
            pq.add(detection);
          }
        }
      }
    }

    return nmsList;
  }

  double boxIou(Rect a, Rect b) {
    return boxIntersection(a, b) / boxUnion(a, b);
  }

  double boxIntersection(Rect a, Rect b) {
    double w = overlap((a.left + a.right) / 2, a.right - a.left,
        (b.left + b.right) / 2, b.right - b.left);
    double h = overlap((a.top + a.bottom) / 2, a.bottom - a.top,
        (b.top + b.bottom) / 2, b.bottom - b.top);
    if ((w < 0) || (h < 0)) {
      return 0;
    }
    double area = (w * h);
    return area;
  }

  double boxUnion(Rect a, Rect b) {
    double i = boxIntersection(a, b);
    double u = ((((a.right - a.left) * (a.bottom - a.top)) +
            ((b.right - b.left) * (b.bottom - b.top))) -
        i);
    return u;
  }

  double overlap(double x1, double w1, double x2, double w2) {
    double l1 = (x1 - (w1 / 2));
    double l2 = (x2 - (w2 / 2));
    double left = ((l1 > l2) ? l1 : l2);
    double r1 = (x1 + (w1 / 2));
    double r2 = (x2 + (w2 / 2));
    double right = ((r1 < r2) ? r1 : r2);
    return right - left;
  }

  void close() {
    _interpreter!.close();
  }
}



