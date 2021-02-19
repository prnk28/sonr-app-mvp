import 'package:get/get.dart';
import 'media_screen.dart';
import 'picker_sheet.dart';
import 'preview_view.dart';
import 'camera_view.dart';
export 'media_screen.dart';

class CameraBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MediaScreenController>(MediaScreenController(), permanent: true);
    Get.put<CameraController>(CameraController(), permanent: true);
    Get.put<MediaPickerController>(MediaPickerController(), permanent: true);
    Get.lazyPut<PreviewController>(() => PreviewController());
  }
}
