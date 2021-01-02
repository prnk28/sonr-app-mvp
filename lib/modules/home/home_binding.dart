import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'home_controller.dart';
export 'home_screen.dart';

class HomeBinding implements Bindings {
  final path = 'assets/animations/tile_preview.riv';
  @override
  void dependencies() {
    Get.put<RiveActorController>(RiveActorController(path));
    Get.put<HomeController>(HomeController());
  }
}
