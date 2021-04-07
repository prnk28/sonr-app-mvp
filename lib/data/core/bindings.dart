import 'package:get/get.dart';
import 'package:sonr_app/modules/home/home_controller.dart';
import 'package:sonr_app/modules/profile/edit_dialog.dart';
import 'package:sonr_app/modules/profile/profile_controller.dart';
import 'package:sonr_app/modules/profile/tile_item.dart';
import 'package:sonr_app/modules/remote/remote_controller.dart';
import 'package:sonr_app/modules/share/share_controller.dart';
import 'package:sonr_app/theme/theme.dart';

// ^ Initial Controller Bindings ^ //
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CameraController>(CameraController());
    Get.create<TransferCardController>(() => TransferCardController());
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
    Get.lazyPut<EditDialogController>(() => EditDialogController());
    Get.create<TileController>(() => TileController());
  }
}
