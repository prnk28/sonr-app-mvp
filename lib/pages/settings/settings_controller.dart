import 'dart:async';

import 'package:pin_code_fields/pin_code_fields.dart';
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

  // Linker View Properties
  final formKey = GlobalKey<FormState>();
  final hasError = false.obs;
  final currentText = "".obs;

  // Controllers
  late StreamController<ErrorAnimationType> errorController;
  late TextEditingController textEditingController;

  // Initialization
  @override
  void onInit() {
    errorController = StreamController<ErrorAnimationType>();
    textEditingController = TextEditingController();
    super.onInit();
  }

  // Disposal
  @override
  void onClose() {
    errorController.close();
    super.onClose();
  }

  /// ### Clears current text input
  void clearTextInput() {
    textEditingController.clear();
  }

  /// ### Displays Snackbar with Message
  void displaySnackbar(String message) {
    AppRoute.snack(SnackArgs.success(message));
  }

  /// #### Handles OnCompleted Input
  void onLinkInputCompleted(String s) {
    print("Completed: " + s);
  }

  /// #### Handles OnChanged Input
  void onLinkInputChanged(String s) {
    currentText(s);
  }

  /// #### Handles Verify Button Press
  void onVerifyPressed() {}

  
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
      linkers(await NodeService.instance.listLinkers());
      print(linkers.value.list);
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
