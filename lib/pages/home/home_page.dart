import 'package:sonr_app/modules/share/share_view.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/pages/home/remote/remote_view.dart';
import 'package:sonr_app/theme/theme.dart';
import 'action_button.dart';
import 'recents/recents_view.dart';
import 'home_controller.dart';
import 'activity/activity_view.dart';
import 'profile/profile_view.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
        resizeToAvoidBottomInset: false,
        floatingAction: ShareView(),
        bottomNavigationBar: HomeBottomNavBar(),
        appBar: DesignAppBar(
          subtitle: Obx(() => controller.view.value == HomeView.Main
              ? "Hi ${UserService.contact.value.firstName},".headThree(color: SonrColor.Black, weight: FontWeight.w400, align: TextAlign.start)
              : Container()),
          action: HomeActionButton(),
          title: Obx(() => AnimatedSlideSwitcher.fade(
                duration: 2.seconds,
                child: GestureDetector(
                  key: ValueKey<String>(controller.titleText.value),
                  onTap: () {
                    if (controller.isTitleVisible.value) {
                      controller.swapTitleText("${LobbyService.localSize.value} Around", timeout: 2500.milliseconds);
                    }
                  },
                  child: controller.titleText.value.headThree(color: SonrColor.Black, weight: FontWeight.w800, align: TextAlign.start),
                ),
              )),
        ),
        body: _HomePageView());
  }
}

// ^ Handles Active Views on Home Page ^ //
class _HomePageView extends GetView<HomeController> {
  // View References
  final main = CardMainView(key: ValueKey<HomeView>(HomeView.Main));
  final profile = ProfileView(key: ValueKey<HomeView>(HomeView.Profile));
  final alerts = ActivityView(key: ValueKey<HomeView>(HomeView.Activity));
  final remote = RemoteView(key: ValueKey<HomeView>(HomeView.Remote));

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TabBarView(controller: controller.tabController, children: [
      CardMainView(key: ValueKey<HomeView>(HomeView.Main)),
      ProfileView(key: ValueKey<HomeView>(HomeView.Profile)),
      ActivityView(key: ValueKey<HomeView>(HomeView.Activity)),
      RemoteView(key: ValueKey<HomeView>(HomeView.Remote)),
    ]));
  }
}

// ^ Home Tab Bar Navigation ^ //
class HomeBottomNavBar extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomBarClip(),
      child: Container(
        decoration: Neumorph.floating(),
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
