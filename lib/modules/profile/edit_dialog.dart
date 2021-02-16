import 'package:get/get.dart';
import 'package:sonr_app/modules/profile/profile_controller.dart';
import 'package:sonr_app/theme/theme.dart';

// ** Edit Sheet View for Profile ** //
enum EditType { ColorCombo, NameField }

class EditDialog extends GetView<EditDialogController> {
  final String headerText;
  final EditType type;

  EditDialog(this.type, {this.headerText});

  factory EditDialog.colorComboPicker({@required String text, @required Function(dynamic) onChanged}) {
    return EditDialog(
      EditType.ColorCombo,
    );
  }

  factory EditDialog.nameField({@required Function(Map<String, String>) onSubmitted, @required String firstValue, @required String lastValue}) {
    return EditDialog(
      EditType.NameField,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
        style: NeumorphicStyle(color: SonrColor.base),
        child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              // @ Top Banner
              SonrHeaderBar.twoButton(
                  title: SonrText.header("Edit", size: 34),
                  leading: SonrButton.circle(
                      icon: SonrIcon.close,
                      onPressed: () {
                        Get.back();
                      }),
                  action: SonrButton.circle(icon: SonrIcon.accept, onPressed: controller.complete)),

              // @ Window Content

              _buildView(),
            ])));
  }

  // ^ Build View by EditType ^ //
  Widget _buildView() {
    switch (type) {
      case EditType.ColorCombo:
        return Container();
        break;
      case EditType.NameField:
        return Material(
            color: Colors.transparent,
            child: Column(children: [
              SonrTextField(
                  hint: "Enter your First Name",
                  label: "First Name",
                  controller: TextEditingController(text: Get.find<ProfileController>().firstName.value),
                  value: controller.editFirstName.value,
                  onChanged: (val) => controller.editFirstName(val)),
              SonrTextField(
                  hint: "Enter your Last Name",
                  label: "Last Name",
                  controller: TextEditingController(text: Get.find<ProfileController>().lastName.value),
                  value: controller.editLastName.value,
                  onChanged: (val) => controller.editLastName(val)),
              Padding(padding: EdgeInsets.all(6))
            ]));
        break;
    }
    return Container();
  }
}

class EditDialogController extends GetxController {
  // Properties
  final editFirstName = "".obs;
  final editLastName = "".obs;

  // References
  TextEditingController firstNameController = TextEditingController(text: Get.find<ProfileController>().firstName.value);
  TextEditingController lastNameController;

  // ^ Initialize the Controller ^ //
  void onInit() async {
    // Get Initial Values
    var firstInitial = Get.find<ProfileController>().firstName.value;
    var lastInitial = Get.find<ProfileController>().lastName.value;

    // Set Values
    editFirstName(firstInitial);
    editLastName(lastInitial);
    super.onInit();
  }

  // ^ Completed Editing ^ //
  void complete() {
    // Update Values in Profile Controller
    Get.find<ProfileController>().firstName(editFirstName.value);
    Get.find<ProfileController>().lastName(editLastName.value);
    Get.find<ProfileController>().saveChanges();

    // Close View
    Get.back();
  }
}
