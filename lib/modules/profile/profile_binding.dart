import 'package:get/get.dart';
import 'package:sonar_app/modules/card/card_controller.dart';
import 'profile_controller.dart';
export 'profile_screen.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CardController());
    Get.put<ProfileController>(ProfileController());
  }
}
