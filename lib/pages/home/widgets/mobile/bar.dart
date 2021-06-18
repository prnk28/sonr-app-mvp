import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/style.dart';
import 'button.dart';
import 'mobile.dart';

class HomeAppBar extends GetView<HomeController> implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSlideSwitcher.fade(
          duration: 2.seconds,
          child: PageAppBar(
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
          child: controller.title.value.heading(
            color: Get.theme.focusColor,
            align: TextAlign.start,
          ),
        ));
  }
}

class _HomeAppBarSubtitle extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.view.value == HomeView.Dashboard
        ? "Hi ${UserService.contact.value.firstName},".subheading(
            color: Get.theme.focusColor.withOpacity(0.8),
            align: TextAlign.start,
          )
        : Container());
  }
}
