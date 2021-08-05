import 'package:sonr_app/pages/personal/personal.dart';
import 'package:sonr_app/pages/settings/views/device_view.dart';
import 'package:sonr_app/style/style.dart';

class SettingsController extends GetxController {
  // Properties
  final status = EditorFieldStatus.Default.obs;
  final title = "Edit Contact".obs;
  final isDarkModeEnabled = Preferences.isDarkMode.obs;
  final isFlatModeEnabled = Preferences.flatModeEnabled.obs;
  final isPointToShareEnabled = Preferences.pointShareEnabled.obs;
  final linkers = Linkers().obs;

  void handleLeading() {
    HapticFeedback.heavyImpact();
    if (status.value != EditorFieldStatus.Default) {
      status(EditorFieldStatus.Default);
      title(status.value.name);
    } else {
      reset();
      Get.back();
    }
  }

  setDarkMode(bool val) {
    isDarkModeEnabled(val);
    Preferences.toggleDarkMode();
  }

  setFlatMode(bool val) {
    isFlatModeEnabled(val);
    Preferences.toggleFlatMode();
  }

  setPointShare(bool val) {
    if (val) {
      // Overlay Prompt
      AppRoute.question(
              dismissible: false,
              title: "Wait!",
              description: "Point To Share is still experimental, performance may not be stable. \n Do you still want to continue?",
              acceptTitle: "Continue",
              declineTitle: "Cancel")
          .then((value) {
        // Check Result
        if (value) {
          isPointToShareEnabled(true);
          Preferences.togglePointToShare();
        } else {
          Get.back();
        }
      });
    } else {
      Preferences.togglePointToShare();
    }
  }

  void shiftScreen(UserOptions option) async {
    HapticFeedback.heavyImpact();
    if (option == UserOptions.Devices) {
      final data = await NodeService.instance.listLinkers();
      if (data != null) {
        linkers(data);
      }
      Get.to(DevicesView());
    } else {
      status(option.editorStatus);
      title(status.value.name);
    }
  }

  void reset() {
    status(EditorFieldStatus.Default);
    title(status.value.name);
  }
}
