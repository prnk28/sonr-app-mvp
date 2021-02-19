import 'package:get/get.dart';
import 'edit_dialog.dart';
import 'tile_item.dart';
import 'profile_controller.dart';
export 'profile_screen.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(ProfileController());
    Get.put<EditDialogController>(EditDialogController());
    Get.create<TileController>(() => TileController());
  }
}
