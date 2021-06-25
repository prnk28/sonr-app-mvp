// Exports
export 'register_controller.dart';
export 'widgets/panel.dart';
export 'models/field.dart';
export 'models/intro.dart';
export 'models/status.dart';
export 'models/type.dart';

// Imports
import 'package:sonr_app/pages/register/views/perm_view.dart';
import 'package:sonr_app/pages/register/views/start_view.dart';
import 'package:sonr_app/style.dart';
import 'models/type.dart';
import 'register_controller.dart';
import 'views/setup_view.dart';

class RegisterPage extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Obx(
        () => AnimatedSlider.slideRight(
          child: _buildView(controller.status.value),
          duration: const Duration(milliseconds: 2500),
        ),
      ),
    );
  }

  Widget _buildView(RegisterPageType status) {
    // Return View
    if (status.isPermissions) {
      return PermissionsView();
    } else if (status.isSetup) {
      return SetupView();
    } else {
      return StartView(key: RegisterPageType.Intro.key);
    }
  }
}
