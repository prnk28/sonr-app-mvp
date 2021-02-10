import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/register/register_controller.dart';
import 'package:sonr_app/theme/theme.dart';

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
                        textCapitalization: TextCapitalization.characters,
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
                        textCapitalization: TextCapitalization.characters,
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
