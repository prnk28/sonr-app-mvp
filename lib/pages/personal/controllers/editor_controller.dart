export '../views/editor/editor_view.dart';
export '../views/editor/design_editor.dart';
export '../views/editor/general_editor.dart';
export '../views/editor/social_editor.dart';
import 'package:sonr_app/style.dart';

import '../views/editor/editor_view.dart';
import 'package:sonr_app/pages/personal/personal.dart';

class EditorController extends GetxController {
  // Properties
  final status = EditorFieldStatus.Default.obs;
  final title = "Edit Contact".obs;
  final isDarkModeEnabled = Preferences.isDarkMode.obs;
  final isFlatModeEnabled = Preferences.flatModeEnabled.obs;
  final isPointToShareEnabled = Preferences.pointShareEnabled.obs;

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

  void shiftScreen(ContactOptions option) {
    HapticFeedback.heavyImpact();
    status(option.editorStatus);
    title(status.value.name);
  }

  void reset() {
    status(EditorFieldStatus.Default);
    title(status.value.name);
  }

  static void open() {
    Get.find<EditorController>().reset();
    Get.to(EditorView(), transition: Transition.upToDown, duration: 350.milliseconds);
  }
}
