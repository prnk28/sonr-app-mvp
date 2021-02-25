import 'package:sonr_app/data/constants.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

class RegisterScreen extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    var hintName = SonrText.hintName();
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
                        hint: hintName.item1,
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
                        hint: hintName.item2,
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
                          text: SonrText.medium("Submit"),
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

  submit() async {
    if (_validate()) {
      // Get Contact from Values
      var contact = new Contact();
      contact.firstName = firstName.value;
      contact.lastName = lastName.value;

      // Process data.
      await UserService.saveChanges(providedContact: contact);
      FocusScope.of(Get.context).unfocus();
      DeviceService.requestLocation().then((value) {
        if (value) {
          Get.offNamed("/home");
        }
      });
    } else {
      SonrSnack.error("Some fields are not correct");
    }
  }

  _validate() {
    return GetUtils.isAlphabetOnly(firstName.value) && GetUtils.isAlphabetOnly(lastName.value);
  }
}
