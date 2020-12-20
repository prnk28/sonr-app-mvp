import 'package:get/get.dart';
import 'package:sonar_app/modules/transfer/lobby_controller.dart';
import 'compass_controller.dart';
export 'transfer_screen.dart';

class TransferBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CompassController>(CompassController());
    Get.put<LobbyController>(LobbyController());
  }
}
