import 'package:sonr_app/style/style.dart';
import '../profile_controller.dart';

/// @ Edit Profile Details View
class EditNameView extends GetView<ProfileController> {
  EditNameView({Key? key}) : super(key: key);
  // TODO: final FocusNode _prefixNameFocus = FocusNode();
  final FocusNode _firstNameFocus = FocusNode();
  // TODO: final FocusNode _middleNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  // TODO: final FocusNode _suffixNameFocus = FocusNode();
  // TODO: final FocusNode _nickNameFocus = FocusNode();
  final hintName = SonrTextField.hintName();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(primary: true, slivers: [
      // @ Top Banner
      SliverToBoxAdapter(
        child: Container(
          height: kToolbarHeight + 24,
          child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PlainIconButton(icon: SonrIcons.Close.gradient(value: SonrGradient.Critical), onPressed: controller.exitToViewing),
                Expanded(child: Center(child: "Edit Name".h4)),
                PlainIconButton(icon: SonrIcons.Check.gradient(value: SonrGradient.Tertiary), onPressed: controller.saveEditedDetails)
              ]),
        ),
      ),
      // TODO:
      SliverList(
          delegate: SliverChildListDelegate.fixed([
        // SonrTextField(
        //     hint: "Dr.",
        //     label: "Prefix",
        //     autoFocus: true,
        //     focusNode: _prefixNameFocus,
        //     textInputAction: TextInputAction.next,
        //     controller: TextEditingController(text: UserService.contact.value.general.name.prefix),
        //     onEditingComplete: () {
        //       _firstNameFocus.requestFocus();
        //     },
        //     value: controller.editedFirstName.value,
        //     onChanged: (val) => controller.editedFirstName(val)),
        SonrTextField(
            hint: hintName.item1,
            label: "First Name",
            focusNode: _firstNameFocus,
            textInputAction: TextInputAction.next,
            controller: TextEditingController(text: UserService.contact.value.firstName),
            onEditingComplete: () {
              _lastNameFocus.requestFocus();
            },
            value: controller.editedFirstName.value,
            onChanged: (val) => controller.editedFirstName(val)),
        // TODO:
        // SonrTextField(
        //     hint: "A.",
        //     label: "Middle Name",
        //     focusNode: _middleNameFocus,
        //     textInputAction: TextInputAction.next,
        //     controller: TextEditingController(text: UserService.contact.value.general.name.middleName),
        //     onEditingComplete: () {
        //       _lastNameFocus.requestFocus();
        //     },
        //     value: controller.editedFirstName.value,
        //     onChanged: (val) => controller.editedFirstName(val)),
        SonrTextField(
            hint: hintName.item2,
            label: "Last Name",
            textInputAction: TextInputAction.next,
            controller: TextEditingController(text: UserService.contact.value.lastName),
            focusNode: _lastNameFocus,
            value: controller.editedLastName.value,
            onEditingComplete: () {
              _lastNameFocus.unfocus();
              controller.saveEditedDetails();
            },
            onChanged: (val) => controller.editedLastName(val)),
        // TODO:
        // SonrTextField(
        //     hint: "Jr.",
        //     label: "Suffix",
        //     textInputAction: TextInputAction.done,
        //     controller: TextEditingController(text: UserService.contact.value.hasPhone() ? UserService.contact.value.phonePrimary : ""),
        //     value: controller.editedLastName.value,
        //     focusNode: _suffixNameFocus,
        //     onEditingComplete: () {
        //       controller.saveEditedDetails();
        //       _nickNameFocus.requestFocus();
        //     },
        //     onChanged: (val) => controller.editedPhone(val)),
        // SonrTextField(
        //     hint: "Rocket",
        //     label: "Nick Name",
        //     textInputAction: TextInputAction.next,
        //     controller: TextEditingController(text: UserService.contact.value.lastName),
        //     focusNode: _nickNameFocus,
        //     value: controller.editedLastName.value,
        //     onEditingComplete: () {
        //       _nickNameFocus.unfocus();
        //       controller.saveEditedDetails();
        //     },
        //     onChanged: (val) => controller.editedLastName(val)),
      ])),
    ]);
  }
}
