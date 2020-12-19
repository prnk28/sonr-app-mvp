import 'package:get/get.dart';
import 'package:sonar_app/modules/peer/peer_controller.dart';

import 'transfer_controller.dart';

class TransferBinding implements Bindings {
  @override
  void dependencies() {
    Get.create<PeerController>(() => PeerController(), permanent: false);
    Get.put<TransferController>(TransferController());
  }
}
