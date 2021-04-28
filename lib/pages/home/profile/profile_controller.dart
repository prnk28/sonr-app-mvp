import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_plugin/sonr_social.dart';
import 'package:get/get.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:sonr_app/data/data.dart';

// @ PeerStatus Enum
enum ProfileViewStatus { Viewing, EditDetails, AddSocial, AddPicture }

extension ProfileViewStatusUtils on ProfileViewStatus {
  bool get isEditing => this == ProfileViewStatus.EditDetails;
  bool get isViewing => this == ProfileViewStatus.Viewing;
  bool get isAddingPicture => this == ProfileViewStatus.AddPicture;
  bool get isAddingSocial => this == ProfileViewStatus.AddSocial;
}

class ProfileController extends GetxController {
  // Properties
  final status = ProfileViewStatus.Viewing.obs;
  final focused = FocusedTile(-1, false).obs;
  final options = SonrSocial.options(UserService.socials);
  final dropdownIndex = (-1).obs;

  // Edited Values
  final editedFirstName = RxString(UserService.firstName.value);
  final editedLastName = RxString(UserService.lastName.value);
  final editedPhone = RxString(UserService.phone.value);

  // References
  final step = Rx<TileStep>(null);
  final pageController = PageController();
  final viewParameters = Rx<NeumorphCardParams>(NeumorphCardParams());

  // ** Initialize Method ** //
  onInit() async {
    super.onInit();
  }

  // ^ Start Editing Picture ^ //
  void setAddPicture() {
    HapticFeedback.heavyImpact();
    status(ProfileViewStatus.AddPicture);
  }

  // ^ Start Editing for Social Tile ^ //
  void setAddTile() {
    HapticFeedback.heavyImpact();
    step(TileStep(nextStep, previousStep, saveTile));
    status(ProfileViewStatus.AddSocial);
  }

  // ^ Start Editing for Details ^ //
  void setEditingMode() {
    HapticFeedback.heavyImpact();
    status(ProfileViewStatus.EditDetails);
  }

  // ^ End Add/Edit State ^ //
  void exitToViewing() {
    HapticFeedback.mediumImpact();
    status(ProfileViewStatus.Viewing);
  }

  // ^ Completed Editing Details ^ //
  void saveEditedDetails() {
    // Update Values in Profile Controller
    UserService.firstName(editedFirstName.value);
    UserService.lastName(editedLastName.value);
    UserService.phone(editedPhone.value);
    UserService.saveChanges();
    status(ProfileViewStatus.Viewing);
  }

  // -- Set Privacy -- //
  isPrivate(bool value) {
    step.update((val) {
      val.isPrivate = value;
    });
    step.refresh();
  }

  // -- Set Current Provider -- //
  provider(int index) {
    step.update((val) {
      val.provider = options[index];
    });
    step.refresh();
  }

  // -- Set Tile Type -- //
  type(Contact_SocialTile_Type type) {
    step.update((val) {
      val.type = type;
    });
    step.refresh();
  }

  // -- Set Social User -- //
  user(SocialUser user) {
    step.update((val) {
      val.user = user;
    });
    step.refresh();
  }

  // ^ Add Social Tile Move to Next Step ^ //
  nextStep() async {
    // @ Step 2
    if (step.value.current == 0) {
      if (dropdownIndex.value != -1) {
        provider(dropdownIndex.value);
        step.update((val) {
          val.current = 1;
          pageController.nextPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
        });
        step.refresh();
      } else {
        // Display Error Snackbar
        SonrSnack.missing("Select a provider first");
      }
    }
    // @ Step 3
    else if (step.value.current == 1) {
      // Update State
      if (step.value.hasUser) {
        step.update((val) {
          val.current = 2;
          pageController.nextPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
        });
        step.refresh();

        FocusScopeNode currentFocus = FocusScope.of(Get.context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      }
    } else {
      // Display Error Snackbar
      SonrSnack.missing("Add your username or Link your account");
    }
  }

  // ^ Add Social Tile Move to Next Step ^ //
  previousStep() {
    // Step 2
    if (step.value.current == 1) {
      step.update((val) {
        val.current = 0;
        pageController.previousPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
      });
      step.refresh();
    }
    // Step 3
    else if (step.value.current == 2) {
      step.update((val) {
        val.current = 1;
        pageController.previousPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
      });
      step.refresh();
    }
  }

  // ^ Finish and Save new Tile ^ //
  saveTile() {
    // Validate
    if (step.value.hasType && step.value.current == 2) {
      // Create Tile from Values
      var tile = Contact_SocialTile(
        username: step.value.user.username,
        isPrivate: step.value.isPrivate,
        provider: step.value.provider,
        type: step.value.type,
        links: step.value.links,
        position: Contact_SocialTile_Position(index: UserService.tileCount),
      );

      // Save to Profile
      UserService.addSocial(tile);
      status(ProfileViewStatus.Viewing);
      reset();
    } else {
      // Display Error Snackbar
      SonrSnack.missing("Pick a Tile Type", isLast: true);
    }
  }

  // ^ Resets current info ^
  reset() {
    step(TileStep(nextStep, previousStep, saveTile));
    step.refresh();
  }

  // ^ Expand a Tile  ^ //
  toggleExpand(int index, bool isExpanded) {
    focused(FocusedTile(index, isExpanded));
    update(['social-grid']);
  }
}
