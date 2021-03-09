import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

class RegisterScreen extends GetView<RegisterController> {
  final hintName = SonrText.hintName();
  final lastNameFocus = FocusNode();
  final emailFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SonrScaffold.appBarTitle(
        title: "Sonr",
        body: Column(children: <Widget>[
          Form(
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
                    status: controller.firstNameStatus,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    autoFocus: true,
                    autoCorrect: false,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(lastNameFocus);
                      controller.firstName(controller.firstName.value.capitalizeFirst);
                      controller.firstName.refresh();
                    },
                    onChanged: (String value) {
                      controller.firstName(value);
                    }),

                // ***************** //
                // ** <Last Name> ** //
                // ***************** //
                SonrTextField(
                    label: "Last Name",
                    hint: hintName.item2,
                    textInputAction: TextInputAction.next,
                    value: controller.lastName.value,
                    textCapitalization: TextCapitalization.words,
                    focusNode: lastNameFocus,
                    status: controller.lastNameStatus,
                    autoCorrect: false,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(emailFocus);
                      controller.lastName(controller.lastName.value.capitalizeFirst);
                      controller.lastName.refresh();
                    },
                    onChanged: (String value) {
                      controller.lastName(value);
                    }),

                // ***************** //
                // ** <Email Address> ** //
                // ***************** //
                SonrTextField(
                    label: "Email Address",
                    hint: hintName.item2,
                    status: controller.emailStatus,
                    value: controller.lastName.value,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.words,
                    focusNode: emailFocus,
                    autoCorrect: false,
                    onEditingComplete: () {
                      FocusScopeNode currentFocus = FocusScope.of(Get.context);
                      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                        FocusManager.instance.primaryFocus.unfocus();
                        controller.submit();
                      }
                    },
                    onChanged: (String value) {
                      controller.email(value);
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
                        FocusScopeNode currentFocus = FocusScope.of(Get.context);
                        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                          FocusManager.instance.primaryFocus.unfocus();
                          controller.submit();
                        }
                      },
                      margin: EdgeInsets.only(top: 12),
                    ),
                  ),
                )
              ],
            ),
          )
        ]));
  }
}

class RegisterController extends GetxController {
  // Properties
  final firstName = "".obs;
  final lastName = "".obs;
  final email = "".obs;

  // Error Status
  final firstNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final lastNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final emailStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);

  // ^ Submits Contact ^ //
  submit() async {
    if (validate()) {
      // Get Contact from Values
      var contact = new Contact();
      contact.firstName = firstName.value;
      contact.lastName = lastName.value;
      contact.email = email.value;

      // Process data.
      await UserService.saveChanges(providedContact: contact, isNewUser: true);
      DeviceService.requestLocation().then((value) {
        if (value) {
          SonrService.connect();
          Get.offNamed("/home");
        }
      });
    }
  }

  // ^ Validates Fields ^ //
  bool validate() {
    // Check Valid
    bool firstNameValid = GetUtils.isAlphabetOnly(firstName.value);
    bool lastNameValid = GetUtils.isAlphabetOnly(lastName.value);
    bool emailValid = GetUtils.isEmail(email.value);

    // Update Reactive Properties
    firstNameStatus(TextInputValidStatusUtils.fromValidBool(firstNameValid));
    lastNameStatus(TextInputValidStatusUtils.fromValidBool(lastNameValid));
    emailStatus(TextInputValidStatusUtils.fromValidBool(emailValid));

    // Return Result
    return firstNameValid && lastNameValid && emailValid;
  }
}
