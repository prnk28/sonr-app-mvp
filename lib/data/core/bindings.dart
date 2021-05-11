import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonr_app/modules/card/tile/tile_controller.dart';
import 'package:sonr_app/modules/peer/peer_controller.dart';
import 'package:sonr_app/pages/desktop/controllers/explorer_controller.dart';
import 'package:sonr_app/pages/desktop/controllers/link_controller.dart';
import 'package:sonr_app/pages/desktop/controllers/window_controller.dart';
import 'package:sonr_app/pages/home/views/main/main_controller.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/modules/share/share_controller.dart';
import 'package:sonr_app/pages/home/views/profile/profile_controller.dart';
import 'package:sonr_app/pages/home/views/remote/remote_controller.dart';
import 'package:sonr_app/pages/register/register_controller.dart';
import 'package:sonr_app/pages/transfer/transfer_controller.dart';
import 'package:sonr_app/style/style.dart';

/// @ Initial Controller Bindings
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AssetController>(AssetController(), permanent: true);
  }
}

/// @ Desktop Window Bindings
class DesktopBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<WindowController>(WindowController(), permanent: true);
    Get.put<LinkController>(LinkController());
    Get.put<ExplorerController>(ExplorerController(), permanent: true);
    Get.create<PeerController>(() => PeerController(_getRiveDataFile()));
  }

  // Get Rive File for Peer Bubble
  Future<RiveFile> _getRiveDataFile() async {
    var data = await rootBundle.load('assets/rive/peer_border.riv');
    return RiveFile.import(data);
  }
}

/// @ Home Controller Bindings
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<ShareController>(ShareController(), permanent: true);
    Get.put<RecentsController>(RecentsController(), permanent: true);
    Get.put<RemoteController>(RemoteController(), permanent: true);
    Get.put<ProfileController>(ProfileController(), permanent: true);
    Get.create<TileController>(() => TileController());
  }
}

/// @ Register Page Bindings
class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RegisterController>(RegisterController());
  }
}

/// @ Transfer Screen Bindings
class TransferBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<TransferController>(TransferController(), permanent: true);
    Get.create<PeerController>(() => PeerController(_getRiveDataFile()));
  }

  // Get Rive File for Peer Bubble
  Future<RiveFile> _getRiveDataFile() async {
    var data = await rootBundle.load('assets/rive/peer_border.riv');
    return RiveFile.import(data);
  }
}
