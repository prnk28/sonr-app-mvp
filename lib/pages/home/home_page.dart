import 'package:sonr_app/modules/share/button_view.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/style/style.dart';
import 'views/dashboard/dashboard_view.dart';
import 'home_controller.dart';
import 'views/contact/profile_view.dart';
import 'widgets/app_bar.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
      gradient: SonrGradients.PlumBath,
      resizeToAvoidBottomInset: false,
      floatingAction: ShareButton(),
      bottomNavigationBar: HomeBottomNavBar(),
      appBar: HomeAppBar(),
      body: Container(
          child: TabBarView(controller: controller.tabController, children: [
        DashboardView(key: ValueKey<HomeView>(HomeView.Dashboard)),
        ProfileView(key: ValueKey<HomeView>(HomeView.Contact)),
      ])),
    );
  }
}

/// @ Home Tab Bar Navigation
class HomeBottomNavBar extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Neumorphic.floating(theme: Get.theme, radius: 20),
      margin: EdgeInsets.symmetric(horizontal: 42),
      height: 80,
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
    );
  }
}

/// @ Bottom Bar Button Widget
class HomeBottomTabButton extends GetView<HomeController> {
  final HomeView view;
  final void Function(int) onPressed;
  final void Function(int)? onLongPressed;
  final RxInt currentIndex;
  HomeBottomTabButton(this.view, this.onPressed, this.currentIndex, {this.onLongPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onPressed(view.index);
        },
        onLongPress: () {
          if (onLongPressed != null) {
            onLongPressed!(view.index);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: ObxValue<RxInt>(
              (idx) => AnimatedScale(
                    duration: 250.milliseconds,
                    child: Container(
                        key: ValueKey(idx.value == view.index),
                        child:
                            idx.value == view.index ? view.iconData.gradient(size: 38) : Icon(view.iconData, size: 38, color: Get.theme.hintColor)),
                    scale: idx.value == view.index ? 1.0 : 0.9,
                  ),
              currentIndex),
        ));
  }
}
