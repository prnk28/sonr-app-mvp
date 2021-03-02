import 'dart:async';
import 'dart:io';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/models/orientations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/modules/media/picker_sheet.dart';
import 'package:sonr_app/core/core.dart';
import 'package:path_provider/path_provider.dart';

import 'capture_preview.dart';

enum CameraViewType { Default, Preview, Avatar, QRCode }

class CameraView extends GetView<CameraController> {
  // Properties
  final Function(MediaFile file) onMediaSelected;
  final CameraViewType type;
  CameraView({@required this.onMediaSelected, this.type = CameraViewType.Default});

  factory CameraView.withPreview({@required Function(MediaFile file) onMediaSelected}) {
    return CameraView(onMediaSelected: onMediaSelected, type: CameraViewType.Preview);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to Updates
    controller.hasCaptured.listen((val) {
      if (val) {
        if (type == CameraViewType.Default) {
          onMediaSelected(controller.getMediaFile());
        } else if (type == CameraViewType.Preview) {
          Get.dialog(
              MediaPreviewView(
                  mediaFile: controller.getMediaFile(),
                  onDecision: (value) {
                    if (value) {
                      onMediaSelected(controller.getMediaFile());
                    } else {
                      Get.back();
                    }
                  }),
              barrierDismissible: false);
        }
      }
    });

    // Build View
    return Stack(
      children: [
        GestureDetector(
          onDoubleTap: () {
            // Update Double Zoomed
            controller.doubleZoomed(!controller.doubleZoomed.value);

            // Set Zoom Level
            if (controller.doubleZoomed.value) {
              controller.zoomLevel(0.25);
            } else {
              controller.zoomLevel(0.0);
            }
          },
          onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
            // Calculate Scale
            var factor = 1.0 / scaleDetails.scale;
            var adjustedScale = 1 - factor;

            // Set Zoom Level
            if (scaleDetails.pointerCount > 1) {
              controller.zoomLevel(adjustedScale);
            }
          },
          onHorizontalDragUpdate: (details) {
            print("Drag Horizontal: ${details.delta}");
          },
          child: CameraAwesome(
            onPermissionsResult: (bool result) {},
            onOrientationChanged: (CameraOrientations newOrientation) {},
            sensor: controller.sensor,
            zoom: controller.zoomNotifier,
            photoSize: controller.photoSize,
            switchFlashMode: controller.switchFlash,
            captureMode: controller.captureMode,
            brightness: controller.brightness,
          ),
        ),
        // Button Tools View
        _CameraToolsView(),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 14, top: Get.statusBarHeight / 2),
          child: SonrButton.circle(
              intensity: 0.5,
              onPressed: () {
                Get.offNamed("/home");
              },
              icon: SonrIcon.close),
        ),
        Obx(() {
          if (controller.videoInProgress.value) {
            return Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(left: 14, top: Get.statusBarHeight / 2),
              child: Neumorphic(
                style: SonrStyle.timeStamp,
                child: SonrText.duration(controller.videoDuration.value),
                padding: EdgeInsets.all(10),
              ),
            );
          } else {
            return Container();
          }
        })
      ],
    );
  }
}

class _CameraToolsView extends GetView<CameraController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: NeumorphicBackground(
        backendColor: Colors.transparent,
        child: Neumorphic(
          padding: EdgeInsets.only(top: 20, bottom: 40),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            // Switch Camera
            Obx(() => GestureDetector(
                child: SonrIcon.neumorphic(controller.isFlipped.value ? Icons.camera_front_rounded : Icons.swap_vertical_circle_sharp,
                    size: 36, style: NeumorphicStyle(color: Colors.grey)),
                onTap: () async {
                  HapticFeedback.heavyImpact();
                  controller.toggleCameraSensor();
                })),

            // Neumorphic Camera Button Stack
            _CaptureButton(),

            // Media Gallery Picker
            GestureDetector(
                child: SonrIcon.neumorphic(Icons.perm_media, size: 36, style: NeumorphicStyle(color: Colors.grey)),
                onTap: () async {
                  HapticFeedback.heavyImpact();
                  // Check for Permssions
                  if (await Permission.photos.request().isGranted) {
                    // Display Bottom Sheet
                    Get.bottomSheet(MediaPickerSheet(onMediaSelected: (MediaFile file) {
                      SonrService.queueMedia(file);
                      Get.offNamed("/transfer");
                    }), isDismissible: true);
                  } else {
                    // Display Error
                    SonrSnack.error("Sonr isnt permitted to access your media.");
                  }
                }),
          ]),
        ),
      ),
    );
  }
}

class _CaptureButton extends GetView<CameraController> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 150,
        height: 150,
        child: AspectRatio(
          aspectRatio: 1,
          child: Neumorphic(
            margin: EdgeInsets.all(14),
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.circle(),
            ),
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: 14,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              margin: EdgeInsets.all(10),
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: -8,
                  boxShape: NeumorphicBoxShape.circle(),
                ),
                margin: EdgeInsets.all(14),
                child: GestureDetector(
                  onTap: () {
                    controller.capturePhoto();
                  },
                  onLongPressStart: (LongPressStartDetails tapUpDetails) {
                    if (GetPlatform.isIOS) {
                      controller.startCaptureVideo();
                    }
                  },
                  onLongPressEnd: (LongPressEndDetails tapUpDetails) {
                    if (GetPlatform.isIOS) {
                      controller.stopCaptureVideo();
                    }
                  },
                  child: Obx(
                    () => Neumorphic(
                        child: Center(
                            child: SonrIcon.neumorphicGradient(
                          SonrIconData.camera,
                          FlutterGradientNames.premiumDark,
                          size: 40,
                        )),
                        style: NeumorphicStyle(
                            depth: 14,
                            intensity: 0.85,
                            boxShape: NeumorphicBoxShape.circle(),
                            border: controller.videoInProgress.value
                                ? NeumorphicBorder(color: Colors.redAccent, width: 4)
                                : NeumorphicBorder(color: Colors.black, width: 0))),
                  ),
                ),
                // Interior Compass
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

// ** Camera View Controller ** //
class CameraController extends GetxController {
  // Properties
  final doubleZoomed = false.obs;
  final isFlipped = false.obs;
  final videoDuration = 0.obs;
  final videoInProgress = false.obs;
  final zoomLevel = 0.0.obs;
  final hasCaptured = false.obs;

  // References
  var _isVideo = false;
  var _photoCapturePath = "";
  var _videoCapturePath = "";

  // Notifiers
  ValueNotifier<double> brightness = ValueNotifier(1);
  ValueNotifier<CaptureModes> captureMode = ValueNotifier(CaptureModes.PHOTO);
  ValueNotifier<Size> photoSize = ValueNotifier(Size(Get.width, Get.height));
  ValueNotifier<Sensors> sensor = ValueNotifier(Sensors.BACK);
  ValueNotifier<CameraFlashes> switchFlash = ValueNotifier(CameraFlashes.NONE);
  ValueNotifier<double> zoomNotifier = ValueNotifier(0);

  // Controllers
  PictureController pictureController = new PictureController();
  VideoController videoController = new VideoController();

  // Video Duration Handling
  Stopwatch _stopwatch = new Stopwatch();
  Timer _timer;

  // ** Constructer ** //
  CameraController() {
    zoomLevel.listen((value) {
      zoomNotifier.value = 1.0 / value;
    });
  }

  // ^ Captures Photo ^ //
  capturePhoto() async {
    // Set Path
    var temp = await getApplicationDocumentsDirectory();
    var photoDir = await Directory('${temp.path}/photos').create(recursive: true);
    _photoCapturePath = '${photoDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    _isVideo = false;

    // Capture Photo
    await pictureController.takePicture(_photoCapturePath);
    hasCaptured(true);
  }

  // ^ Returns Captured Media File ^ //
  MediaFile getMediaFile() {
    return MediaFile.capture(_isVideo ? _videoCapturePath : _photoCapturePath, _isVideo, videoDuration.value);
  }

  // ^ Captures Video ^ //
  startCaptureVideo() async {
    // Set Path
    var temp = await getApplicationDocumentsDirectory();
    var videoDir = await Directory('${temp.path}/videos').create(recursive: true);
    _videoCapturePath = '${videoDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
    _isVideo = true;

    // Capture Photo
    captureMode.value = CaptureModes.VIDEO;
    await videoController.recordVideo(_videoCapturePath);
    videoInProgress(true);

    _stopwatch.start();
    _timer = new Timer.periodic(new Duration(milliseconds: 50), (timer) {
      videoDuration(_stopwatch.elapsedMilliseconds);
    });
  }

  // ^ Stops Video Capture ^ //
  stopCaptureVideo() async {
    // Save Video
    await videoController.stopRecordingVideo();

    // Reset Duration Management
    _stopwatch.reset();
    _timer.cancel();

    // Update State
    captureMode.value = CaptureModes.PHOTO;
    hasCaptured(true);
  }

  // ^ Flip Camera ^ //
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
