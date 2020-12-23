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
  final state = ProfileState.Viewing.obs;
  final firstName = "".obs;
  final lastName = "".obs;
  final phone = "".obs;
  final email = "".obs;
  final website = "".obs;
  final tiles = List<Contact_SocialTile>().obs;

  ProfileController() {
    var result = Get.find<DeviceService>().user.contact;
    contact(result);
    tiles(result.socials);
  }

  // ^ Update a Value in User Contact ^ //
  editCoreValue(ContactCoreValueType type, String newValue) {
    switch (type) {
      case ContactCoreValueType.FirstName:
        contact.value.firstName = newValue;
        break;
      case ContactCoreValueType.LastName:
        contact.value.lastName = newValue;
        break;
      case ContactCoreValueType.Phone:
        contact.value.phone = newValue;
        break;
      case ContactCoreValueType.Email:
        contact.value.email = newValue;
        break;
      case ContactCoreValueType.Website:
        contact.value.website = newValue;
        break;
    }
    print("Profile Controller New Value: " + newValue);
    Get.find<DeviceService>().updateContact(contact.value);
  }

  // ^ Update User Profile Pic ^ //
  updateProfilePic(File image) async {
    var imgBytes = await image.readAsBytes();
    contact.value.profilePic = imgBytes.toList();
    Get.find<DeviceService>().updateContact(contact.value);
  }

  // ^ Save a Social Tile  ^ //
  saveSocialTile(Contact_SocialTile tile) {
    // Add Tile to Contact and Save
    tiles.add(tile);
    Get.find<DeviceService>().addSocial(tile);
  }

  // ^ Remove a Social Tile ^ //
  removeSocialTile(Contact_SocialTile tile) {
    tiles.remove(tile);
    Get.find<DeviceService>().removeSocial(tile);
  }
}
