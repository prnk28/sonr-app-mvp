import 'package:sonr_app/style.dart';
import 'views/views.dart';
import 'register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: SonrTheme.boxDecoration,
      child: Obx(
        () => AnimatedSlideSwitcher.slideRight(
          child: _buildView(controller.status.value),
          duration: const Duration(milliseconds: 2500),
        ),
      ),
    );
  }

  Widget _buildView(RegisterStatus status) {
    // Return View
    if (status == RegisterStatus.Location) {
      return BoardingLocationView(key: ValueKey<RegisterStatus>(RegisterStatus.Location));
    } else if (status == RegisterStatus.Gallery) {
      return BoardingGalleryView(key: ValueKey<RegisterStatus>(RegisterStatus.Gallery));
    } else if (status == RegisterStatus.Contact) {
      return FormPage(key: ValueKey<RegisterStatus>(RegisterStatus.Contact));
    } else if (status == RegisterStatus.Backup) {
      return BackupCodeView(key: ValueKey<RegisterStatus>(RegisterStatus.Backup));
    } else {
      return NamePage(key: ValueKey<RegisterStatus>(RegisterStatus.Name));
    }
  }
}
