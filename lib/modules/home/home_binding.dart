import 'package:get/get.dart';
import 'package:sonr_app/modules/home/search_dialog.dart';
import 'package:sonr_app/theme/theme.dart';
import 'camera_view.dart';
import 'home_controller.dart';
import 'media_sheet.dart';
export 'home_screen.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RiveActorController>(RiveActorController('assets/animations/tile_preview.riv'));
    Get.put<CameraPickerController>(CameraPickerController(), permanent: true);
    Get.put<MediaPickerController>(MediaPickerController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<SearchDialogController>(SearchDialogController());
  }
}
