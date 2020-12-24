import 'package:get/get.dart';
import 'package:sonar_app/modules/card/card_controller.dart';
import 'package:sonar_app/social/social_provider.dart';
import 'home_controller.dart';
export 'home_screen.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SocialMediaProvider>(SocialMediaProvider());
    Get.put<CardController>(CardController());
    Get.put<HomeController>(HomeController());
  }
}
