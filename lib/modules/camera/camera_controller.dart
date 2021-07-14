export 'camera.dart';
import 'dart:async';
import 'dart:io';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonr_app/style/style.dart';
import 'package:path_provider/path_provider.dart';

enum CameraViewStatus { Default, Preview, Permissions }

// ** Camera View Controller ** //
class CameraController extends GetxController {
  // Properties
  final doubleZoomed = false.obs;
  final isFlipped = false.obs;
  final videoDuration = 0.obs;
  final videoDurationString = "".obs;
  final videoInProgress = false.obs;
  final zoomLevel = 0.0.obs;
  final hasCaptured = false.obs;
  final result = SFile().obs;
  final status = CameraViewStatus.Default.obs;

  // Notifiers
  final ValueNotifier<double> brightness = ValueNotifier(1);
  final ValueNotifier<CaptureModes> captureMode = ValueNotifier(CaptureModes.PHOTO);
  final ValueNotifier<Size> photoSize = ValueNotifier(Size(Get.width, Get.height));
  final ValueNotifier<Sensors> sensor = ValueNotifier(Sensors.BACK);
  final ValueNotifier<CameraFlashes> switchFlash = ValueNotifier(CameraFlashes.NONE);
  final ValueNotifier<double> zoomNotifier = ValueNotifier(0);

  // Controllers
  final PictureController pictureController = PictureController();
  final VideoController videoController = VideoController();
  final Function(SFile file) selected;

  // Video Duration Handling
  Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;

  CameraController(this.selected);

  // ** Constructer ** //
  @override
  onInit() {
    zoomLevel.listen((value) {
      zoomNotifier.value = 1.0 / value;
    });
    super.onInit();
  }

  /// #### Captures Photo
  capturePhoto() async {
    // Set Path
    var temp = await getApplicationDocumentsDirectory();
    var photoDir = await Directory('${temp.path}/photos').create(recursive: true);
    var photoCapturePath = '${photoDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Capture Photo
    await pictureController.takePicture(photoCapturePath);
    result(SFileItemUtil.newItem(path: photoCapturePath).toSFile());
    hasCaptured(true);
    status(CameraViewStatus.Preview);
  }

  /// #### Decide on Capture
  handleCapture(bool decision) {
    if (decision) {
      Get.back(closeOverlays: true);
      selected(result.value);
      hasCaptured(false);
    } else {
      hasCaptured(false);
      status(CameraViewStatus.Default);
    }
  }

  /// #### Captures Video
  startCaptureVideo() async {
    // Set Path
    var temp = await getApplicationDocumentsDirectory();
    var videoDir = await Directory('${temp.path}/videos').create(recursive: true);
    var videoCapturePath = '${videoDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

    // Capture Photo
    captureMode.value = CaptureModes.VIDEO;
    await videoController.recordVideo(videoCapturePath);
    result(SFileItemUtil.newItem(path: videoCapturePath).toSFile());
    videoInProgress(true);

    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      videoDuration(_stopwatch.elapsedMilliseconds);
      videoDurationString((videoDuration.value ~/ 1000).toString());
    });
  }

  /// #### Stops Video Capture
  stopCaptureVideo() async {
    // Save Video
    await videoController.stopRecordingVideo();
    result.update((val) {
      if (val != null) {
        val.single.properties.duration = videoDuration.value;
      }
    });

    // Reset Duration Management
    _stopwatch.reset();
    _timer.cancel();

    // Update State
    captureMode.value = CaptureModes.PHOTO;
    hasCaptured(true);
  }

  /// #### Flip Camera
  toggleCameraSensor() async {
    // Toggle
    isFlipped(!isFlipped.value);

    if (isFlipped.value) {
      sensor.value = Sensors.FRONT;
    } else {
      sensor.value = Sensors.BACK;
    }
  }
}
