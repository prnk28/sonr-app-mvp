import 'dart:io';
import 'package:sonar_app/service/device_service.dart';
import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

// @ PeerStatus Enum
enum ProfileState {
  Viewing,
  Editing,
  AddingTileStepOne,
  AddingTileStepTwo,
  AddingTileStepThree,
}

// @ Contact Value Enum
enum ContactCoreValueType {
  FirstName,
  LastName,
  Phone,
  Email,
  Website,
}

// @ SocialEditType Enum
enum SocialEditType { TileType, Preview, Url }

class ProfileController extends GetxController {
  final userContact = Contact().obs;
  final state = ProfileState.Viewing.obs;
  final currentTile = Contact_SocialTile().obs;

  ProfileController() {
    var contact = Get.find<DeviceService>().user.contact;
    userContact(contact);
  }

  // ^ Update a Value in User Contact ^ //
  editCoreValue(ContactCoreValueType type, String newValue) {
    switch (type) {
      case ContactCoreValueType.FirstName:
        userContact.value.firstName = newValue;
        break;
      case ContactCoreValueType.LastName:
        userContact.value.lastName = newValue;
        break;
      case ContactCoreValueType.Phone:
        userContact.value.phone = newValue;
        break;
      case ContactCoreValueType.Email:
        userContact.value.email = newValue;
        break;
      case ContactCoreValueType.Website:
        userContact.value.website = newValue;
        break;
    }
    print("Profile Controller New Value: " + newValue);
    _save();
  }

  // ^ Update User Profile Pic ^ //
  updateProfilePic(File image) async {
    var imgBytes = await image.readAsBytes();
    userContact.value.profilePic = imgBytes.toList();
    _save();
  }

  // ^ Step 1: In New Social Tile ^ //
  addSocialTileProvider(Contact_SocialTile_Provider provider) {
    currentTile.value.provider = provider;
  }

  // ^ Step 2: In New Social Tile ^ //
  addSocialTileInfo(String url, String username) {
    currentTile.value.url = url;
    currentTile.value.username = username;
  }

  // ^ Step 3: In New Social Tile ^ //
  addSocialTileSizePos(Contact_SocialTile_TileType tileType, int position) {
    currentTile.value.type = tileType;
    currentTile.value.position = position;
  }

  // ^ Add Social Tile Move to Next Step ^ //
  addSocialTileNextStep() {
    // @ First Step
    if (state.value == ProfileState.Viewing ||
        state.value == ProfileState.Editing) {
      state(ProfileState.AddingTileStepOne);
    }
    // @ Step 2
    else if (state.value == ProfileState.AddingTileStepOne) {
      if (currentTile.value.hasProvider()) {
        // Update State
        state(ProfileState.AddingTileStepTwo);
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
    else if (state.value == ProfileState.AddingTileStepTwo) {
      // Update State
      if (currentTile.value.hasUrl() && currentTile.value.hasUsername()) {
        state(ProfileState.AddingTileStepThree);
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
      if (currentTile.value.hasPosition() &&
          currentTile.value.hasType() &&
          state.value == ProfileState.AddingTileStepThree) {
        // Add Tile to Contact and Save
        userContact.value.socials.add(currentTile.value);
        _save();

        // Reset Current Tile
        currentTile(Contact_SocialTile());
      }
    }
  }

  // ^ Add Social Tile Move to Next Step ^ //
  addSocialTilePrevStep() {
    // First Step
    if (state.value == ProfileState.AddingTileStepOne) {
      state(ProfileState.Viewing);
    }
    // Step 2
    if (state.value == ProfileState.AddingTileStepTwo) {
      state(ProfileState.AddingTileStepOne);
    }
    // Step 3
    else if (state.value == ProfileState.AddingTileStepThree) {
      state(ProfileState.AddingTileStepTwo);
    }
    // Finish
    else {
      // Add Tile to Contact and Save
      userContact.value.socials.add(currentTile.value);
      _save();

      // Reset Current Tile
      currentTile(Contact_SocialTile());
    }
  }

  // ^ Save a Social Tile  ^ //
  saveSocialTile(Contact_SocialTile_Provider provider,
      Contact_SocialTile_TileType tileType,
      {int position = 0, String url = "", String username = ""}) {
    // Create Tile from Data
    var tile = new Contact_SocialTile();
    tile.provider = provider;
    tile.type = tileType;
    tile.position = position;
    tile.url = url;
    tile.username = username;

    // Add Tile to Contact and Save
    userContact.value.socials.add(tile);
    _save();
  }

  // ^ Edit a Social Tile ^ //
  editSocialTile(SocialEditType edit, dynamic data) {
    // TODO
  }

  // ^ Remove a Social Tile ^ //
  removeSocialTile(Contact_SocialTile tile) {
    // TODO
  }

  // @ Save Current Contact
  _save() {
    Get.find<DeviceService>().updateContact(userContact.value);
  }
}
