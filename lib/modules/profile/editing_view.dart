import 'package:sonr_app/theme/theme.dart';
import 'profile.dart';

class EditProfileView extends GetView<ProfileController> {
  final String headerText;
  EditProfileView({this.headerText = "Edit", Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(bottom: 260),
        child: NeumorphicBackground(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            borderRadius: BorderRadius.circular(30),
            backendColor: Colors.transparent,
            child: Neumorphic(
                style: SonrStyle.normal,
                child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      // @ Top Banner
                      Container(
                        height: kToolbarHeight + 16 * 2,
                        padding: EdgeInsets.only(top: 0, bottom: 15, left: 14, right: 14),
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ShapeButton.circle(
                                  icon: SonrIcon.close,
                                  onPressed: () {
                                    SonrOverlay.back();
                                  }),
                              Expanded(child: Center(child: SonrText.header(headerText, size: 34))),
                              ShapeButton.circle(icon: SonrIcon.accept, onPressed: controller.completeEditing)
                            ]),
                      ),

                      // @ Window Content
                      EditNameView(),
                    ])))),
      ),
    );
  }
}

class EditNameView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    // Extract Data
    final lastNameFocus = FocusNode();
    final phoneFocus = FocusNode();
    final scroller = ScrollController();
    var hintName = SonrTextField.hintName();

    // Build View
    return Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
          controller: scroller,
          child: Column(children: [
            SonrTextField(
                hint: hintName.item1,
                label: "First Name",
                autoFocus: true,
                textInputAction: TextInputAction.next,
                controller: TextEditingController(text: UserService.firstName.value),
                value: controller.editedFirstName.value,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(lastNameFocus);
                },
                onChanged: (val) => controller.editedFirstName(val)),
            SonrTextField(
                hint: hintName.item2,
                label: "Last Name",
                focusNode: lastNameFocus,
                textInputAction: TextInputAction.next,
                controller: TextEditingController(text: UserService.lastName.value),
                value: controller.editedLastName.value,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(phoneFocus);
                },
                onChanged: (val) => controller.editedLastName(val)),
            SonrTextField(
                hint: "+1-555-555-5555",
                label: "Phone",
                focusNode: phoneFocus,
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
            Padding(padding: EdgeInsets.all(8))
          ]),
        ));
  }
}
