import 'package:get/get.dart';
import 'package:sonr_app/modules/nav/nav_controller.dart';
import 'package:sonr_app/modules/profile/edit_dialog.dart';
import 'package:sonr_app/modules/profile/profile_controller.dart';
import 'package:sonr_app/modules/profile/tile_item.dart';
import 'package:sonr_app/theme/theme.dart';

// ^ Initial Controller Bindings ^ //
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<NavController>(NavController(), permanent: true);
    Get.create<TransferCardController>(() => TransferCardController());
    Get.create<AnimatedController>(() => AnimatedController());
    Get.lazyPut<CameraController>(() => CameraController());
  }
}

// ^ Profile Controller Bindings ^ //
class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(ProfileController());
    Get.put<EditDialogController>(EditDialogController());
    Get.create<TileController>(() => TileController());
  }
}
