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
    return FormPanel.contact(children: [
      Padding(padding: EdgeInsets.all(8)),
      CircleContainer(
        alignment: Alignment.center,
        padding: EdgeInsets.all(4),
        child: Container(
          alignment: Alignment.center,
          child: SonrIcons.Avatar.greyWith(size: 100),
        ),
      ),
      RegisterTextField(
        type: RegisterTextFieldType.FirstName,
        focusNode: firstNameFocus,
        hint: hintName.item1,
        onEditingComplete: () {
          firstNameFocus.requestFocus();
          lastNameFocus.requestFocus();
        },
      ),
      RegisterTextField(
        type: RegisterTextFieldType.LastName,
        focusNode: lastNameFocus,
        hint: hintName.item2,
        onEditingComplete: () {
          controller.setContact();
        },
      ),
      Padding(padding: EdgeInsets.all(200))
    ]);
  }
}
