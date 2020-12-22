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
}

// @ Contact Value Enum
enum ContactCoreValueType {
  FirstName,
  LastName,
  Phone,
  Email,
  Website,
}

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
    Get.find<DeviceService>().updateContact(userContact.value);
  }

  // ^ Update User Profile Pic ^ //
  updateProfilePic(File image) async {
    var imgBytes = await image.readAsBytes();
    userContact.value.profilePic = imgBytes.toList();
    Get.find<DeviceService>().updateContact(userContact.value);
  }

  // ^ Save a Social Tile  ^ //
  saveSocialTile(Contact_SocialTile tile) {
    // Add Tile to Contact and Save
    userContact.value.socials.add(tile);
    Get.find<DeviceService>().updateContact(userContact.value);
  }

  // ^ Remove a Social Tile ^ //
  removeSocialTile(Contact_SocialTile tile) {
    userContact.value.socials.remove(tile);
    Get.find<DeviceService>().updateContact(userContact.value);
  }
}
