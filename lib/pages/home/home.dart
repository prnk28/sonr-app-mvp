export 'controllers/home_controller.dart';
export 'controllers/intel_controller.dart';
export 'controllers/status.dart';
export 'widgets/bottom_bar.dart';
export 'widgets/bottom_button.dart';
export 'widgets/top_button.dart';
export 'widgets/top_header.dart';

import 'package:sonr_app/pages/personal/personal.dart';
import 'controllers/home_controller.dart';
import 'package:sonr_app/style/style.dart';
import 'controllers/status.dart';
import 'views/dashboard_view.dart';
import 'package:sonr_app/pages/home/controllers/home_controller.dart';
import 'package:sonr_app/pages/home/controllers/status.dart';
import 'package:showcaseview/showcaseview.dart';
import 'views/panels_view.dart';
import 'widgets/bottom_bar.dart';
import 'widgets/top_header.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (AppPage.Home.needsOnboarding) {
      WidgetsBinding.instance!.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context)!.startShowCase(AppPage.Home.onboardingItems),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    // Return View
    return Obx(() => SonrScaffold(
          resizeToAvoidBottomInset: false,
          floatingAction: HomeFloatingBar(),
          appBar: _buildAppBar(controller.view.value),
          body: Container(
              child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller.tabController,
            children: [
              DashboardView(key: ValueKey<HomeView>(HomeView.Dashboard)),
              PersonalView(key: ValueKey<HomeView>(HomeView.Contact)),
            ],
          )),
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
      backgroundColor: AppTheme.BackgroundColor,
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
