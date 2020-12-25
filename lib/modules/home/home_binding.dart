import 'package:get/get.dart';
import 'package:sonar_app/widgets/card.dart';
import 'home_controller.dart';
export 'home_screen.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SonrCardController>(SonrCardController());
    Get.put<HomeController>(HomeController());
  }
}
