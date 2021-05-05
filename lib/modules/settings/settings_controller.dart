import 'package:sonr_app/style/style.dart';

class SettingsController extends GetxController {
  final isDarkModeEnabled = UserService.isDarkMode.obs;
  final isFlatModeEnabled = UserService.flatModeEnabled.obs;
  final isPointToShareEnabled = UserService.pointShareEnabled.obs;

  setDarkMode(bool val) {
    isDarkModeEnabled(val);
    UserService.toggleDarkMode();
  }

  setFlatMode(bool val) {
    isFlatModeEnabled(val);
    UserService.toggleFlatMode();
  }

  setPointShare(bool val) {
    if (val) {
      // Overlay Prompt
      SonrOverlay.question(
              barrierDismissible: false,
              title: "Wait!",
              description: "Point To Share is still experimental, performance may not be stable. \n Do you still want to continue?",
              acceptTitle: "Continue",
              declineTitle: "Cancel")
          .then((value) {
        // Check Result
        if (value) {
          isPointToShareEnabled(true);
          UserService.togglePointToShare();
        } else {
          Get.back();
        }
      });
    } else {
      UserService.togglePointToShare();
    }
  }
}
