import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:sonr_app/theme/theme.dart';

enum RegisterStatus { Form, Location, Gallery }

class RegisterController extends GetxController {
  // Properties
  final firstName = "".obs;
  final lastName = "".obs;
  final status = Rx<RegisterStatus>(RegisterStatus.Form);

  // Error Status
  final firstNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final lastNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final emailStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);

  // * Constructer * //
  onInit() {
    super.onInit();
  }

  // ^ Submits Contact ^ //
  setContact() async {
    if (validate()) {
      // Get Contact from Values
      var contact = Contact(firstName: firstName.value, lastName: lastName.value);

      // Remove Textfield Focus
      FocusScopeNode currentFocus = FocusScope.of(Get.context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus.unfocus();
      }

      // Process data.
      await UserService.newUser(contact);
      status(RegisterStatus.Location);
    }
  }

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

  // ^ Request Location Permissions ^ //
  Future<bool> requestLocation() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      UserService.permissions.value.update();
      UserService.permissions.refresh();
      status(RegisterStatus.Gallery);
      return true;
    } else {
      UserService.permissions.value.update();
      UserService.permissions.refresh();
      return false;
    }
  }

  // ^ Request Gallery Permissions ^ //
  Future<bool> requestGallery() async {
    if (DeviceService.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        UserService.permissions.value.update();
        UserService.permissions.refresh();
        await Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
        return true;
      } else {
        UserService.permissions.value.update();
        UserService.permissions.refresh();
        return false;
      }
    } else {
      if (await Permission.photos.request().isGranted) {
        UserService.permissions.value.update();
        UserService.permissions.refresh();
        await Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
        return true;
      } else {
        UserService.permissions.value.update();
        UserService.permissions.refresh();
        return false;
      }
    }
  }
}
