import 'package:sonr_app/pages/home/home.dart';
import 'package:sonr_app/style/style.dart';

/// @ Home Tab Bar Navigation
class HomeFloatingBar extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Container(
      child: Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
        BoxContainer(
          radius: 28.13,
          margin: EdgeInsets.symmetric(horizontal: 72),
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(() => Bounce(
                  from: 12,
                  duration: 1000.milliseconds,
                  animate: controller.view.value == HomeView.Dashboard,
                  key: ValueKey(controller.view.value == HomeView.Dashboard),
                  child: ShowcaseItem.fromType(
                      type: ShowcaseType.Dashboard,
                      child: HomeBottomTabButton(HomeView.Dashboard, controller.setBottomIndex, controller.bottomIndex)))),
              Container(
                width: Get.width * 0.20,
              ),
              Obx(() => Roulette(
                    spins: 1,
                    key: ValueKey(controller.view.value == HomeView.Contact),
                    animate: controller.view.value == HomeView.Contact,
                    child: ShowcaseItem.fromType(
                        type: ShowcaseType.Personal, child: HomeBottomTabButton(HomeView.Contact, controller.setBottomIndex, controller.bottomIndex)),
                  )),
            ],
          ),
        ),
        ShowcaseItem.fromType(
          type: ShowcaseType.ShareStart,
          child: ShareButton(),
        ),
      ]),
    );
  }
}
