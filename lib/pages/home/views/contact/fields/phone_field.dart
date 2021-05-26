import 'package:sonr_app/style/style.dart';
import '../profile_controller.dart';

/// @ Edit Profile Details View
class EditPhoneView extends GetView<ProfileController> {
  EditPhoneView({Key? key}) : super(key: key);
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
                  Expanded(child: Center(child: "Edit Phone".h4)),
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
                    hint: "+1-555-555-5555",
                    label: "Primary",
                    textInputAction: TextInputAction.done,
                    controller: TextEditingController(text: UserService.contact.value.hasPhone() ? UserService.contact.value.phonePrimary : ""),
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
