import 'package:sonr_app/theme/theme.dart';
import 'boarding_view.dart';
import 'form_page.dart';
import 'register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          width: Get.width,
          height: Get.height,
          child: Neumorphic(
            style: SonrStyle.normal,
            child: AnimatedSlideSwitcher.slideRight(
              child: _buildView(controller.status.value),
              duration: const Duration(milliseconds: 2500),
            ),
          ),
        ));
  }

  _buildView(RegisterStatus status) {
    // Return View
    if (status == RegisterStatus.Location) {
      return BoardingLocationView(key: ValueKey<RegisterStatus>(RegisterStatus.Location));
    } else if (status == RegisterStatus.Gallery) {
      return BoardingGalleryView(key: ValueKey<RegisterStatus>(RegisterStatus.Gallery));
    } else if (status == RegisterStatus.Complete) {
      return CompleteView(key: ValueKey<RegisterStatus>(RegisterStatus.Complete));
    } else {
      return FormPage(key: ValueKey<RegisterStatus>(RegisterStatus.Form));
    }
  }
}
