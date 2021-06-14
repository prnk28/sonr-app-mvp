import 'package:sonr_app/pages/home/views/contact/editor/editor_controller.dart';
import 'package:sonr_app/style.dart';
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
