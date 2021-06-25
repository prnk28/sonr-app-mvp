import 'package:sonr_app/pages/personal/personal.dart';
import 'home_controller.dart';
import 'package:sonr_app/style.dart';
import 'models/status.dart';
import 'views/dashboard_view.dart';
import 'widgets/navigation.dart';
import 'widgets/panels.dart';
class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => SonrScaffold(
          resizeToAvoidBottomInset: false,
          floatingAction: HomeFloatingBar(),
          appBar: _buildAppBar(controller.view.value),
          body: Container(
              child: TabBarView(controller: controller.tabController, children: [
            DashboardView(key: ValueKey<HomeView>(HomeView.Dashboard)),
            PersonalView(key: ValueKey<HomeView>(HomeView.Contact)),
          ])),
        ));
  }

  PreferredSizeWidget? _buildAppBar(HomeView view) {
    if (view == HomeView.Search) {
      return null;
    } else {
      return HomeAppBar();
    }
  }
}

class ExplorerPage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(title: "Welcome".heading()),
      backgroundColor: AppTheme.backgroundColor,
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
