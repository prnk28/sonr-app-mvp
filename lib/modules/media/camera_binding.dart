import 'package:get/get.dart';
import 'media_screen.dart';
export 'media_screen.dart';

class CameraBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MediaScreenController>(MediaScreenController(), permanent: true);
  }
}
