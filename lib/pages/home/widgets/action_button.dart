import 'package:sonr_app/modules/settings/sheet_view.dart';
import 'package:sonr_app/pages/home/views/details/popups/activity_view.dart';
import 'package:sonr_app/style/style.dart';
import '../home_controller.dart';
import '../views/remote/remote_controller.dart';

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
    } else if (page == HomeView.Remote) {
      return _RemoteActionButton();
    } else {
      return ActionButton(
        key: ValueKey<HomeView>(HomeView.Dashboard),
        icon: SonrIcons.Alerts.gradient(size: 28),
        onPressed: () {
          Get.dialog(ActivityPopup());
        },
      );
    }
  }
}

/// @ Profile Action Button Widget
class _RemoteActionButton extends GetView<RemoteController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => ActionButton(
          key: ValueKey<HomeView>(HomeView.Dashboard),
          icon: _buildIcon(controller.status.value),
          onPressed: () {
            // Creates New Lobby
            if (controller.status.value.isDefault) {
              controller.create();
            }

            // Destroys Created Lobby
            else if (controller.status.value.isCreated) {
              controller.stop();
            }

            // Exits Lobby
            else if (controller.status.value.isJoined) {
              controller.leave();
            }
          },
        ));
  }

  // @ Builds Icon by Status
  Widget _buildIcon(RemoteViewStatus status) {
    switch (status) {
      case RemoteViewStatus.Created:
        return SonrIcons.Logout.gradient(value: SonrGradient.Critical, size: 28);

      case RemoteViewStatus.Joined:
        return SonrIcons.Logout.gradient(value: SonrGradient.Critical, size: 28);

      default:
        return SonrIcons.Plus.gradient(size: 28);
    }
  }
}
