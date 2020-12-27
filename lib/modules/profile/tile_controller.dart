import 'package:get/get.dart';
import 'package:sonar_app/modules/profile/profile_controller.dart';
import 'package:sonar_app/service/social_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';
export '../social/medium_view.dart';
export '../social/twitter_view.dart';
export '../social/youtube_view.dart';

enum TileState { None, Dragging, Editing, Expanded }

enum TileStep {
  Zero,
  StepOne,
  StepTwo,
  StepThree,
}

enum SocialAuthType { Link, OAuth }
enum SearchFilter { User, Playlist, Post }

class TileController extends GetxController {
  // Properties
  final providerIsPublic = false.obs;
  final currentTile = Rx<Contact_SocialTile>();
  final state = TileState.None.obs;
  final step = TileStep.Zero.obs;

  // References
  int index;
  bool _isEditing = false;
  bool _isExpanded = false;

  // ^ Create New Tile ^ //
  initTile(Contact_SocialTile value, int index) async {
    // Set Tile
    currentTile(value);
  }

  // ^ Create New Tile ^ //
  newTile() {
    currentTile(Contact_SocialTile());
    step(TileStep.StepOne);
  }

  // ^ Toggle Expanded Mode ^ //
  setExpanded(bool expanded) {
    _isExpanded = expanded;
    if (_isExpanded) {
      Get.find<ProfileController>().focusTileIndex(index);
      Get.find<ProfileController>().focusTileIndex.refresh();
      state(TileState.Expanded);
    } else {
      Get.find<ProfileController>().focusTileIndex(-2);
      Get.find<ProfileController>().focusTileIndex.refresh();
      state(TileState.None);
    }
  }

  // ^ Toggle Editing Mode ^ //
  editTile() {
    _isEditing = !_isEditing;
    if (_isEditing) {
      state(TileState.Editing);
    } else {
      currentTile(Contact_SocialTile());
      state(TileState.None);
    }
    update(["SocialTile"]);
  }

  // ^ Determine Auth Type ^
  getAuthType(Contact_SocialTile tile) {
    if (providerIsPublic.value) {
      return SocialAuthType.Link;
    } else {
      // Link Item
      if (tile.provider == Contact_SocialTile_Provider.Medium ||
          tile.provider == Contact_SocialTile_Provider.Spotify ||
          tile.provider == Contact_SocialTile_Provider.YouTube) {
        return SocialAuthType.Link;
      }
      // OAuth Item
      else {
        return SocialAuthType.OAuth;
      }
    }
  }

  // ^ Add Social Tile Move to Next Step ^ //
  nextStep() async {
    // @ Step 2
    if (step.value == TileStep.StepOne) {
      if (currentTile.value.hasProvider()) {
        // Update State
        step(TileStep.StepTwo);
      } else {
        // Display Error Snackbar
        SonrSnack.missing("Select a provider first");
      }
    }
    // @ Step 3
    else if (step.value == TileStep.StepTwo) {
      // Update State
      if (currentTile.value.hasUsername()) {
        if (await Get.find<SocialMediaService>()
            .validate(currentTile.value.provider, currentTile.value.username)) {
          step(TileStep.StepThree);
        }
      } else {
        // Display Error Snackbar
        SonrSnack.missing("Add your username or Link your account");
      }
    }
  }

  // ^ Finish and Save new Tile ^ //
  bool finish() {
    // Validate
    if (currentTile.value.hasType() && step.value == TileStep.StepThree) {
      // Set Position
      currentTile.value.position =
          Get.find<ProfileController>().socials.length - 1;

      // Add Tile to Contact and Save
      Get.find<ProfileController>().saveSocialTile(currentTile.value);
      providerIsPublic(false);
      return true;
    } else {
      // Display Error Snackbar
      SonrSnack.missing("Pick a Tile Type", isLast: true);
      return false;
    }
  }

  // ^ Add Social Tile Move to Next Step ^ //
  previousStep() {
    // First Step
    if (step.value == TileStep.StepOne) {
      step(TileStep.Zero);
    }
    // Step 2
    else if (step.value == TileStep.StepTwo) {
      step(TileStep.StepOne);
    }
    // Step 3
    else if (step.value == TileStep.StepThree) {
      step(TileStep.StepTwo);
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
    return (provider == Contact_SocialTile_Provider.Twitter ||
        provider == Contact_SocialTile_Provider.Medium);
  }

  // ^ Removes Current Tile ^ //
  deleteTile() {
    // Remove Tile from Contact and Save
    Get.find<ProfileController>().removeSocialTile(currentTile.value);
    update(["SocialTile"]);
  }
}
