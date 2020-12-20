import 'dart:io';
import 'package:sonar_app/service/device_service.dart';
import 'package:get/get.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

// @ PeerStatus Enum
enum ProfileStatus {
  Viewing,
  Editing,
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
  final status = ProfileStatus.Viewing.obs;
  bool _isEditing = false;

  ProfileController() {
    var contact = Get.find<DeviceService>().user.contact;
    userContact(contact);
  }

  // ^ Toggle Editing Mode ^ //
  toggleEditing() {
    // Toggle Bool
    _isEditing = !_isEditing;

    // Check Bool
    if (_isEditing) {
      status(ProfileStatus.Editing);
    } else {
      status(ProfileStatus.Viewing);
    }
    print("Profile Controller Status: " + status().toString());
  }

  // ^ Update a Value in User Contact ^ //
  editCoreValue(ContactCoreValueType type, String newValue) {
    if (_isEditing) {
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
  }

  // ^ Update User Profile Pic ^ //
  updateProfilePic(File image) async {
    var imgBytes = await image.readAsBytes();
    userContact.value.profilePic = imgBytes.toList();
    _save();
  }

  // ^ Add a Social Tile ^ //
  addSocialTile(Contact_SocialTile_Provider provider,
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
    if (_isEditing) {
      Get.find<DeviceService>().updateContact(userContact.value);
    }
  }
}
