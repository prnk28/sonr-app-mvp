import 'package:sonr_app/style.dart';
import '../register_controller.dart';

class FormPage extends GetView<RegisterController> {
  final hintName = SonrTextField.hintName();
  final lastNameFocus = FocusNode();
  FormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return SonrScaffold(
            gradient: SonrGradients.SeaShore,
            body: Container(
              padding: EdgeInsets.all(16),
              width: Get.width,
              height: Get.height,
              child: Column(children: <Widget>[
                "Edit Profile".gradient(value: SonrGradients.PremiumWhite, size: 52),
                Divider(color: Get.theme.hintColor.withOpacity(0.6), indent: 8, endIndent: 8),
                Padding(padding: EdgeInsets.all(8)),
                CircleContainer(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(4),
                  child: Container(
                    alignment: Alignment.center,
                    width: 120,
                    height: 120,
                    child: SonrIcons.Avatar.greyWith(size: 120),
                  ),
                ),
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
                      controller.firstName(controller.firstName.value.capitalizeFirst!);
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
                      controller.lastName(controller.lastName.value.capitalizeFirst!);
                      controller.lastName.refresh();
                      FocusScopeNode currentFocus = FocusScope.of(Get.context!);
                      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                        FocusManager.instance.primaryFocus!.unfocus();
                        controller.setContact();
                      }
                    },
                    onChanged: (String value) {
                      controller.lastName(value);
                      controller.lastName.refresh();
                    }),

                Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(bottom: 32),
                    child: ColorButton.neutral(onPressed: controller.exportCode, text: "Later"),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(bottom: 32),
                    child: ColorButton.primary(onPressed: controller.nextFromBackup, text: "Confirm"),
                  )
                ])
              ]),
            ));
      },
    );
  }
}
