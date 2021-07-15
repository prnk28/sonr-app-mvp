import 'package:sonr_app/pages/personal/controllers/personal_controller.dart';
import 'package:sonr_app/style/style.dart';

/// #### Edit Profile Details View
class EditNameView extends GetView<PersonalController> {
  EditNameView({Key? key}) : super(key: key);
  final FocusNode _prefixNameFocus = FocusNode();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _middleNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _suffixNameFocus = FocusNode();
  final FocusNode _nickNameFocus = FocusNode();
  final hintName = TextUtils.hintName;
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          height: Height.full,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(children: [
              DesignTextField(
                  hint: "Dr.",
                  label: "Prefix",
                  autoFocus: true,
                  focusNode: _prefixNameFocus,
                  textInputAction: TextInputAction.next,
                  controller: TextEditingController(text: ContactService.contact.value.general.name.prefix),
                  onEditingComplete: () {
                    _firstNameFocus.requestFocus();
                    scrollController.animateTo(40, duration: 250.milliseconds, curve: Curves.easeOut);
                  },
                  value: controller.editedFirstName.value,
                  onChanged: (val) => controller.editedFirstName(val)),
              DesignTextField(
                  hint: hintName.item1,
                  label: "First Name",
                  focusNode: _firstNameFocus,
                  textInputAction: TextInputAction.next,
                  controller: TextEditingController(text: ContactService.contact.value.firstName),
                  onEditingComplete: () {
                    _middleNameFocus.requestFocus();
                    scrollController.animateTo(80, duration: 250.milliseconds, curve: Curves.easeOut);
                  },
                  value: controller.editedFirstName.value,
                  onChanged: (val) => controller.editedFirstName(val)),
              DesignTextField(
                  hint: "A.",
                  label: "Middle Name",
                  focusNode: _middleNameFocus,
                  textInputAction: TextInputAction.next,
                  controller: TextEditingController(text: ContactService.contact.value.general.name.middleName),
                  onEditingComplete: () {
                    _lastNameFocus.requestFocus();
                    scrollController.animateTo(120, duration: 250.milliseconds, curve: Curves.easeOut);
                  },
                  value: controller.editedFirstName.value,
                  onChanged: (val) => controller.editedFirstName(val)),
              DesignTextField(
                  hint: hintName.item2,
                  label: "Last Name",
                  textInputAction: TextInputAction.next,
                  controller: TextEditingController(text: ContactService.contact.value.lastName),
                  focusNode: _lastNameFocus,
                  value: controller.editedLastName.value,
                  onEditingComplete: () {
                    _suffixNameFocus.requestFocus();
                    scrollController.animateTo(160, duration: 250.milliseconds, curve: Curves.easeOut);
                  },
                  onChanged: (val) => controller.editedLastName(val)),
              DesignTextField(
                  hint: "Jr.",
                  label: "Suffix",
                  textInputAction: TextInputAction.next,
                  controller: TextEditingController(text: ContactService.contact.value.hasPhone() ? ContactService.contact.value.phonePrimary : ""),
                  value: controller.editedLastName.value,
                  focusNode: _suffixNameFocus,
                  onEditingComplete: () {
                    _nickNameFocus.requestFocus();
                    scrollController.animateTo(200, duration: 250.milliseconds, curve: Curves.easeOut);
                  },
                  onChanged: (val) => controller.editedPhone(val)),
              DesignTextField(
                  hint: "Rocket",
                  label: "Nick Name",
                  textInputAction: TextInputAction.done,
                  controller: TextEditingController(text: ""),
                  focusNode: _nickNameFocus,
                  value: controller.editedLastName.value,
                  onEditingComplete: () {
                    _nickNameFocus.unfocus();
                    controller.saveEditedDetails();
                  },
                  onChanged: (val) => controller.editedLastName(val)),
            ]),
          ),
        ));
  }
}
