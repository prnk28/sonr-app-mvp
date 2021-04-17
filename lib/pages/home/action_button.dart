import 'package:sonr_app/theme/theme.dart';
import 'home_controller.dart';

class HomeActionButton extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSlideSwitcher.fade(
          child: _buildView(controller.view.value),
          duration: const Duration(milliseconds: 2500),
        ));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(HomeView page) {
    // Return View
    if (page == HomeView.Profile) {
      return Container(width: 56, height: 56, key: ValueKey<HomeView>(HomeView.Profile));
    } else if (page == HomeView.Activity) {
      return Container(width: 56, height: 56, key: ValueKey<HomeView>(HomeView.Activity));
    } else if (page == HomeView.Remote) {
      return Container(width: 56, height: 56, key: ValueKey<HomeView>(HomeView.Remote));
    } else {
      return ActionButton(
        key: ValueKey<HomeView>(HomeView.Main),
        icon: SonrIcons.Category.gradient(size: 28),
        onPressed: () => print("Action"),
      );
    }
  }
}
