import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';

import 'camera_view.dart';
import 'preview_view.dart';

// @ Constants
enum CameraScreenState { Default, Ready, Loading, Recording, Captured }

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (CameraScreenController.state == CameraScreenState.Default) {
        return SonrAnimatedWaveIcon(Icons.camera_alt_outlined);
      } else if (CameraScreenController.state == CameraScreenState.Captured) {
        return MediaPreviewView();
      } else {
        return CameraView();
      }
    });
  }
}

// ** Main Camera Screen Controller ** //
class CameraScreenController extends GetxController {
  // State Properties
  final _stateRx = Rx<CameraScreenState>(CameraScreenState.Default);
  static CameraScreenState get state => Get.find<CameraScreenController>()._stateRx.value;

  // ^ Set State to Ready ^ //
  static ready() {
    Get.find<CameraScreenController>()._stateRx(CameraScreenState.Loading);
  }

  // ^ Set State to Loading ^ //
  static loading() {
    Get.find<CameraScreenController>()._stateRx(CameraScreenState.Loading);
  }

  // ^ Set State to Captured, Set Photo Capture Path ^ //
  static setPhoto(String path) {
    Get.find<PreviewController>().setPhoto(path);
    Get.find<CameraScreenController>()._stateRx(CameraScreenState.Captured);
  }

  // ^ Set State to Recording, Set Video Capture Path ^ //
  static recording(String path) {
    Get.find<PreviewController>().initVideo(path);
    Get.find<CameraScreenController>()._stateRx(CameraScreenState.Recording);
  }

  // ^ Set State to Captured, Set Video Capture Path ^ //
  static completeVideo() {
    Get.find<PreviewController>().setVideo();
    Get.find<CameraScreenController>()._stateRx(CameraScreenState.Captured);
  }
}
