import 'package:sonr_app/modules/share/index_view.dart';

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
        resizeToAvoidBottomInset: false,
        shareView: ShareView(),
        bottomNavigationBar: HomeBottomNavBar(),
        body: Obx(() => AnimatedSlideSwitcher(
              controller.getSwitcherAnimation(),
              _buildView(controller.page.value),
              const Duration(milliseconds: 2500),
            )));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(NavButtonType page) {
    // Return View
    if (page == NavButtonType.Profile) {
      return ProfileView(key: ValueKey<NavButtonType>(NavButtonType.Profile));
    } else if (page == NavButtonType.Alerts) {
      return AlertsView(key: ValueKey<NavButtonType>(NavButtonType.Alerts));
    } else if (page == NavButtonType.Remote) {
      return RemoteView(key: ValueKey<NavButtonType>(NavButtonType.Remote));
    } else {
      return CardGridView(key: ValueKey<NavButtonType>(NavButtonType.Grid), header: HomeTopHeaderBar());
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
      SonrText.normal("This Page is Under Construction.", color: SonrColor.Black.withOpacity(0.7), size: 18),
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}
