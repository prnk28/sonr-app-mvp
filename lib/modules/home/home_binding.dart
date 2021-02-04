import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'camera_picker.dart';
import 'home_controller.dart';
import 'media_picker.dart';
export 'home_screen.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RiveActorController>(
        RiveActorController('assets/animations/tile_preview.riv'));
    Get.put<CameraPickerController>(CameraPickerController(), permanent: true);
    Get.put<MediaPickerController>(MediaPickerController(), permanent: true);
    Get.put<HomeController>(HomeController());
  }
}
