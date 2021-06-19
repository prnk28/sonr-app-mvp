import 'package:sonr_app/pages/personal/personal.dart';
import 'home_controller.dart';
import 'widgets/desktop/desktop.dart';
import 'package:sonr_app/style.dart';
import 'models/home_status.dart';
import 'views/dashboard_view.dart';
import 'widgets/mobile/mobile.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
      resizeToAvoidBottomInset: false,
      floatingAction: HomeFloatingBar(),
      appBar: HomeAppBar(),
      body: Container(
          child: TabBarView(controller: controller.tabController, children: [
        DashboardView(key: ValueKey<HomeView>(HomeView.Dashboard)),
        PersonalView(key: ValueKey<HomeView>(HomeView.Contact)),
      ])),
    );
  }
}

class ExplorerPage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(title: "Welcome".heading()),
      backgroundColor: SonrTheme.backgroundColor,
      body: Center(
        child: Container(
          width: 1280,
          height: 800,
          child: Row(children: [
            Container(
              padding: EdgeInsets.all(24),
              width: 1280 / 3 * 2,
              child: AccessView(),
            ),
            Container(
              padding: EdgeInsets.all(24),
              width: 1280 / 3,
              child: NearbyListView(),
            ),
          ]),
        ),
      ),
    );
  }
}
