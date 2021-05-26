import 'package:sonr_app/modules/settings/sheet_view.dart';
import 'package:sonr_app/pages/home/views/dashboard/activity_view.dart';
import 'package:sonr_app/style/style.dart';
import '../home_controller.dart';

class HomeActionButton extends GetView<HomeController> {
  HomeActionButton();

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
    if (page == HomeView.Contact) {
      return ActionButton(
        key: ValueKey<HomeView>(HomeView.Contact),
        icon: SonrIcons.Settings.gradient(size: 28),
        onPressed: () {
          Get.bottomSheet(SettingsSheet());
        },
      );
    } else {
      return ActionButton(
        key: ValueKey<HomeView>(HomeView.Dashboard),
        icon: SonrIcons.Alerts.gradient(size: 28),
        onPressed: () {
          Get.to(ActivityPopup(), transition: Transition.downToUp);
        },
      );
    }
  }
}
