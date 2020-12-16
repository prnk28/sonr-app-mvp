import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ PeerStatus Enum ^ //
enum ProfileStatus {
  Viewing,
  Editing,
}

enum ContactCoreValueType {
  FirstName,
  LastName,
  Phone,
  Email,
  Website,
}

class PeerController extends GetxController {
  final Contact userContact;
  final status = ProfileStatus.Viewing.obs;
  bool _isEditing = false;

  PeerController(this.userContact);

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
  editProfilePic() {
    // TODO
  }

  // ^ Add a Social Tile ^ //
  addSocialTile() {
    // TODO
  }

  // ^ Edit a Social Tile ^ //
  editSocialTile() {
    // TODO
  }

  // ^ Remove a Social Tile ^ //
  removeSocialTile() {
    // TODO
  }
}
