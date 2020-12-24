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
  final tiles = Get.find<DeviceService>().user.contact.socials.obs;

  // References
  bool _isEditing = false;
  ProfileController() {
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
    // Set Core Values
    Get.find<DeviceService>().saveContact();
    firstName.refresh();
    lastName.refresh();
    phone.refresh();
    lastName.refresh();
    email.refresh();
    website.refresh();
    profilePic.refresh();
    tiles.refresh();
    update();
  }

  // ^ Update User Profile Pic ^ //
  setPicture(File image) async {
    // Read Bytes from File into Ref
    var imgBytes = await image.readAsBytes();

    // Set Profile Pic
    profilePic(imgBytes.toList());
    saveChanges();
  }

  // ^ Save a Social Tile  ^ //
  saveSocialTile(Contact_SocialTile tile) {
    // Add Tile to Contact
    if (tiles.contains(tile)) {
      int index = tiles.indexOf(tile);
      tiles[index] = tile;
    } else {
      tiles.add(tile);
    }

    // Save Contact
    saveChanges();
  }

  // ^ Remove a Social Tile ^ //
  removeSocialTile(Contact_SocialTile tile) {
    if (tiles.contains(tile)) {
      tiles.remove(tile);
    }

    // Save Contact
    saveChanges();
  }
}
