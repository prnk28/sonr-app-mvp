import 'package:get/get.dart';
import 'edit_dialog.dart';
import 'social_tile.dart';
import 'tile_stepper.dart';
import 'profile_controller.dart';
export 'profile_screen.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(ProfileController());
    Get.put<EditDialogController>(EditDialogController());
    Get.put<TileStepperController>(TileStepperController());
    Get.create<TileController>(() => TileController());
  }
}
