import 'package:sonr_app/service/social_service.dart';
import 'package:sonr_app/service/user_service.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

// @ PeerStatus Enum
enum ProfileState { Viewing, Editing }

class ProfileController extends GetxController {
  // Properties
  final state = ProfileState.Viewing.obs;
  final focusTileIndex = (-2).obs;
  // Properties
  final username = "".obs;
  final isPrivate = false.obs;
  final hasSetProvider = false.obs;
  final provider = Rx<Contact_SocialTile_Provider>();
  final type = Rx<Contact_SocialTile_Type>();
  final radioGroupValue = "".obs;

  // References
  final step = 0.obs;
  final pageController = PageController();

  // References
  bool _isEditing = false;
  bool _isExpanded = false;

  // ^ Add Social Tile Move to Next Step ^ //
  nextStep() async {
    // @ Step 2
    if (step.value == 0) {
      // Move to Next Step
      if (provider.value != null && hasSetProvider.value) {
        step(1);
        pageController.nextPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
      } else {
        // Display Error Snackbar
        SonrSnack.missing("Select a provider first");
      }
    }
    // @ Step 3
    else if (step.value == 1) {
      // Update State
      if (username.value != "") {
        if (await Get.find<SocialMediaService>().validate(provider.value, username.value, isPrivate.value)) {
          step(2);
          pageController.nextPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
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
  }

  // ^ Add Social Tile Move to Next Step ^ //
  previousStep() {
    // First Step
    if (step.value == 0) {
      step(0);
    }
    // Step 2
    else if (step.value == 1) {
      step(0);
      pageController.previousPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
    }
    // Step 3
    else if (step.value == 2) {
      step(1);
      pageController.previousPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
    }
  }

  // ^ Finish and Save new Tile ^ //
  saveTile() {
    // Validate
    if (type.value != null && step.value == 2) {
      // Set Acquired Data
      var position = Contact_SocialTile_Position(index: UserService.tileCount);
      var links = Get.find<SocialMediaService>().getLinks(provider.value, username.value);

      // Create Tile from Values
      var tile = Contact_SocialTile(
        username: username.value,
        isPrivate: isPrivate.value,
        provider: provider.value,
        type: type.value,
        links: links,
        position: position,
      );

      // Save to Profile
      reset();
      UserService.addSocial(tile);
      Get.back(closeOverlays: true);
    } else {
      // Display Error Snackbar
      SonrSnack.missing("Pick a Tile Type", isLast: true);
    }
  }

  // ^ Resets current info ^
  reset() {
    username("");
    isPrivate(false);
    hasSetProvider(false);
    provider.nil();
    type.nil();
    radioGroupValue("");
    step(0);
  }

  // ^ Determine Auth Type ^
  getAuthType() {
    if (!isPrivate.value) {
      return SocialAuthType.Link;
    } else {
      // Link Item
      if (provider.value == Contact_SocialTile_Provider.Medium ||
          provider.value == Contact_SocialTile_Provider.Spotify ||
          provider.value == Contact_SocialTile_Provider.YouTube) {
        return SocialAuthType.Link;
      }
      // OAuth Item
      else {
        return SocialAuthType.OAuth;
      }
    }
  }

  // ^ Helper method to judge Privacy^ //
  bool doesProviderAllowVisibility(Contact_SocialTile_Provider provider) {
    return (provider == Contact_SocialTile_Provider.Twitter ||
        provider == Contact_SocialTile_Provider.Spotify ||
        provider == Contact_SocialTile_Provider.TikTok ||
        provider == Contact_SocialTile_Provider.YouTube);
  }

  // ^ Helper to Display Tile Options ^ //
  bool doesProviderAllowFeed(Contact_SocialTile_Provider provider) {
    return (provider == Contact_SocialTile_Provider.Twitter || provider == Contact_SocialTile_Provider.Medium);
  }

  ProfileController() {
    refresh();
  }

  // ^ Toggle Editing Mode ^ //
  toggleEditing() {
    _isEditing = !_isEditing;
    if (_isEditing) {
      state(ProfileState.Editing);
    } else {
      state(ProfileState.Viewing);
    }
  }

  // ^ Expand a Tile  ^ //
  toggleExpand(Contact_SocialTile tile) {
    _isExpanded = !_isExpanded;
    if (_isExpanded) {
      int idx = UserService.socials.indexOf(tile);
      focusTileIndex(idx);
    } else {
      focusTileIndex(-2);
    }
  }
}
