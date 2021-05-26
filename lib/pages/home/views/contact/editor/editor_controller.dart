export 'editor_view.dart';
export 'design_editor.dart';
export 'general_editor.dart';
export 'social_editor.dart';

import 'package:sonr_app/style/style.dart';

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
        return "Edit Contact";
      case EditorFieldStatus.FieldName:
        return "Editing Name";
      case EditorFieldStatus.FieldGender:
        return "Editing Gender";
      case EditorFieldStatus.FieldPhone:
        return "Editing Phone";
      case EditorFieldStatus.FieldAddresses:
        return "Edditiing Address";
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
