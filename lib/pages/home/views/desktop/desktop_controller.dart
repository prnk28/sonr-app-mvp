import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/style.dart';

class DesktopController extends GetxController {
  // @ Accessors
  Payload get currentPayload => inviteRequest.value.payload;

  // @ Properties
  final isNotEmpty = false.obs;
  final inviteRequest = AuthInvite().obs;
  final firstName = "".obs;
  final lastName = "".obs;
  final firstNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final lastNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);

  final scrollController = ScrollController();

  /// @ Validates Fields
  bool validate() {
    // Check Valid
    bool firstNameValid = GetUtils.isAlphabetOnly(firstName.value);
    bool lastNameValid = GetUtils.isAlphabetOnly(lastName.value);

    // Update Reactive Properties
    firstNameStatus(TextInputValidStatusUtils.fromValidBool(firstNameValid));
    lastNameStatus(TextInputValidStatusUtils.fromValidBool(lastNameValid));

    // Return Result
    return firstNameValid && lastNameValid;
  }

  /// Choose File
  Future<void> chooseFile(Peer peer) async {
    bool selected = await TransferService.chooseFile();
    if (selected) {
      TransferService.sendInviteToPeer(peer);
    }
  }

  /// Submits Contact
  setContact() async {
    if (validate()) {
      // Remove Textfield Focus
      FocusScopeNode currentFocus = FocusScope.of(Get.context!);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus!.unfocus();
      }

      // Save User
      await UserService.newUser(Contact(profile: Profile(firstName: this.firstName.value, lastName: this.lastName.value)));

      // Process data.
      SonrService.to.connect();
      Get.find<HomeController>().changeView(HomeView.Explorer);
    }
  }
}
