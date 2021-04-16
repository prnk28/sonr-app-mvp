import 'package:sonr_app/theme/form/theme.dart';
import 'register_controller.dart';

class FormPage extends GetView<RegisterController> {
  final hintName = SonrTextField.hintName();
  final lastNameFocus = FocusNode();
  FormPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return SonrScaffold(
            body: Container(
          width: Get.width,
          height: Get.height,
          margin: EdgeInsets.only(bottom: 8, top: 72),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            SonrAssetLogo.Top.widget,
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
                          controller.firstName.refresh();
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
                            controller.setContact();
                          }
                        },
                        onChanged: (String value) {
                          controller.lastName(value);
                          controller.lastName.refresh();
                        }),

                    // ********************* //
                    // ** <Submit Button> ** //
                    // ********************* //
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: ColorButton.primary(
                          margin: EdgeWith.horizontal(88),
                          icon: SonrIcons.Check,
                          text: "Get Started",
                          onPressed: () {
                            controller.setContact();
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
