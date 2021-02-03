import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/models/orientations.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class CameraView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return CameraAwesome(
      testMode: false,
      onPermissionsResult: (bool result) {},
      selectDefaultSize: (List<Size> availableSizes) => Size(1920, 1080),
      onCameraStarted: () {},
      onOrientationChanged: (CameraOrientations newOrientation) {},
      sensor: controller.sensor,
      photoSize: controller.photoSize,
      switchFlashMode: controller.switchFlash,
      fitted: true,
    );
  }
}
