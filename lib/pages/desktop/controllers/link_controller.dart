import 'package:sonr_app/style/style.dart';

import 'window_controller.dart';

class LinkController extends GetxController {
  final firstName = "".obs;
  final lastName = "".obs;
  final firstNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final lastNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);

  /// @ Validates Fields
  bool validate() {
    // Check Valid
    bool firstNameValid = GetUtils.isAlphabetOnly(firstName.value);
    bool lastNameValid = GetUtils.isAlphabetOnly(lastName.value);

    // Update Reactive Properties
    firstNameStatus(TextInputValidStatusUtils.fromValidBool(firstNameValid));
    lastNameStatus(TextInputValidStatusUtils.fromValidBool(lastNameValid));

    // Return Result
    return firstNameValid && lastNameValid;
  }

  /// @ Submits Contact
  setContact() async {
    if (validate()) {
      // Remove Textfield Focus
      FocusScopeNode currentFocus = FocusScope.of(Get.context!);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus!.unfocus();
      }

      // Save User
      await UserService.newUser(Contact(profile: Profile(firstName: this.firstName.value, lastName: this.lastName.value)));

      // Process data.
      SonrService.to.connect();
      Get.find<WindowController>().changeView(DesktopView.Explorer);
    }
  }
}
