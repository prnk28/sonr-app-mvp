export 'editor_view.dart';
export 'design_editor.dart';
export 'general_editor.dart';
export 'social_editor.dart';

import 'package:sonr_app/style.dart';

import 'editor_view.dart';

enum EditorFieldStatus {
  Default,
  FieldName,
  FieldGender,
  FieldPhone,
  FieldAddresses,
}

extension EditorFieldStatusUtils on EditorFieldStatus {
  String get name {
    switch (this) {
      case EditorFieldStatus.Default:
        return "Settings";
      case EditorFieldStatus.FieldName:
        return "Names";
      case EditorFieldStatus.FieldGender:
        return "Gender";
      case EditorFieldStatus.FieldPhone:
        return "Phones";
      case EditorFieldStatus.FieldAddresses:
        return "Addresses";
    }
  }

  bool get isMainView => this == EditorFieldStatus.Default;
  bool get isNotMainView => this != EditorFieldStatus.Default;

  IconData get leadingIcon => this.isMainView ? SonrIcons.Close : SonrIcons.Backward;
}

class EditorController extends GetxController {
  // Properties
  final status = EditorFieldStatus.Default.obs;
  final title = "Edit Contact".obs;
  final isDarkModeEnabled = UserService.isDarkMode.obs;
  final isFlatModeEnabled = UserService.flatModeEnabled.obs;
  final isPointToShareEnabled = UserService.pointShareEnabled.obs;

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
    UserService.toggleDarkMode();
  }

  setFlatMode(bool val) {
    isFlatModeEnabled(val);
    UserService.toggleFlatMode();
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
          UserService.togglePointToShare();
        } else {
          Get.back();
        }
      });
    } else {
      UserService.togglePointToShare();
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
