import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonr_app/modules/common/peer/peer.dart';
import 'package:sonr_app/modules/common/tile/tile_controller.dart';
import 'package:sonr_app/modules/profile/profile.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/modules/remote/remote_controller.dart';
import 'package:sonr_app/modules/share/share_controller.dart';
import 'package:sonr_app/pages/transfer/transfer_controller.dart';
import 'package:sonr_app/theme/theme.dart';

// ^ Initial Controller Bindings ^ //
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraController>(() => CameraController(), fenix: true);
  }
}

// ^ Profile Controller Bindings ^ //
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<ShareController>(ShareController(), permanent: true);
    Get.lazyPut<RemoteController>(() => RemoteController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.create<TileController>(() => TileController());
  }
}

class TransferBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<TransferController>(TransferController(), permanent: true);
    Get.create<BubbleController>(() => BubbleController(_getRiveDataFile()));
  }

  // Get Rive File for Peer Bubble
  Future<RiveFile> _getRiveDataFile() async {
    var data = await rootBundle.load('assets/rive/peer_bubble.riv');
    return RiveFile.import(data);
  }
}
