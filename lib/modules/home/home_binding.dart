import 'package:get/get.dart';
import 'package:sonr_app/modules/home/search_view.dart';
import 'home_controller.dart';
export 'home_screen.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.lazyPut<SearchCardController>(() => SearchCardController());
  }
}

class HomeArguments {
  final bool isFirstLoad;
  final bool hasNewCard;
  final bool firstNewCard;

  HomeArguments({this.isFirstLoad = false, this.hasNewCard = false, this.firstNewCard = false});
}
