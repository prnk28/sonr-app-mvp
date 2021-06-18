import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/pages/home/models/home_status.dart';
import 'package:sonr_app/pages/personal/controllers/editor_controller.dart';

import 'package:sonr_app/style.dart';

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
