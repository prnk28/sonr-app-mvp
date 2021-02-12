import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

class RegisterScreen extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold.appBarTitle(
        title: "Sonr",
        body: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // ****************** //
                    // ** <First Name> ** //
                    // ****************** //
                    SonrTextField(
                        label: "First Name",
                        hint: "Enter your first name",
                        value: controller.firstName.value,
                        textCapitalization: TextCapitalization.words,
                        autoFocus: true,
                        onChanged: (String value) {
                          controller.firstName(value);
                        }),

                    // ***************** //
                    // ** <Last Name> ** //
                    // ***************** //
                    SonrTextField(
                        label: "Last Name",
                        hint: "Enter your last name",
                        value: controller.lastName.value,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (String value) {
                          controller.lastName(value);
                        }),

                    // ********************* //
                    // ** <Submit Button> ** //
                    // ********************* //
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: SonrButton.rectangle(
                          text: SonrText.normal("Submit"),
                          onPressed: () {
                            controller.submit();
                          },
                          margin: EdgeInsets.only(top: 12),
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ]));
  }
}

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
    return GetUtils.isAlphabetOnly(firstName.value) && GetUtils.isAlphabetOnly(lastName.value);
  }
}
