import 'package:get/get.dart';
import 'controller.dart';
import 'package:sonar_app/ui/ui.dart';

class SplashBind extends Bindings {
  @override
  void dependencies() {
    Get.put<DeviceController>(DeviceController(), permanent: true);
    Get.put<ConnController>(ConnController(), permanent: true);
  }
}

class HomeBind extends Bindings {
  @override
  void dependencies() {
    Get.put<ReceiveController>(ReceiveController());
  }
}

class TransferBind extends Bindings {
  @override
  void dependencies() {
    Get.put<LobbyController>(LobbyController());
    Get.put<TransferController>(TransferController());
  }
}
