import 'package:get/get.dart';
import 'package:sonar_app/service/device_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

class RegisterController extends GetxController {
  final firstName = "".obs;
  final lastName = "".obs;

  submit() {
    if (_validate()) {
      // Get Contact from Values
      var contact = new Contact();
      contact.firstName = firstName.value;
      contact.lastName = lastName.value;

      // Process data.
      Get.find<DeviceService>().createUser(contact, "@Temp_Username");
      FocusScope.of(Get.context).unfocus();
      Get.offNamed("/home");
    } else {
      SonrSnack.error("Some fields are not correct");
    }
  }

  _validate() {
    return GetUtils.isAlphabetOnly(firstName.value) &&
        GetUtils.isAlphabetOnly(lastName.value);
  }
}
