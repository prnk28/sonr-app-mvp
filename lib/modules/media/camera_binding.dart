import 'package:get/get.dart';
import 'media_controller.dart';
import 'preview_controller.dart';
export 'camera_screen.dart';

class CameraBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MediaController>(MediaController(), permanent: true);
    Get.put<PreviewController>(PreviewController(), permanent: true);
  }
}
