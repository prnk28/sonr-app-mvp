import 'package:get/get.dart';
import 'camera_screen.dart';
import 'media_picker.dart';
import 'preview_view.dart';
import 'camera_view.dart';
export 'camera_screen.dart';

class CameraBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CameraScreenController>(CameraScreenController(), permanent: true);
    Get.put<CameraController>(CameraController());
    Get.put<MediaPickerController>(MediaPickerController());
    Get.lazyPut<PreviewController>(() => PreviewController());
  }
}
