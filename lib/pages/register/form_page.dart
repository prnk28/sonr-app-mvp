import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

class FormPage extends StatelessWidget {
  final hintName = SonrTextField.hintName();
  final lastNameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GetX<_FormPageController>(
      init: _FormPageController(),
      builder: (controller) {
        return SonrScaffold(
            body: Container(
          width: Get.width,
          height: Get.height,
          margin: EdgeInsets.only(bottom: 8, top: 72),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Image.asset("assets/images/icon_dark.png", width: 128, height: 128, colorBlendMode: BlendMode.difference),
            Expanded(
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          controller.lastName(controller.lastName.value.capitalizeFirst);
                          controller.lastName.refresh();
                          FocusScopeNode currentFocus = FocusScope.of(Get.context);
                          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                            FocusManager.instance.primaryFocus.unfocus();
                            controller.submit();
                          }
                        },
                        onChanged: (String value) {
                          controller.lastName(value);
                        }),

                    // ********************* //
                    // ** <Submit Button> ** //
                    // ********************* //
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: ColorButton.primary(
                          margin: EdgeWith.horizontal(88),
                          icon: SonrIcon.accept,
                          text: "Get Started",
                          onPressed: () {
                            controller.submit();
                          },
                          //margin: EdgeInsets.only(top: 12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
        ));
      },
    );
  }
}

class _FormPageController extends GetxController {
  // Properties
  final firstName = "".obs;
  final lastName = "".obs;
  final isPending = false.obs;

  // Error Status
  final firstNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final lastNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final emailStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);

  // ^ Submits Contact ^ //
  submit() async {
    if (validate()) {
      isPending(true);
      // Get Contact from Values
      var contact = Contact(firstName: firstName.value, lastName: lastName.value);

      // Remove Textfield Focus
      FocusScopeNode currentFocus = FocusScope.of(Get.context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus.unfocus();
      }

      // Process data.
      await UserService.newUser(contact);
      var result = await Get.find<UserService>().requestLocation();
      if (result) {
        isPending(false);
        await Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
      }
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
}
