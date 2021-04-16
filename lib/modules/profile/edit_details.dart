import 'package:sonr_app/theme/form/theme.dart';
import 'profile.dart';

// ^ Edit Profile Details View ^ //
class EditDetailsView extends GetView<ProfileController> {
  final String headerText;
  EditDetailsView({this.headerText = "Edit Details", Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract Data
    final hintName = SonrTextField.hintName();

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: CustomScrollView(slivers: [
        // @ Top Banner
        SliverToBoxAdapter(
          child: Container(
            height: kToolbarHeight + 24,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PlainButton(icon: SonrIcons.Close, onPressed: controller.exitToViewing),
                  Expanded(child: Center(child: headerText.h2)),
                  PlainButton(icon: SonrIcons.Check, onPressed: controller.saveEditedDetails)
                ]),
          ),
        ),
        // @ Window Content
        SliverFillRemaining(
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
        ),
      ]),
    );
  }
}
