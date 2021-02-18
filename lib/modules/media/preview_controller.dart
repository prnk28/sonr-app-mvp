import 'dart:io';

import 'package:get/get.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_core/models/models.dart';
import '../home/home_controller.dart';
import 'package:video_player/video_player.dart';

class PreviewController extends GetxController {
  // Properties
  final captureReady = false.obs;
  final isVideo = false.obs;

  // Current Captures Path
  String get capturePath {
    // Video Path
    if (captureReady.value && isVideo.value) {
      return _videoCapturePath;
    }
    // Photo Path
    else if (captureReady.value && !isVideo.value) {
      return _photoCapturePath;
    }
    return "";
  }

  // References
  String _photoCapturePath = "";
  String _videoCapturePath = "";

  // ^ Clear Current Photo ^ //
  clear() async {
    captureReady(false);
    isVideo(false);
    _photoCapturePath = "";
    _videoCapturePath = "";
  }

  // ^ Set Initial Video Path ^ //
  initVideo(String path) {
    isVideo(true);
    _videoCapturePath = path;
  }

  // ^ Video Completed Recording ^ //
  setVideo() async {
    captureReady(true);
  }

  // ^ Set Photo and Capture Ready ^ //
  setPhoto(String path) {
    _photoCapturePath = path;
    isVideo(false);
    captureReady(true);
  }

  // ^ Continue with Media Capture ^ //
  continueMedia() async {
    if (isVideo.value) {
      // Save Video
      Get.find<DeviceService>().savePhotoFromCamera(_videoCapturePath);
      Get.find<SonrService>().setPayload(Payload.MEDIA, path: _videoCapturePath);

      // Go to Transfer
      Get.offNamed("/transfer");
    } else {
      // Save Photo
      Get.find<DeviceService>().savePhotoFromCamera(_photoCapturePath);
      Get.find<SonrService>().setPayload(Payload.MEDIA, path: _photoCapturePath);

      // Go to Transfer
      Get.offNamed("/transfer");
    }
  }
}
