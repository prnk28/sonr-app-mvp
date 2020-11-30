import 'package:get/get.dart';
import 'controller.dart';
import 'package:sonar_app/ui/ui.dart';

class AppBind extends Bindings {
  @override
  void dependencies() {
    Get.put<DeviceController>(DeviceController(), permanent: true);
    Get.put<ConnController>(ConnController(), permanent: true);
    Get.put<ReceiveController>(ReceiveController(), permanent: true);
    Get.put<LobbyController>(LobbyController(), permanent: true);
    Get.put<TransferController>(TransferController(), permanent: true);
  }
}

class HomeBind extends Bindings {
  @override
  void dependencies() {
    Get.put<FileController>(FileController(), permanent: true);
  }
}

class TransferBind extends Bindings {
  @override
  void dependencies() {
    //Get.put<LobbyController>(LobbyController(), permanent: true);
    //Get.put<TransferController>(TransferController(), permanent: true);
  }
}
