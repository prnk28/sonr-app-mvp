import 'package:sonr_app/pages/home/home.dart';
import 'package:sonr_app/style/style.dart';

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
                            ? Icon(view.iconData(idx.value == view.index), size: view.iconSize, color: AppTheme.ItemColor)
                            : Icon(view.iconData(idx.value == view.index), size: view.iconSize, color: AppTheme.ItemColor)),
                    scale: idx.value == view.index ? 1.0 : 0.9,
                  ),
              currentIndex),
        ));
  }
}
