import 'package:get/get.dart';
import 'package:sonar_app/modules/peer/circle_controller.dart';
import 'package:sonar_app/modules/peer/peer_controller.dart';

import 'compass_controller.dart';

class TransferBinding implements Bindings {
  @override
  void dependencies() {
    Get.create<PeerController>(() => PeerController(), permanent: false);
    Get.lazyPut<CircleController>(() => CircleController(), fenix: true);
    Get.lazyPut<CompassController>(() => CompassController(), fenix: true);
  }
}
