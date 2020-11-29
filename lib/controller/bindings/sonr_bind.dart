import 'package:get/get.dart';
import 'package:sonar_app/controller/sonr_controller.dart';

class SonrBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SonrController>(() => SonrController());
  }
}
