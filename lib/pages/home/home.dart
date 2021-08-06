export 'controllers/home_controller.dart';
export 'controllers/intel_controller.dart';
export 'controllers/view.dart';
export 'widgets/bottom_bar.dart';
export 'widgets/top_button.dart';
export 'widgets/top_header.dart';

import 'package:sonr_app/pages/personal/personal.dart';
import 'controllers/home_controller.dart';
import 'package:sonr_app/style/style.dart';
import 'controllers/view.dart';
import 'views/dashboard_view.dart';
import 'package:sonr_app/pages/home/controllers/home_controller.dart';
import 'package:sonr_app/pages/home/controllers/view.dart';
import 'package:showcaseview/showcaseview.dart';
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
              PersonalView(key: ValueKey<HomeView>(HomeView.Personal)),
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
