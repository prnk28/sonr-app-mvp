import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/register/register_controller.dart';
import 'package:sonar_app/theme/theme.dart';

class RegisterForm extends GetView<RegisterController> {
  RegisterForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
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
                SonrText.normal("Submit"),
                () {
                  controller.submit();
                },
                margin: EdgeInsets.only(top: 12),
              ),
            ),
          )
        ],
      ),
    );
  }
}
