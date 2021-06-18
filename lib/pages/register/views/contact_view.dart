import 'package:sonr_app/pages/register/widgets/textfield.dart';
import 'package:sonr_app/style.dart';
import '../register_controller.dart';

class ProfileSetupView extends GetView<RegisterController> {
  final hintName = SonrTextField.hintName();
  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  ProfileSetupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => FormPanel.contact(children: [
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
          RegisterTextField.firstName(
            focusNode: firstNameFocus,
            hint: hintName.item1,
            onEditingComplete: () {
              lastNameFocus.requestFocus();
            },
          ),
          RegisterTextField.lastName(
            focusNode: lastNameFocus,
            hint: hintName.item2,
            onEditingComplete: () {
              controller.lastName(controller.lastName.value.capitalizeFirst!);
              controller.lastName.refresh();
              FocusScopeNode currentFocus = FocusScope.of(Get.context!);
              if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus!.unfocus();
                controller.setContact();
              }
            },
          ),
        ]));
  }
}
