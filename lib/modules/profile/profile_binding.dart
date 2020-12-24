import 'package:get/get.dart';
import 'package:sonar_app/modules/card/card_controller.dart';
import 'package:sonar_app/modules/profile/tile_controller.dart';
import 'package:sonar_app/social/social_provider.dart';
import 'profile_controller.dart';
export 'profile_screen.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CardController>(CardController());
    Get.put<ProfileController>(ProfileController());
    Get.put<TileController>(TileController());
  }
}
