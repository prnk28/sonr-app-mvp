import 'package:get/get.dart';
import 'package:sonr_app/modules/home/search_dialog.dart';
import 'package:sonr_app/modules/media/media_controller.dart';
import 'package:sonr_app/modules/media/preview_controller.dart';
import 'home_controller.dart';
export 'home_screen.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MediaController>(MediaController(), permanent: true);
    Get.put<PreviewController>(PreviewController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.lazyPut<SearchCardController>(() => SearchCardController());
  }
}
