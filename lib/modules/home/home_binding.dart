import 'package:get/get.dart';
import 'package:sonr_app/modules/home/search_view.dart';
import 'package:sonr_app/modules/media/media_screen.dart';
import 'home_controller.dart';
export 'home_screen.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MediaController>(MediaController(), permanent: true);
    Get.put<HomeController>(HomeController());
    Get.lazyPut<SearchCardController>(() => SearchCardController());
  }
}
