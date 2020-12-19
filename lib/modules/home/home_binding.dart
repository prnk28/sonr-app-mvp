import 'package:get/get.dart';
import 'package:sonar_app/modules/card/card_controller.dart';

import 'home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.create<CardController>(() => CardController());
  }
}
