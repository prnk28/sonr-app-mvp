import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/models/orientations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/modules/media/picker_sheet.dart';
import 'package:sonr_app/theme/theme.dart';
import 'media_controller.dart';

class CameraView extends GetView<MediaController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // @ Display Current Picture
      if (controller.hasCapture.value) {
        return Stack(
          children: [
            // Preview
            Container(
              width: Get.width,
              height: Get.height,
              child: Image.file(File(controller.capturePath.value)),
            ),

            // Buttons
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 25),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                // Left Button - Cancel and Retake
                SonrButton.circle(
                    onPressed: () {
                      controller.clearPhoto();
                    },
                    icon: SonrIcon.close),

                // Right Button - Continue and Accept
                SonrButton.circle(
                    onPressed: () {
                      controller.continuePhoto();
                    },
                    icon: SonrIcon.accept),
              ]),
            ),
          ],
        );
      }

      // Display Camera View
      else {
        return Stack(
          children: [
            GestureDetector(
              onDoubleTap: () {
                // Update Double Zoomed
                controller.doubleZoomed(!controller.doubleZoomed.value);

                // Set Zoom Level
                if (controller.doubleZoomed.value && controller.zoomLevel.value > 0) {
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
                onCameraStarted: () {},
                onOrientationChanged: (CameraOrientations newOrientation) {},
                sensor: controller.sensor,
                zoom: controller.zoomNotifier,
                photoSize: controller.photoSize,
                switchFlashMode: controller.switchFlash,
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
          ],
        );
      }
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
            Stack(alignment: Alignment.center, children: [
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
                        child: NeumorphicButton(
                          style: NeumorphicStyle(
                              color: SonrColor.baseWhite,
                              depth: 14,
                              intensity: 0.85,
                              boxShape: NeumorphicBoxShape.circle(),
                              border: NeumorphicBorder(color: Colors.black, width: 2)),
                          onPressed: () {
                            controller.capturePhoto();
                          },
                        ),
                        // Interior Compass
                      ),
                    ),
                  ),
                ),
              ),
            ]),

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
