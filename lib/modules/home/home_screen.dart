import 'package:sonr_app/modules/card/card_grid.dart';
import 'package:sonr_app/theme/navigation/app_bar.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'bottom_bar.dart';
import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
        appBar: SonrAppBar(
          title: "Home",
        ),
        bottomNavigationBar: HomeBottomNavBar(),
        body: Obx(() => AnimatedSlideSwitcher(controller.getSwitcherAnimation(), _buildView(controller.page.value), const Duration(seconds: 3))));
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
      return CardGridView(key: ValueKey<BottomNavButton>(BottomNavButton.Grid));
    }
  }
}

// ^ Profile View ^ //
class ProfileView extends GetView<HomeController> {
  ProfileView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      SonrText.header("Profile View"),
      SonrText.normal("Share to begin viewing your Cards!", color: SonrColor.Black.withOpacity(0.7), size: 18),
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}

// ^ Remote View ^ //
class RemoteView extends GetView<HomeController> {
  RemoteView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      SonrText.header("Remote View"),
      SonrText.normal("Share to begin viewing your Cards!", color: SonrColor.Black.withOpacity(0.7), size: 18),
      Padding(padding: EdgeInsets.all(16)),
    ]);
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
