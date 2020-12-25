import 'package:get/get.dart';
import 'package:sonar_app/modules/profile/profile_controller.dart';
import 'package:sonar_app/service/social_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

enum TileState {
  None,
  Dragging,
  Editing,
  NewStepOne,
  NewStepTwo,
  NewStepThree,
}

enum SocialAuthType { Link, OAuth }
enum SearchFilter { User, Playlist, Post }

class TileController extends GetxController {
  // Properties
  final providerIsPublic = false.obs;
  final currentTile = Rx<Contact_SocialTile>();

  // References
  var state = TileState.None;
  bool _isEditing = false;

  // ^ Create New Tile ^ //
  setTile(Contact_SocialTile value) async {
    // Set Tile
    currentTile(value);
  }

  // ^ Toggle Editing Mode ^ //
  editTile(Contact_SocialTile value) {
    _isEditing = !_isEditing;
    if (_isEditing) {
      currentTile(value);
      state = TileState.Editing;
    } else {
      currentTile(Contact_SocialTile());
      state = TileState.None;
    }
    update(["SocialTile"]);
  }

  // ^ Create New Tile ^ //
  newTile() {
    currentTile(Contact_SocialTile());
    state = TileState.NewStepOne;
    update(["TileDialog"]);
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
    if (state == TileState.NewStepOne) {
      if (currentTile.value.hasProvider()) {
        // Update State
        state = TileState.NewStepTwo;
        update(["TileDialog"]);
      } else {
        // Display Error Snackbar
        SonrSnack.missing("Select a provider first");
      }
    }
    // @ Step 3
    else if (state == TileState.NewStepTwo) {
      // Update State
      if (currentTile.value.hasUsername()) {
        if (await Get.find<SocialMediaService>().validateUsername(
            currentTile.value.provider, currentTile.value.username)) {
          state = TileState.NewStepThree;
          update(["TileDialog"]);
        }
      } else {
        // Display Error Snackbar
        SonrSnack.missing("Add your username or Link your account");
      }
    }
    // @ Finish
    else {
      // Validate
      if (currentTile.value.hasType() && state == TileState.NewStepThree) {
        // Add Tile to Contact and Save
        Get.find<ProfileController>().saveSocialTile(currentTile.value);

        // Reset Current Tile
        Get.back();
        state = TileState.None;
        currentTile(Contact_SocialTile());
        providerIsPublic(false);
      } else {
        // Display Error Snackbar
        SonrSnack.missing("Pick a Tile Type", isLast: true);
      }
    }
  }

  // ^ Add Social Tile Move to Next Step ^ //
  previousStep() {
    // First Step
    if (state == TileState.NewStepOne) {
      state = TileState.None;
      update(["TileDialog"]);
    }
    // Step 2
    else if (state == TileState.NewStepTwo) {
      state = TileState.NewStepOne;
      update(["TileDialog"]);
    }
    // Step 3
    else if (state == TileState.NewStepThree) {
      state = TileState.NewStepTwo;
      update(["TileDialog"]);
    }
  }

  // ^ Helper method to judge Privacy^ //
  bool doesProviderAllowVisibility(Contact_SocialTile_Provider provider) {
    return (provider == Contact_SocialTile_Provider.Twitter ||
        provider == Contact_SocialTile_Provider.TikTok ||
        provider == Contact_SocialTile_Provider.YouTube);
  }

  // ^ Removes Current Tile ^ //
  deleteTile() {
    // Remove Tile from Contact and Save
    Get.find<ProfileController>().removeSocialTile(currentTile.value);
    update(["SocialTile"]);
  }
}
