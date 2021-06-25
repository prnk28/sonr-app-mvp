import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/pages/home/models/status.dart';
import 'package:sonr_app/pages/personal/controllers/editor_controller.dart';

import 'package:sonr_app/style.dart';

class HomeAppBar extends GetView<HomeController> implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedOpacity(
          duration: 200.milliseconds,
          opacity: controller.appbarOpacity.value,
          child: AnimatedSlider.fade(
            duration: 2.seconds,
            child: PageAppBar(
              centerTitle: controller.view.value.isDefault,
              key: ValueKey(false),
              subtitle: Padding(
                padding: controller.view.value.isDefault ? EdgeInsets.only(top: 42) : EdgeInsets.zero,
                child: controller.view.value == HomeView.Dashboard
                    ? "Hi ${ContactService.contact.value.firstName},".subheading(
                        color: Get.theme.focusColor.withOpacity(0.8),
                        align: TextAlign.start,
                      )
                    : Container(),
              ),
              action: HomeActionButton(),
              // leading: controller.view.value != HomeView.Contact ? _buildHomeLeading() : null,
              title: controller.title.value.heading(
                color: Get.theme.focusColor,
                align: TextAlign.start,
              ),
            ),
          ),
        ));
  }

  /// TODO: Implement Intercom Button
  Widget buildHomeLeading() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0, left: 8),
      child: Container(
        child: ActionButton(
          key: ValueKey<HomeView>(HomeView.Dashboard),
          iconData: SonrIcons.Help,
          onPressed: () async => await HelpService.openIntercom(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, kToolbarHeight + 64);
}

class HomeActionButton extends GetView<HomeController> {
  HomeActionButton();

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSlider.fade(
          child: _buildView(controller.view.value),
          duration: const Duration(milliseconds: 2500),
        ));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(HomeView page) {
    // Return View
    if (page == HomeView.Contact) {
      return ActionButton(
        key: ValueKey<HomeView>(HomeView.Contact),
        iconData: SonrIcons.Settings,
        onPressed: () {
          HapticFeedback.heavyImpact();
          EditorController.open();
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 32.0, right: 8),
        child: ActionButton(
          key: ValueKey<HomeView>(HomeView.Dashboard),
          iconData: SonrIcons.Alerts,
          onPressed: () => AppPage.Activity.to(),
        ),
      );
    }
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
