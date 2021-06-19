import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/style.dart';
import 'button.dart';

/// @ Home Tab Bar Navigation
class HomeFloatingBar extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: SonrTheme.backgroundColor, width: 1),
            color: SonrTheme.foregroundColor,
            borderRadius: BorderRadius.circular(28.13),
            boxShadow: SonrTheme.boxShadow,
          ),
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
                  child: HomeBottomTabButton(HomeView.Dashboard, controller.setBottomIndex, controller.bottomIndex))),
              Container(
                width: Get.width * 0.20,
              ),
              Obx(() => Roulette(
                    spins: 1,
                    key: ValueKey(controller.view.value == HomeView.Contact),
                    animate: controller.view.value == HomeView.Contact,
                    child: HomeBottomTabButton(HomeView.Contact, controller.setBottomIndex, controller.bottomIndex),
                  )),
            ],
          ),
        ),
        ShareButton(),
      ]),
    );
  }
}
