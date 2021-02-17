import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/models/orientations.dart';
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
            CameraAwesome(
              testMode: false,
              onPermissionsResult: (bool result) {},
              onCameraStarted: () {},
              onOrientationChanged: (CameraOrientations newOrientation) {},
              sensor: controller.sensor,
              photoSize: controller.photoSize,
              switchFlashMode: controller.switchFlash,
            ),
            // Buttons
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 25),
              margin: EdgeInsets.only(right: Get.width / 2 - 40),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: SonrButton.rectangle(
                      intensity: 0.5,
                      text: SonrText.normal(""),
                      onPressed: () async {
                        // Check for Permssions
                        if (await Permission.photos.request().isGranted) {
                          // Display Bottom Sheet
                          Get.bottomSheet(MediaSheet(), isDismissible: true);
                        } else {
                          // Display Error
                          SonrSnack.error("Sonr isnt permitted to access your media.");
                        }
                      },
                      icon: SonrIcon.gradient(Icons.perm_media, FlutterGradientNames.awesomePine)),
                ),
                SonrButton.circle(
                    intensity: 0.5,
                    text: SonrText.normal(""),
                    onPressed: () {
                      controller.capturePhoto();
                    },
                    icon: SonrIcon.gradient(Icons.camera, FlutterGradientNames.alchemistLab)),
                //Spacer()
              ]),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 10, top: Get.statusBarHeight / 2),
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
