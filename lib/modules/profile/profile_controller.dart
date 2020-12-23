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
  final firstName = "".obs;
  final lastName = "".obs;
  final phone = "".obs;
  final email = "".obs;
  final website = "".obs;
  final profilePic = List<int>().obs;
  final tiles = List<Contact_SocialTile>().obs;

  // References
  bool _isEditing = false;
  Contact _contact;
  ProfileController() {
    fetch();
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
  fetch() {
    // Check for Contact
    if (_contact == null) {
      _contact = Get.find<DeviceService>().user.contact;
    }

    // Set Core Values
    firstName(_contact.firstName);
    lastName(_contact.lastName);
    phone(_contact.phone);
    email(_contact.email);
    website(_contact.website);

    // Update Refresh Lists
    profilePic(_contact.profilePic);
    profilePic.refresh();
    tiles(_contact.socials);
    tiles.refresh();
    update();
  }

  // ^ Update User Profile Pic ^ //
  setPicture(File image) async {
    // Read Bytes from File into Ref
    var imgBytes = await image.readAsBytes();
    _contact.profilePic = imgBytes.toList();

    // Set Profile Pic
    profilePic(imgBytes.toList());
    profilePic.refresh();

    // Save Ref
    Get.find<DeviceService>().updateContact(_contact);
  }

  // ^ Save a Social Tile  ^ //
  saveSocialTile(Contact_SocialTile tile) {
    // Add Tile to Contact and Save
    tiles.add(tile);
    tiles.refresh();
    Get.find<DeviceService>().addSocial(tile);
    update();
  }

  // ^ Remove a Social Tile ^ //
  removeSocialTile(Contact_SocialTile tile) {
    tiles.remove(tile);
    tiles.refresh();
    Get.find<DeviceService>().removeSocial(tile);
    update();
  }
}
