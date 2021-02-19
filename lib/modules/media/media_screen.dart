import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';

import 'camera_view.dart';
import 'preview_view.dart';

// @ Constants
enum MediaScreenState { Default, Ready, Loading, Recording, Captured }

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
  // State Properties
  final state = Rx<MediaScreenState>(MediaScreenState.Default);

  // ^ Set State to Ready ^ //
  static ready() {
    Get.find<MediaScreenController>().state(MediaScreenState.Ready);
    Get.find<MediaScreenController>().state.refresh();
  }

  // ^ Set State to Loading ^ //
  static loading() {
    Get.find<MediaScreenController>().state(MediaScreenState.Loading);
    Get.find<MediaScreenController>().state.refresh();
  }

  // ^ Set State to Recording, Set Video Capture Path ^ //
  static recording(String path) {
    Get.find<PreviewController>().initVideo(path);
    Get.find<MediaScreenController>().state(MediaScreenState.Recording);
    Get.find<MediaScreenController>().state.refresh();
  }

  // ^ Set State to Captured, Set Photo Capture Path ^ //
  static setPhoto(String path) {
    Get.find<PreviewController>().setPhoto(path);
    Get.find<MediaScreenController>().state(MediaScreenState.Captured);
    Get.find<MediaScreenController>().state.refresh();
  }

  // ^ Set State to Captured, Set Video Capture Path ^ //
  static completeVideo() {
    Get.find<PreviewController>().setVideo();
    Get.find<MediaScreenController>().state(MediaScreenState.Captured);
    Get.find<MediaScreenController>().state.refresh();
  }
}
