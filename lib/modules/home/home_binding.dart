import 'package:get/get.dart';
import 'package:sonr_app/modules/home/search_view.dart';
import 'package:sonr_app/modules/home/share_button.dart';
import 'home_controller.dart';
export 'home_screen.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ShareButtonController>(ShareButtonController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.lazyPut<SearchCardController>(() => SearchCardController());
  }
}
