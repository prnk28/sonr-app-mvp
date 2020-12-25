import 'package:get/get.dart';
import 'package:sonar_app/widgets/card.dart';
import 'package:sonar_app/modules/profile/tile_controller.dart';
import 'profile_controller.dart';
export 'profile_screen.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(ProfileController());
    Get.put<TileController>(TileController());
  }
}
