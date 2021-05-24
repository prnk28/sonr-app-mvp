import 'package:sonr_app/style/style.dart';
import '../profile_controller.dart';

/// @ Edit Profile Details View
class EditDetailsView extends GetView<ProfileController> {
  EditDetailsView({Key? key}) : super(key: key);
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  final scrollController = ScrollController();
  final hintName = SonrTextField.hintName();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8),
      child: CustomScrollView(controller: scrollController, slivers: [
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
                  Expanded(child: Center(child: "Edit Details".h4)),
                  PlainIconButton(icon: SonrIcons.Check.gradient(value: SonrGradient.Tertiary), onPressed: controller.saveEditedDetails)
                ]),
          ),
        ),
        // @ Window Content
        SliverFillRemaining(
          hasScrollBody: true,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Form(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                SonrTextField(
                    hint: hintName.item1,
                    label: "First Name",
                    autoFocus: true,
                    focusNode: _firstNameFocus,
                    textInputAction: TextInputAction.next,
                    controller: TextEditingController(text: UserService.contact.value.firstName),
                    onEditingComplete: () {
                      _lastNameFocus.requestFocus();
                      scrollController.animateTo(40, duration: 250.milliseconds, curve: Curves.easeOut);
                    },
                    value: controller.editedFirstName.value,
                    onChanged: (val) => controller.editedFirstName(val)),
                SonrTextField(
                    hint: hintName.item2,
                    label: "Last Name",
                    textInputAction: TextInputAction.next,
                    controller: TextEditingController(text: UserService.contact.value.lastName),
                    focusNode: _lastNameFocus,
                    value: controller.editedLastName.value,
                    onEditingComplete: () {
                      _phoneNumberFocus.requestFocus();
                      scrollController.animateTo(80, duration: 250.milliseconds, curve: Curves.easeOut);
                    },
                    onChanged: (val) => controller.editedLastName(val)),
                SonrTextField(
                    hint: "+1-555-555-5555",
                    label: "Phone",
                    textInputAction: TextInputAction.done,
                    controller:
                        TextEditingController(text: UserService.contact.value.hasPhone() ? UserService.contact.value.phonePrimary : ""),
                    value: controller.editedLastName.value,
                    focusNode: _phoneNumberFocus,
                    onEditingComplete: () {
                      controller.saveEditedDetails();
                      _phoneNumberFocus.unfocus();
                    },
                    onChanged: (val) => controller.editedPhone(val))
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
