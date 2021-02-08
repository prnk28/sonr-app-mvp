import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/models/orientations.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

import 'home_controller.dart';

class CameraPicker extends GetView<CameraPickerController> {
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
                SonrButton.close(() {
                  controller.clearPhoto();
                }),

                // Right Button - Continue and Accept
                SonrButton.accept(() {
                  controller.continuePhoto();
                }),
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
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                SonrButton.circle(SonrText.normal(""), () {
                  controller.capturePhoto();
                }, icon: SonrIcon.gradient(Icons.camera, FlutterGradientNames.alchemistLab)),
              ]),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 10),
              child: SonrButton.close(
                () {
                  Get.back();
                },
              ),
            ),
          ],
        );
      }
    });
  }
}

// ** MediaPicker GetXController ** //
class CameraPickerController extends GetxController {
  // Properties
  final videoDuration = 0.obs;
  final videoInProgress = false.obs;
  final hasCapture = false.obs;
  final capturePath = "".obs;

  // References
  bool _isFlipped = false;

  // Notifiers
  ValueNotifier<CameraFlashes> switchFlash = ValueNotifier(CameraFlashes.NONE);
  ValueNotifier<Sensors> sensor = ValueNotifier(Sensors.BACK);
  ValueNotifier<Size> photoSize = ValueNotifier(null);

  // Controllers
  PictureController pictureController = new PictureController();

  // ^ Captures Photo ^ //
  capturePhoto() async {
    // Set Path
    var now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd–jms').format(now);
    var docs = await getApplicationDocumentsDirectory();
    var path = docs.path + "/SONR_PICTURE_" + formattedDate + ".jpeg";

    // Capture Photo
    await pictureController.takePicture(path);
    capturePath(path);
    hasCapture(true);
  }

  // ^ Clear Current Photo ^ //
  clearPhoto() async {
    hasCapture(false);
    capturePath("");
  }

  // ^ Continue with Capture ^ //
  continuePhoto() async {
    // Save Photo
    Get.find<DeviceService>().savePhoto(capturePath.value);

    Get.find<SonrService>().process(Payload.MEDIA, file: File(capturePath.value));

    // Close Share Button
    Get.find<HomeController>().toggleShareExpand();

    // Go to Transfer
    Get.offNamed("/transfer");
  }

  // ^ Flip Camera ^ //
  toggleCameraSensor() async {
    // Toggle
    _isFlipped = !_isFlipped;

    if (_isFlipped) {
      sensor.value = Sensors.FRONT;
    } else {
      sensor.value = Sensors.BACK;
    }
  }
}
