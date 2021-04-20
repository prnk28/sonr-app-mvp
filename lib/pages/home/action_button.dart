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
      return ActionButton(
        key: ValueKey<HomeView>(HomeView.Main),
        icon: SonrIcons.Edit.gradient(size: 28),
        onPressed: () => print("Action: Edit Profile"),
      );
    } else if (page == HomeView.Activity) {
      return ActionButton(
        key: ValueKey<HomeView>(HomeView.Main),
        icon: SonrIcons.Check_All.gradient(size: 28),
        onPressed: () => print("Action: Clear Notifications"),
      );
    } else if (page == HomeView.Remote) {
      return ActionButton(
        key: ValueKey<HomeView>(HomeView.Main),
        icon: SonrIcons.Plus.gradient(size: 28),
        onPressed: () => print("Action: Create Remote"),
      );
    } else {
      return ActionButton(
        key: ValueKey<HomeView>(HomeView.Main),
        icon: SonrIcons.Category.gradient(size: 28),
        onPressed: () => print("Action: Dashboard"),
      );
    }
  }
}
