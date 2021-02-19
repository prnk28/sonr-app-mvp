import 'dart:io';

import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';

import 'camera_view.dart';
import 'preview_view.dart';

// @ Constants
enum MediaScreenState { Default, Camera, Loading, Captured }

class MediaScreen extends GetView<MediaScreenController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.value == MediaScreenState.Captured) {
        return MediaPreviewView();
      } else {
        return CameraView();
      }
    });
  }
}

// ** Main Camera Screen Controller ** //
class MediaScreenController extends GetxController {
  // Properties
  final state = Rx<MediaScreenState>(MediaScreenState.Default);

  // References
  var _videoPath = "";

  // ^ Set State to Ready ^ //
  static ready() {
    Get.find<MediaScreenController>().state(MediaScreenState.Camera);
    Get.find<MediaScreenController>().state.refresh();
  }

  // ^ Set State to Loading ^ //
  static loading() {
    Get.find<MediaScreenController>().state(MediaScreenState.Loading);
    Get.find<MediaScreenController>().state.refresh();
  }

  // ^ Set State to Recording, Set Video Capture Path ^ //
  static recording(String path) {
    Get.find<MediaScreenController>()._videoPath = path;
  }

  // ^ Set State to Captured, Set Photo Capture Path ^ //
  static setPhoto(String path) {
    Get.find<PreviewController>().setPhoto(path);
    Get.find<MediaScreenController>().state(MediaScreenState.Captured);
    Get.find<MediaScreenController>().state.refresh();
  }

  // ^ Set State to Captured, Set Video Capture Path ^ //
  static completeVideo(int milliseconds) async {
    print("----------------------------------");
    print("VIDEO RECORDED");
    print(
        "==> has been recorded : ${File(Get.find<MediaScreenController>()._videoPath).exists} | path : ${Get.find<MediaScreenController>()._videoPath}");
    print("----------------------------------");
    await Future.delayed(Duration(milliseconds: 300));
    Get.find<PreviewController>().setVideo(Get.find<MediaScreenController>()._videoPath);
    Get.find<MediaScreenController>().state(MediaScreenState.Captured);
    Get.find<MediaScreenController>().state.refresh();
  }
}
