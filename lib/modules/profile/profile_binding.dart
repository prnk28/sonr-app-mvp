import 'package:get/get.dart';
import 'package:sonar_app/service/device_service.dart';
import 'profile_controller.dart';
export 'profile_screen.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
        () => ProfileController(Get.find<DeviceService>().user.contact));
  }
}
