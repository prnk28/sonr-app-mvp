import 'package:get/get.dart';
import 'package:sonar_app/modules/card/card_controller.dart';
import 'home_controller.dart';
export 'home_screen.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<CardController>(CardController());
  }
}
