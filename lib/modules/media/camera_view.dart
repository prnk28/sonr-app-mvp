import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/models/orientations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/modules/media/media_picker.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'camera_screen.dart';

class CameraView extends GetView<CameraController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
              onCameraStarted: () {
                CameraScreenController.ready();
              },
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
                  Get.back();
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
                  child: SonrText.duration(controller.stopwatch.elapsed),
                  padding: EdgeInsets.all(10),
                ),
              );
            } else {
              return Container();
            }
          })
        ],
      );
    });
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
                    Get.bottomSheet(MediaPickerSheet(), isDismissible: true);
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
                    controller.startCaptureVideo();
                  },
                  onLongPressEnd: (LongPressEndDetails tapUpDetails) {
                    controller.stopCaptureVideo();
                  },
                  child: Obx(
                    () => Neumorphic(
                        style: NeumorphicStyle(
                            color: SonrColor.baseWhite,
                            depth: 14,
                            intensity: 0.85,
                            boxShape: NeumorphicBoxShape.circle(),
                            border: controller.videoInProgress.value
                                ? NeumorphicBorder(color: Colors.redAccent, width: 4)
                                : NeumorphicBorder(color: Colors.black, width: 2))),
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
  Stopwatch stopwatch = new Stopwatch();

  // ** Constructer ** //
  CameraController() {
    zoomLevel.listen((value) {
      zoomNotifier.value = 1.0 / value;
    });
  }

  // ^ Captures Photo ^ //
  capturePhoto() async {
    // Update State
    CameraScreenController.loading();

    // Set Path
    var now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd–jms').format(now);
    var docs = await getApplicationDocumentsDirectory();
    var path = docs.path + "/SONR_PICTURE_" + formattedDate + ".jpeg";

    // Capture Photo
    await pictureController.takePicture(path);
    CameraScreenController.setPhoto(path);
  }

  // ^ Captures Video ^ //
  startCaptureVideo() async {
    // Set Path
    var now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd–jms').format(now);
    var docs = await getApplicationDocumentsDirectory();
    var path = docs.path + "/SONR_VIDEO_" + formattedDate + ".mp4";
    CameraScreenController.recording(path);

    // Capture Photo
    captureMode.value = CaptureModes.VIDEO;
    videoInProgress(true);
    stopwatch.start();
    await videoController.recordVideo(path);
  }

  // ^ Stops Video Capture ^ //
  stopCaptureVideo() async {
    // Close Parameters
    videoInProgress(false);
    stopwatch.stop();
    videoDuration(stopwatch.elapsedMilliseconds);

    // Save Video
    await videoController.stopRecordingVideo();
    stopwatch.reset();

    // Update State
    CameraScreenController.completeVideo();
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
