import 'package:sonr_app/modules/share/button_view.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/style.dart';
import 'views/dashboard/dashboard_view.dart';
import 'home_controller.dart';
import 'views/contact/profile_view.dart';
import 'widgets/app_bar.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
      resizeToAvoidBottomInset: false,
      floatingAction: HomeFloatingBar(),
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
class HomeFloatingBar extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36.0),
      child: Container(
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
          padding: EdgeInsets.only(top: 8.0, bottom: 8, left: view == HomeView.Dashboard ? 16 : 8, right: view == HomeView.Contact ? 16 : 8),
          child: ObxValue<RxInt>(
              (idx) => AnimatedScale(
                    duration: 250.milliseconds,
                    child: Container(
                        key: ValueKey(idx.value == view.index),
                        child: idx.value == view.index
                            ? Icon(view.iconData(idx.value == view.index), size: view.iconSize, color: SonrTheme.itemColor)
                            : Icon(view.iconData(idx.value == view.index), size: view.iconSize, color: SonrTheme.itemColor)),
                    scale: idx.value == view.index ? 1.0 : 0.9,
                  ),
              currentIndex),
        ));
  }
}
