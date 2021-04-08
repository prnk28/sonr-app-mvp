import 'package:sonr_app/theme/theme.dart';
import 'profile.dart';

class EditProfileView extends GetView<ProfileController> {
  final String headerText;
  EditProfileView({this.headerText = "Edit", Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: CustomScrollView(slivers: [
        // @ Top Banner
        SliverAppBar(
          backgroundColor: Colors.transparent,
          title: Container(
            height: kToolbarHeight + 24,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PlainButton(
                      icon: SonrIcon.close,
                      onPressed: () {
                        SonrOverlay.back();
                      }),
                  Expanded(child: Center(child: SonrText.header(headerText, size: 34))),
                  PlainButton(icon: SonrIcon.accept, onPressed: controller.completeEditing)
                ]),
          ),
        ),
        // @ Window Content
        EditNameView(),
      ]),
    );
  }
}

class EditNameView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    // Extract Data
    var hintName = SonrTextField.hintName();

    // Build View
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
        SonrTextField(
            hint: hintName.item1,
            label: "First Name",
            autoFocus: true,
            textInputAction: TextInputAction.next,
            controller: TextEditingController(text: UserService.firstName.value),
            value: controller.editedFirstName.value,
            onChanged: (val) => controller.editedFirstName(val)),
        SonrTextField(
            hint: hintName.item2,
            label: "Last Name",
            textInputAction: TextInputAction.next,
            controller: TextEditingController(text: UserService.lastName.value),
            value: controller.editedLastName.value,
            onChanged: (val) => controller.editedLastName(val)),
        SonrTextField(
            hint: "+1-555-555-5555",
            label: "Phone",
            textInputAction: TextInputAction.done,
            controller: TextEditingController(text: UserService.phone.value),
            value: controller.editedLastName.value,
            onEditingComplete: () {
              FocusScopeNode currentFocus = FocusScope.of(Get.context);
              if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus.unfocus();
              }
            },
            onChanged: (val) => controller.editedPhone(val)),
      ]),
    );
  }
}
