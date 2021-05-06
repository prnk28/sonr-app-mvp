import 'package:sonr_app/style/style.dart';

import 'window_controller.dart';

class LinkController extends GetxController {
  final firstName = "".obs;
  final lastName = "".obs;
  final firstNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final lastNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);

  // ^ Validates Fields ^ //
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

  // ^ Submits Contact ^ //
  setContact() async {
    if (validate()) {
      // Get Contact from Values
      var contact = Contact(profile: Profile(firstName: firstName.value, lastName: lastName.value));

      // Remove Textfield Focus
      FocusScopeNode currentFocus = FocusScope.of(Get.context!);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus!.unfocus();
      }

      // Process data.
      await UserService.newUser(contact, withSonrConnect: true);
      Get.find<WindowController>().changeView(DesktopView.Explorer);
    }
  }
}
