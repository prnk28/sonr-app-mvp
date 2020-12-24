import 'dart:io';
import 'package:sonar_app/service/device_service.dart';
import 'package:get/get.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

// @ PeerStatus Enum
enum ProfileState {
  Viewing,
  Editing,
}

class ProfileController extends GetxController {
  // Properties
  final state = ProfileState.Viewing.obs;
  final firstName = Get.find<DeviceService>().user.contact.firstName.obs;
  final lastName = Get.find<DeviceService>().user.contact.lastName.obs;
  final phone = Get.find<DeviceService>().user.contact.phone.obs;
  final email = Get.find<DeviceService>().user.contact.email.obs;
  final website = Get.find<DeviceService>().user.contact.website.obs;
  final profilePic = Get.find<DeviceService>().user.contact.profilePic.obs;
  final socials = Get.find<DeviceService>().user.contact.socials.obs;
  var tiles;

  // References
  bool _isEditing = false;
  ProfileController() {
    tiles = socials;
    refresh();
  }

  // ^ Toggle Editing Mode ^ //
  toggleEditing() {
    _isEditing = !_isEditing;
    if (_isEditing) {
      state(ProfileState.Editing);
    } else {
      state(ProfileState.Viewing);
    }
  }

  // ^ Fetch Values ^ //
  saveChanges() {
    Get.find<DeviceService>().contact.value.firstName = firstName.value;
    Get.find<DeviceService>().contact.value.lastName = lastName.value;
    Get.find<DeviceService>().contact.value.phone = phone.value;
    Get.find<DeviceService>().contact.value.email = email.value;
    Get.find<DeviceService>().contact.value.website = website.value;
    Get.find<DeviceService>().contact.value.profilePic.clear();
    Get.find<DeviceService>().contact.value.profilePic = profilePic.toList();
    Get.find<DeviceService>().contact.value.socials.clear();
    Get.find<DeviceService>().contact.value.socials.addAll(socials.toList());
    Get.find<DeviceService>().contact.refresh();
    update();
  }

  // ^ Update User Profile Pic ^ //
  setPicture(File image) async {
    // Read Bytes from File into Ref
    var imgBytes = await image.readAsBytes();

    // Set Profile Pic
    profilePic(imgBytes.toList());

    // Save Contact
    saveChanges();
  }

  // ^ Save a Social Tile  ^ //
  saveSocialTile(Contact_SocialTile tile) {
    // Add Tile to Contact
    if (socials.any((t) => t.provider == tile.provider)) {
      int index = socials.indexOf(tile);
      socials[index] = tile;
    } else {
      socials.add(tile);
    }

    // Save Contact
    saveChanges();
  }

  // ^ Remove a Social Tile ^ //
  removeSocialTile(Contact_SocialTile tile) {
    if (socials.contains(tile)) {
      socials.remove(tile);
    }

    // Save Contact
    saveChanges();
  }
}
