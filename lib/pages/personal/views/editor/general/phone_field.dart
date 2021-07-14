import 'package:sonr_app/pages/personal/controllers/personal_controller.dart';
import 'package:sonr_app/style/style.dart';

/// #### Edit Profile Details View
class EditPhoneView extends GetView<PersonalController> {
  EditPhoneView({Key? key}) : super(key: key);
  final FocusNode _primaryNumberFocus = FocusNode();
  final scrollController = ScrollController();
  final hintName = TextUtils.hintName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Height.ratio(0.4),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(children: [
          DesignTextField(
              hint: "+1-555-555-5555",
              label: "Primary",
              textInputAction: TextInputAction.done,
              controller: TextEditingController(text: ContactService.contact.value.hasPhone() ? ContactService.contact.value.phonePrimary : ""),
              value: controller.editedLastName.value,
              focusNode: _primaryNumberFocus,
              onEditingComplete: () {
                controller.saveEditedDetails();
                _primaryNumberFocus.unfocus();
              },
              onChanged: (val) => controller.editedPhone(val))
        ]),
      ),
    );
  }
}
