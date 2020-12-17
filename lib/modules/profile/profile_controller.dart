import 'dart:io';

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
  final Contact userContact;
  final status = ProfileStatus.Viewing.obs;
  bool _isEditing = false;

  ProfileController(this.userContact);

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
  }

  // ^ Update a Value in User Contact ^ //
  editCoreValue(ContactCoreValueType type, String newValue) {
    if (_isEditing) {
      switch (type) {
        case ContactCoreValueType.FirstName:
          userContact.firstName = newValue;
          break;
        case ContactCoreValueType.LastName:
          userContact.lastName = newValue;
          break;
        case ContactCoreValueType.Phone:
          userContact.phone = newValue;
          break;
        case ContactCoreValueType.Email:
          userContact.email = newValue;
          break;
        case ContactCoreValueType.Website:
          userContact.website = newValue;
          break;
      }
    }
  }

  // ^ Update User Profile Pic ^ //
  updateProfilePic(File image) async {
    var imgBytes = await image.readAsBytes();
    userContact.profilePic = imgBytes.toList();
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
    userContact.socials.add(tile);
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
    // TODO
  }
}
