import 'dart:io';
import 'package:sonr_app/service/device_service.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

// @ PeerStatus Enum
enum ProfileState { Viewing, Editing }

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
  final focusTileIndex = (-2).obs;

  // References
  bool _isEditing = false;
  bool _isExpanded = false;

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

  // ^ Update User Profile Pic ^ //
  setPicture(File image) async {
    // Read Bytes from File into Ref
    var imgBytes = await image.readAsBytes();

    // Set Profile Pic
    profilePic(imgBytes.toList());

    // Save Contact
    saveChanges();
  }

  // ^ Expand a Tile  ^ //
  toggleExpand(Contact_SocialTile tile) {
    _isExpanded = !_isExpanded;
    if (_isExpanded) {
      int idx = socials.indexOf(tile);
      focusTileIndex(idx);
    } else {
      focusTileIndex(-2);
    }
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
    SonrSnack.success("Added new ${tile.provider.toString()} tile");
  }

  // ^ Remove a Social Tile ^ //
  removeSocialTile(Contact_SocialTile tile) {
    if (socials.contains(tile)) {
      socials.remove(tile);
    }

    // Save Contact
    saveChanges();
  }

  // ^ Swap Positions of Two Tiles ^ //
  swapSocialTiles(Contact_SocialTile first, Contact_SocialTile second) {
    int idxOne = socials.indexOf(first);
    int idxTwo = socials.indexOf(second);
    socials.swap(idxOne, idxTwo);
    socials.refresh();
    saveChanges();
  }

  // ^ Save Changed Values to Storage ^ //
  saveChanges() {
    Get.find<DeviceService>().contact.value.firstName = firstName.value;
    Get.find<DeviceService>().contact.value.lastName = lastName.value;
    Get.find<DeviceService>().contact.value.phone = phone.value;
    Get.find<DeviceService>().contact.value.email = email.value;
    Get.find<DeviceService>().contact.value.website = website.value;
    Get.find<DeviceService>().contact.value.profilePic.clear();
    Get.find<DeviceService>().contact.value.profilePic = profilePic;

    // Update Socials
    Get.find<DeviceService>().contact.value.socials.clear();
    socials.forEach((s) {
      Get.find<DeviceService>().contact.value.socials.add(s);
    });
    Get.find<DeviceService>().contact.refresh();
    update();
  }
}

// @ Dart Util to Swap Indexes In List //
extension ListSwap<T> on List<T> {
  void swap(int index1, int index2) {
    var length = this.length;
    RangeError.checkValidIndex(index1, this, "index1", length);
    RangeError.checkValidIndex(index2, this, "index2", length);
    if (index1 != index2) {
      var tmp1 = this[index1];
      this[index1] = this[index2];
      this[index2] = tmp1;
    }
  }
}
