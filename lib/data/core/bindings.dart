import 'package:get/get.dart';
import 'package:sonr_app/modules/home/home_controller.dart';
import 'package:sonr_app/modules/home/search_view.dart';
import 'package:sonr_app/modules/profile/edit_dialog.dart';
import 'package:sonr_app/modules/profile/profile_controller.dart';
import 'package:sonr_app/modules/profile/tile_item.dart';
import 'package:sonr_app/modules/register/register_screen.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/modules/transfer/transfer_controller.dart';


// ^ Initial Controller Bindings ^ //
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.create<TransferCardController>(() => TransferCardController());
    Get.create<AnimatedController>(() => AnimatedController());
    Get.lazyPut<CameraController>(() => CameraController());
  }
}

// ^ Home Controller Bindings ^ //
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.lazyPut<SearchCardController>(() => SearchCardController());
  }
}

// ^ Transfer Controller Bindings ^ //
class TransferBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<TransferController>(TransferController(), permanent: true);
  }
}

// ^ Register Controller Bindings ^ //
class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RegisterController>(RegisterController());
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
