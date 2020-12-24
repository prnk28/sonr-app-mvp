import 'package:get/get.dart';
import 'package:sonar_app/data/medium_model.dart';
import 'package:sonar_app/data/social_model.dart';
import 'package:sonar_app/modules/profile/profile_controller.dart';
import 'package:sonar_app/service/social_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

enum TileState {
  Loading,
  None,
  Editing,
  NewStepOne,
  NewStepTwo,
  NewStepThree,
}

class TileController extends GetxController {
  // Properties
  var fetchedData;
  var state = TileState.Loading;

  // Reactive
  final currentTile = Contact_SocialTile().obs;

  // References
  bool _isEditing = false;

  // ^ Fetch Tile Data ^
  fetchData(Contact_SocialTile tile) async {
    var item = Get.find<SocialMediaService>().getItem(tile);
    fetchedData = await Get.find<SocialMediaService>().fetchData(item);
    state = TileState.None;
    update(["SocialTile"]);
  }

  // ^ Toggle Editing Mode ^ //
  toggleEditing(Contact_SocialTile value) {
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
  createTile() {
    currentTile(Contact_SocialTile());
    state = TileState.NewStepOne;
    update(["TileDialog"]);
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
        Get.snackbar("Hold Up!", "Select a social media provider first",
            snackStyle: SnackStyle.FLOATING,
            duration: Duration(milliseconds: 1500),
            forwardAnimationCurve: Curves.bounceIn,
            reverseAnimationCurve: Curves.easeOut,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.warning_outlined,
              color: Colors.white,
            ),
            colorText: Colors.white);
      }
    }
    // @ Step 3
    else if (state == TileState.NewStepTwo) {
      // Update State
      if (currentTile.value.hasUsername()) {
        if (await _checkMediumUsername()) {
          state = TileState.NewStepThree;
          update(["TileDialog"]);
        }
      } else {
        // Display Error Snackbar
        Get.snackbar("Wait!", "Add your information",
            snackStyle: SnackStyle.FLOATING,
            duration: Duration(milliseconds: 1500),
            forwardAnimationCurve: Curves.bounceIn,
            reverseAnimationCurve: Curves.easeOut,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.warning_outlined,
              color: Colors.white,
            ),
            colorText: Colors.white);
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
      } else {
        // Display Error Snackbar
        Get.snackbar("Almost There!", "Pick a Tile Type",
            snackStyle: SnackStyle.FLOATING,
            duration: Duration(milliseconds: 1500),
            forwardAnimationCurve: Curves.bounceIn,
            reverseAnimationCurve: Curves.easeOut,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.warning_outlined,
              color: Colors.white,
            ),
            colorText: Colors.white);
      }
    }
  }

  // ^ Simple Data Validation ^ //
  // TODO: Temporary find Universal Method of Handling API's
  Future<bool> _checkMediumUsername() async {
    // Get Feed Data For Username
    var data = await Get.find<SocialMediaService>().connect(
        currentTile.value.provider,
        SearchFilter.User,
        currentTile.value.username);

    // Get Medium Model
    if (data != null) {
      if (data is MediumFeedModel) {
        return true;
      }
    }
    return false;
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

  // ^ Edit a Social Tile Type ^ //
  editType(Contact_SocialTile tile, dynamic data) {
    // TODO
    update(["SocialTile"]);
  }

  // ^ Edit a Social Tile Type ^ //
  editPosition(Contact_SocialTile tile, dynamic data) {
    // TODO
    update(["SocialTile"]);
  }

  // ^ Edit a Social Tile Type ^ //
  editShowcase(Contact_SocialTile tile, dynamic data) {
    // TODO
    update(["SocialTile"]);
  }

  // ^ Edit a Social Tile Type ^ //
  editFeed(Contact_SocialTile tile, dynamic data) {
    // TODO
    update(["SocialTile"]);
  }

  // ^ Remove a Social Tile ^ //
  deleteTile() {
    // Remove Tile from Contact and Save
    Get.find<ProfileController>().removeSocialTile(currentTile.value);
    update(["SocialTile"]);
  }
}
