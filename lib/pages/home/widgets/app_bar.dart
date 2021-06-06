import 'package:sonr_app/style/style.dart';
import 'action_button.dart';
import '../home_controller.dart';

class HomeAppBar extends GetView<HomeController> implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSlideSwitcher.fade(
          duration: 2.seconds,
          child: DesignAppBar(
            centerTitle: controller.view.value.isMain,
            key: ValueKey(false),
            subtitle: Padding(
              padding: controller.view.value.isMain ? EdgeInsets.only(top: 42) : EdgeInsets.zero,
              child: _HomeAppBarSubtitle(),
            ),
            action: HomeActionButton(),
            title: _HomeAppBarTitle(),
          ),
        ));
  }

  @override
  Size get preferredSize => Size(Get.width, kToolbarHeight + 64);
}

class _HomeAppBarTitle extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSlideSwitcher.fade(
          duration: 2.seconds,
          child: GestureDetector(
            key: ValueKey<String>(controller.title.value),
            onTap: controller.onTitleTap,
            onLongPress: () => BetterFeedback.of(context)?.show(UserService.sendFeedback),
            child: controller.title.value.heading(
              color: Get.theme.focusColor,
              align: TextAlign.start,
            ),
          ),
        ));
  }
}

class _HomeAppBarSubtitle extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.view.value == HomeView.Dashboard
        ? "Hi ${UserService.contact.value.firstName},".heading(
            color: Get.theme.focusColor,
            align: TextAlign.start,
          )
        : Container());
  }
}
