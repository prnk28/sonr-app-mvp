import 'package:sonr_app/pages/home/home.dart';
import 'package:sonr_app/style/style.dart';

class HomeActionButton extends GetView<HomeController> {
  final GlobalKey<State<StatefulWidget>> dashboardKey;
  HomeActionButton({required this.dashboardKey});

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
    if (page == HomeView.Personal) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 42.0, right: 8),
        child: ActionButton(
          key: ValueKey<HomeView>(HomeView.Personal),
          iconData: SimpleIcons.Settings,
          onPressed: () {
            HapticFeedback.heavyImpact();
            AppPage.Settings.to();
          },
        ),
      );
    } else {
      return ShowcaseItem.fromType(
        type: ShowcaseType.Alerts,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 108.0, right: 8),
          child: ActionButton(
            key: ValueKey<HomeView>(HomeView.Dashboard),
            iconData: SimpleIcons.Alerts,
            onPressed: () => AppPage.Activity.to(),
          ),
        ),
      );
    }
  }
}
