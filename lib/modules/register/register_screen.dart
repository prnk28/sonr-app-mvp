import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/service/permission.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

class RegisterScreen extends StatelessWidget {
  final hintName = SonrText.hintName();
  final lastNameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GetX<RegisterController>(
      init: RegisterController(),
      builder: (controller) {
        return SonrScaffold.appBarTitle(
            title: "Register",
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
                        child: ShapeButton.rectangle(
                          margin: EdgeInsetsX.horizontal(120),
                          icon: SonrIcon.accept,
                          text: SonrText.semibold("Submit"),
                          onPressed: () {
                            controller.submit();
                          },
                          //margin: EdgeInsets.only(top: 12),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]));
      },
    );
  }
}

class RegisterController extends GetxController {
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
      var contact = new Contact();
      contact.firstName = firstName.value;
      contact.lastName = lastName.value;

      // Remove Textfield Focus
      FocusScopeNode currentFocus = FocusScope.of(Get.context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus.unfocus();
      }

      // Process data.
      await UserService.saveChanges(providedContact: contact, isNewUser: true);
      var result = await Get.find<PermissionService>().requestLocation();
      if (result) {
        await Get.find<DeviceService>().currentLocation();
        isPending(false);
        Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
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
