import 'package:sonr_app/modules/share/share_view.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'views/remote/remote_view.dart';
import 'package:sonr_app/style/style.dart';
import 'views/grid/grid_view.dart';
import 'home_controller.dart';
import 'views/activity/activity_view.dart';
import 'views/profile/profile_view.dart';
import 'widgets/app_bar.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
      gradient: SonrGradients.PlumBath,
      resizeToAvoidBottomInset: false,
      floatingAction: ShareView(),
      bottomNavigationBar: HomeBottomNavBar(),
      appBar: HomeAppBar(),
      body: Obx(() => AnimatedOpacity(
            duration: 750.milliseconds,
            opacity: controller.isSearchVisible.value ? 0 : 1,
            child: Container(
                child: TabBarView(controller: controller.tabController, children: [
              CardMainView(key: ValueKey<HomeView>(HomeView.Main)),
              ProfileView(key: ValueKey<HomeView>(HomeView.Profile)),
              ActivityView(key: ValueKey<HomeView>(HomeView.Activity)),
              RemoteView(key: ValueKey<HomeView>(HomeView.Remote)),
            ])),
          )),
    );
  }
}

/// @ Home Tab Bar Navigation
class HomeBottomNavBar extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomBarClip(),
      child: Container(
        decoration: Neumorphic.floating(
          theme: Get.theme,
        ),
        width: Get.width,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(() => Bounce(
                from: 12,
                duration: 1000.milliseconds,
                animate: controller.view.value == HomeView.Main,
                key: ValueKey(controller.view.value == HomeView.Main),
                child: HomeBottomTabButton(HomeView.Main, controller.setBottomIndex, controller.bottomIndex))),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Obx(() => Roulette(
                    spins: 1,
                    key: ValueKey(controller.view.value == HomeView.Profile),
                    animate: controller.view.value == HomeView.Profile,
                    child: HomeBottomTabButton(HomeView.Profile, controller.setBottomIndex, controller.bottomIndex),
                  )),
            ),
            Container(
              width: Get.width * 0.20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Obx(() => Swing(
                  key: ValueKey(controller.view.value == HomeView.Activity),
                  animate: controller.view.value == HomeView.Activity,
                  child: HomeBottomTabButton(HomeView.Activity, controller.setBottomIndex, controller.bottomIndex))),
            ),
            Obx(() => Flash(
                key: ValueKey(controller.view.value == HomeView.Remote),
                animate: controller.view.value == HomeView.Remote,
                child: HomeBottomTabButton(HomeView.Remote, controller.setBottomIndex, controller.bottomIndex))),
          ],
        ),
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
          constraints: BoxConstraints(maxHeight: 80, maxWidth: Get.width / 6),
          padding: const EdgeInsets.all(8.0),
          child: ObxValue<RxInt>(
              (idx) => AnimatedScale(
                    duration: 250.milliseconds,
                    child: Container(
                        key: ValueKey(idx.value == view.index),
                        child: Icon(view.iconData, size: 34, color: idx.value == view.index ? Get.theme.primaryColor : Get.theme.hintColor)),
                    scale: idx.value == view.index ? 1.0 : 0.9,
                  ),
              currentIndex),
        ));
  }
}
