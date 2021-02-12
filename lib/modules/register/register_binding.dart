import 'package:get/get.dart';
import 'register_screen.dart';
export 'register_screen.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RegisterController>(RegisterController());
  }
}
