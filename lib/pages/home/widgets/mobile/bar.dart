import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/style.dart';
import 'button.dart';
import 'mobile.dart';

class HomeAppBar extends GetView<HomeController> implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSlider.fade(
          duration: 2.seconds,
          child: PageAppBar(
            centerTitle: controller.view.value.isDefault,
            key: ValueKey(false),
            subtitle: Padding(
              padding: controller.view.value.isDefault ? EdgeInsets.only(top: 42) : EdgeInsets.zero,
              child: controller.view.value == HomeView.Dashboard
                  ? "Hi ${ContactService.contact.value.firstName},".subheading(
                      color: Get.theme.focusColor.withOpacity(0.8),
                      align: TextAlign.start,
                    )
                  : Container(),
            ),
            action: HomeActionButton(),
            title: controller.title.value.heading(
              color: Get.theme.focusColor,
              align: TextAlign.start,
            ),
          ),
        ));
  }

  @override
  Size get preferredSize => Size(Get.width, kToolbarHeight + 64);
}
