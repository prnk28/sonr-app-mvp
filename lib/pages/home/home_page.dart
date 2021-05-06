import 'package:sonr_app/modules/share/share_view.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/pages/home/remote/remote_view.dart';
import 'package:sonr_app/style/style.dart';
import 'recents/recents_view.dart';
import 'home_controller.dart';
import 'activity/activity_view.dart';
import 'profile/profile_view.dart';
import 'search_bar.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
        resizeToAvoidBottomInset: false,
        floatingAction: ShareView(),
        bottomNavigationBar: HomeBottomNavBar(),
        appBar: HomeAppBar(),
        body: Container(
            child: TabBarView(controller: controller.tabController, children: [
          CardMainView(key: ValueKey<HomeView>(HomeView.Main)),
          ProfileView(key: ValueKey<HomeView>(HomeView.Profile)),
          ActivityView(key: ValueKey<HomeView>(HomeView.Activity)),
          RemoteView(key: ValueKey<HomeView>(HomeView.Remote)),
        ])));
  }
}

// ^ Home Tab Bar Navigation ^ //
class HomeBottomNavBar extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomBarClip(),
      child: Container(
        decoration: Neumorphic.floating(),
        width: Get.width,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            HomeBottomTabButton(HomeView.Main, controller.setBottomIndex, controller.bottomIndex),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: HomeBottomTabButton(HomeView.Profile, controller.setBottomIndex, controller.bottomIndex),
            ),
            Container(
              width: Get.width * 0.20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: HomeBottomTabButton(HomeView.Activity, controller.setBottomIndex, controller.bottomIndex),
            ),
            HomeBottomTabButton(HomeView.Remote, controller.setBottomIndex, controller.bottomIndex),
          ],
        ),
      ),
    );
  }
}

// ^ Bottom Bar Button Widget ^ //
class HomeBottomTabButton extends StatelessWidget {
  final HomeView view;
  final Function(int) onPressed;
  final RxInt currentIndex;
  HomeBottomTabButton(this.view, this.onPressed, this.currentIndex);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onPressed(view.index);
        },
        child: Container(
          constraints: BoxConstraints(maxHeight: 80, maxWidth: Get.width / 6),
          padding: const EdgeInsets.all(8.0),
          child: ObxValue<RxInt>(
              (idx) => AnimatedScale(
                    duration: 250.milliseconds,
                    child: AnimatedSlideSwitcher.fade(child: AssetController.getHomeTabBarIcon(view: view, isSelected: idx.value == view.index)),
                    scale: idx.value == view.index ? 1.25 : 1.0,
                  ),
              currentIndex),
        ));
  }
}
