import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'home_controller.dart';
import 'media_picker.dart';
export 'home_screen.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RiveActorController>(
        RiveActorController('assets/animations/tile_preview.riv'));
    Get.put<MediaPickerController>(MediaPickerController());
    Get.put<HomeController>(HomeController());
  }
}
