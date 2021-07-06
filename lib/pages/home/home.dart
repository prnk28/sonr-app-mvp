export 'controllers/home_controller.dart';
export 'controllers/intel_controller.dart';
export 'models/status.dart';

import 'package:sonr_app/pages/personal/personal.dart';
import 'controllers/home_controller.dart';
import 'package:sonr_app/style/style.dart';
import 'models/status.dart';
import 'views/dashboard_view.dart';
import 'package:sonr_app/pages/home/controllers/home_controller.dart';
import 'package:sonr_app/pages/home/models/status.dart';
import 'package:sonr_app/pages/personal/controllers/editor_controller.dart';
import 'package:showcaseview/showcaseview.dart';
import 'views/panels_view.dart';
import 'views/intel_view.dart';

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

class HomeAppBar extends GetView<HomeController> implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Obx(() => AnimatedOpacity(
          duration: 200.milliseconds,
          opacity: controller.appbarOpacity.value,
          child: AnimatedSlider.fade(
            duration: 2.seconds,
            child: PageAppBar(
                centerTitle: controller.view.value.isDefault,
                key: ValueKey(false),
                subtitle: Padding(
                  padding: controller.view.value.isDefault ? EdgeInsets.only(top: 24) : EdgeInsets.zero,
                  child: controller.view.value == HomeView.Dashboard
                      ? "Hi ${ContactService.contact.value.firstName.capitalizeFirst},".subheading(
                          color: Get.theme.focusColor.withOpacity(0.8),
                          align: TextAlign.start,
                        )
                      : Container(),
                ),
                action: HomeActionButton(
                  dashboardKey: controller.keyTwo,
                ),
                leading: controller.view.value != HomeView.Contact
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 24.0, left: 8),
                        child: Container(
                          child: Obx(() => ShowcaseItem.fromType(
                                type: ShowcaseType.Help,
                                child: ActionButton(
                                  banner: Logger.unreadIntercomCount.value > 0 ? ActionBanner.count(Logger.unreadIntercomCount.value) : null,
                                  key: ValueKey<HomeView>(HomeView.Dashboard),
                                  iconData: SonrIcons.Help,
                                  onPressed: () async => await Logger.openIntercom(),
                                ),
                              )),
                        ),
                      )
                    : null,
                title: IntelHeader()),
          ),
        ));
  }

  @override
  Size get preferredSize => Size(Get.width, kToolbarHeight + 64);
}

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
        padding: const EdgeInsets.only(bottom: 24.0, right: 8),
        child: ShowcaseItem.fromType(
          type: ShowcaseType.Alerts,
          child: ActionButton(
            key: ValueKey<HomeView>(HomeView.Dashboard),
            iconData: SonrIcons.Alerts,
            onPressed: () => AppPage.Activity.to(),
          ),
        ),
      );
    }
  }
}

/// @ Bottom Bar Button Widget
class HomeBottomTabButton extends GetView<HomeController> {
  final HomeView view;
  final void Function(int) onPressed;
  final void Function(int)? onLongPressed;
  final RxInt currentIndex;
  HomeBottomTabButton(this.view, this.onPressed, this.currentIndex, {this.onLongPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onPressed(view.index);
        },
        onLongPress: () {
          if (onLongPressed != null) {
            onLongPressed!(view.index);
          }
        },
        child: Container(
          padding: EdgeInsets.only(top: 8.0, bottom: 8, left: view == HomeView.Dashboard ? 16 : 8, right: view == HomeView.Contact ? 16 : 8),
          child: ObxValue<RxInt>(
              (idx) => AnimatedScale(
                    duration: 250.milliseconds,
                    child: Container(
                        key: ValueKey(idx.value == view.index),
                        child: idx.value == view.index
                            ? Icon(view.iconData(idx.value == view.index), size: view.iconSize, color: AppTheme.itemColor)
                            : Icon(view.iconData(idx.value == view.index), size: view.iconSize, color: AppTheme.itemColor)),
                    scale: idx.value == view.index ? 1.0 : 0.9,
                  ),
              currentIndex),
        ));
  }
}

/// @ Home Tab Bar Navigation
class HomeFloatingBar extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Container(
      child: Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
        Container(
          decoration: BoxDecoration(
            border: Get.isDarkMode ? null : Border.all(color: AppTheme.backgroundColor, width: 1),
            color: AppTheme.foregroundColor,
            borderRadius: BorderRadius.circular(28.13),
            boxShadow: AppTheme.boxShadow,
          ),
          margin: EdgeInsets.symmetric(horizontal: 72),
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(() => Bounce(
                  from: 12,
                  duration: 1000.milliseconds,
                  animate: controller.view.value == HomeView.Dashboard,
                  key: ValueKey(controller.view.value == HomeView.Dashboard),
                  child: ShowcaseItem.fromType(
                      type: ShowcaseType.Dashboard,
                      child: HomeBottomTabButton(HomeView.Dashboard, controller.setBottomIndex, controller.bottomIndex)))),
              Container(
                width: Get.width * 0.20,
              ),
              Obx(() => Roulette(
                    spins: 1,
                    key: ValueKey(controller.view.value == HomeView.Contact),
                    animate: controller.view.value == HomeView.Contact,
                    child: ShowcaseItem.fromType(
                        type: ShowcaseType.Personal, child: HomeBottomTabButton(HomeView.Contact, controller.setBottomIndex, controller.bottomIndex)),
                  )),
            ],
          ),
        ),
        ShowcaseItem.fromType(
          type: ShowcaseType.ShareStart,
          child: ShareButton(),
        ),
      ]),
    );
  }
}
