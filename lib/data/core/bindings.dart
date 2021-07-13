import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/modules/activity/activity.dart';
import 'package:sonr_app/modules/peer/peer.dart';
import 'package:sonr_app/modules/share/share.dart';

import 'package:sonr_app/pages/home/home.dart';
import 'package:sonr_app/pages/personal/personal.dart';
import 'package:sonr_app/pages/register/register.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';

/// #### Initial Controller Bindings
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.create<PeerController>(() => PeerController());
  }
}

/// #### Home Controller Bindings
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    // Subsidary Controllers
    Get.put(ActivityController());

    // Place Device Specific Controllers
    if (DeviceService.isMobile) {
      Get.put(ShareController());
      Get.put<PersonalController>(PersonalController());
      Get.put<IntelController>(IntelController(), permanent: true);
      Get.put<EditorController>(EditorController(), permanent: true);
      Get.create<TileController>(() => TileController());
      Get.create<MediaItemController>(() => MediaItemController());
    }
  }
}

/// #### Register Page Bindings
class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RegisterController>(RegisterController());
  }
}

/// #### Transfer Screen Bindings
class TransferBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<TransferController>(TransferController(), permanent: true);
    Get.put<PositionController>(PositionController(), permanent: true);
    Get.create<ItemController>(() => ItemController());
  }
}
