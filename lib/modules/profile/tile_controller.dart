import 'package:get/get.dart';
import 'package:sonar_app/data/medium_model.dart';
import 'package:sonar_app/data/social_model.dart';
import 'package:sonar_app/modules/profile/profile_controller.dart';
import 'package:sonar_app/service/social_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

enum TileState {
  None,
  Editing,
  NewStepOne,
  NewStepTwo,
  NewStepThree,
}

class TileController extends GetxController {
  final state = TileState.None.obs;
  final currentTile = Contact_SocialTile().obs;

  // ^ Initial for Existing Tile ^ //
  setTile(Contact_SocialTile value) {
    currentTile(value);
  }

  // ^ Create New Tile ^ //
  createTile() {
    currentTile(Contact_SocialTile());
    state(TileState.NewStepOne);
  }

  // ^ Step 1: In New Social Tile ^ //
  setProvider(Contact_SocialTile_Provider provider) {
    currentTile.value.provider = provider;
  }

  // ^ Step 2: In New Social Tile ^ //
  setUsername(String username) {
    currentTile.value.username = username;
  }

  // ^ Step 3: In New Social Tile ^ //
  setTypePos(Contact_SocialTile_TileType tileType) {
    currentTile.value.type = tileType;
  }

  // ^ Add Social Tile Move to Next Step ^ //
  nextStep() async {
    // @ Step 2
    if (state.value == TileState.NewStepOne) {
      if (currentTile.value.hasProvider()) {
        // Update State
        state(TileState.NewStepTwo);
      } else {
        // Display Error Snackbar
        Get.snackbar("Hold Up!", "Select a social media provider first",
            snackStyle: SnackStyle.FLOATING,
            duration: Duration(milliseconds: 1250),
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
    else if (state.value == TileState.NewStepTwo) {
      // Update State
      if (currentTile.value.hasUsername()) {
        await _fetchDataFromUsername();
        state(TileState.NewStepThree);
      } else {
        // Display Error Snackbar
        Get.snackbar("Wait!", "Add your information",
            snackStyle: SnackStyle.FLOATING,
            duration: Duration(milliseconds: 1250),
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
      if (currentTile.value.hasType() &&
          state.value == TileState.NewStepThree) {
        // Add Tile to Contact and Save
        Get.find<ProfileController>().saveSocialTile(currentTile.value);

        // Reset Current Tile
        state(TileState.None);
        currentTile.value = null;
      }
    }
  }

  _fetchDataFromUsername() async {
    // Get Feed Data For Username
    var data = await Get.find<SocialMediaService>().connect(
        currentTile.value.provider,
        SearchFilter.User,
        currentTile.value.username);

    // Get Medium Model
    if (data is MediumFeedModel) {
      data.posts.forEach((element) {
        print(element.title);
      });
    }
  }

  // ^ Add Social Tile Move to Next Step ^ //
  previousStep() {
    // First Step
    if (state.value == TileState.NewStepOne) {
      state(TileState.None);
    }
    // Step 2
    if (state.value == TileState.NewStepTwo) {
      state(TileState.NewStepOne);
    }
    // Step 3
    else if (state.value == TileState.NewStepThree) {
      state(TileState.NewStepTwo);
    }
  }

  // ^ Edit a Social Tile Type ^ //
  editType(Contact_SocialTile tile, dynamic data) {
    // TODO
  }

  // ^ Edit a Social Tile Type ^ //
  editPosition(Contact_SocialTile tile, dynamic data) {
    // TODO
  }

  // ^ Edit a Social Tile Type ^ //
  editShowcase(Contact_SocialTile tile, dynamic data) {
    // TODO
  }

  // ^ Edit a Social Tile Type ^ //
  editFeed(Contact_SocialTile tile, dynamic data) {
    // TODO
  }
}
