import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';

import 'profile_controller.dart';

class ProfilePictureController extends GetxController {
  // Notifiers
  ValueNotifier<CaptureModes> captureMode = ValueNotifier(CaptureModes.PHOTO);
  ValueNotifier<Size> photoSize = ValueNotifier(Size(256, 256));
  ValueNotifier<Sensors> sensor = ValueNotifier(Sensors.FRONT);

  final hasCaptured = false.obs;

  // Controllers
  PictureController pictureController = new PictureController();
  var _photoCapturePath = "";

  capturePhoto() async {
    // Set Path
    var temp = await getApplicationDocumentsDirectory();
    var photoDir = await Directory('${temp.path}/photos').create(recursive: true);
    _photoCapturePath = '${photoDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Capture Photo
    await pictureController.takePicture(_photoCapturePath);
    hasCaptured(true);
  }

  confirm() async {
    if (_photoCapturePath != "") {
      var file = MediaFile.capture(_photoCapturePath, false, 0);
      UserService.setPicture(await file.toUint8List());
      Get.find<ProfileController>().exitToViewing();
    }
  }
}
