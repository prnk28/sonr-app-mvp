import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/models/orientations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/modules/media/picker_sheet.dart';
import 'package:sonr_app/theme/theme.dart';
import 'media_controller.dart';

class MediaCameraView extends GetView<MediaController> {
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
            child: CameraAwesome(
              onPermissionsResult: (bool result) {},
              onCameraStarted: () {
                controller.setState(CameraControllerState.Ready);
              },
              onOrientationChanged: (CameraOrientations newOrientation) {},
              sensor: controller.sensor,
              zoom: controller.zoomNotifier,
              photoSize: controller.photoSize,
              switchFlashMode: controller.switchFlash,
              captureMode: controller.captureMode,
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

class _CameraToolsView extends GetView<MediaController> {
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
            GestureDetector(
                child: SonrIcon.neumorphic(Icons.swap_vertical_circle_sharp, size: 36, style: NeumorphicStyle(color: Colors.grey)),
                onTap: () async {
                  HapticFeedback.heavyImpact();
                  controller.toggleCameraSensor();
                }),

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
                    Get.bottomSheet(MediaSheet(), isDismissible: true);
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

class _CaptureButton extends GetView<MediaController> {
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
