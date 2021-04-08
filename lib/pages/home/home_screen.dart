import 'grid_view.dart';
import 'package:sonr_app/pages/home/top_header.dart';
import 'package:sonr_app/modules/profile/profile_view.dart';
import 'package:sonr_app/modules/remote/remote_view.dart';
import 'package:sonr_app/theme/theme.dart';
import 'bottom_bar.dart';
import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
        bottomNavigationBar: HomeBottomNavBar(),
        body: Obx(() => AnimatedSlideSwitcher(
              controller.getSwitcherAnimation(),
              _buildView(controller.page.value),
              const Duration(milliseconds: 2500),
            )));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(BottomNavButton page) {
    // Return View
    if (page == BottomNavButton.Profile) {
      return ProfileView(key: ValueKey<BottomNavButton>(BottomNavButton.Profile));
    } else if (page == BottomNavButton.Alerts) {
      return AlertsView(key: ValueKey<BottomNavButton>(BottomNavButton.Alerts));
    } else if (page == BottomNavButton.Remote) {
      return RemoteView(key: ValueKey<BottomNavButton>(BottomNavButton.Remote));
    } else {
      return CardGridView(key: ValueKey<BottomNavButton>(BottomNavButton.Grid), header: HomeTopHeaderBar());
    }
  }
}

// ^ Alerts View ^ //
class AlertsView extends GetView<HomeController> {
  AlertsView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      SonrText.header("Alerts View"),
      SonrText.normal("Share to begin viewing your Cards!", color: SonrColor.Black.withOpacity(0.7), size: 18),
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}
