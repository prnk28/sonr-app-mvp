export 'add/add_social.dart';
export 'profile_controller.dart';
export 'profile_view.dart';
export 'fields/avatar_field.dart';

import 'dart:io';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/style/style.dart';
import 'package:get/get.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:sonr_app/data/data.dart';

import 'add/add_social.dart';

// @ PeerStatus Enum
enum ProfileViewStatus {
  Viewing,
  EditView,
  FieldName,
  FieldGender,
  FieldPhone,
  FieldAddresses,
  AddSocial,
  AddPicture,
  ViewPicture,
  NeedCameraPermissions
}

extension ProfileViewStatusUtils on ProfileViewStatus {
  bool get isEditing => this == ProfileViewStatus.EditView;
  bool get isViewing => this == ProfileViewStatus.Viewing;
  bool get isAddingPicture => this == ProfileViewStatus.AddPicture;
  bool get isAddingSocial => this == ProfileViewStatus.AddSocial;
  bool get hasPermissions => this != ProfileViewStatus.NeedCameraPermissions;
  bool get hasCaptured => this == ProfileViewStatus.ViewPicture;

  static ProfileViewStatus statusFromPermissions(bool val) {
    return val ? ProfileViewStatus.AddPicture : ProfileViewStatus.NeedCameraPermissions;
  }
}

class ProfileController extends GetxController {
  // Properties
  final status = ProfileViewStatus.Viewing.obs;
  // final focused = FocusedTile(-1, false).obs;
  final options = Contact_Social_Media.values;
  final dropdownIndex = (-1).obs;

  // Edited Values
  final editedFirstName = RxString(UserService.contact.value.firstName);
  final editedLastName = RxString(UserService.contact.value.lastName);
  final editedPhone = RxString("");

  // Tile Management
  // final step = Rx<TileStep?>(null);
  final cardSelection = ValueNotifier<int>(0);

  // Notifiers
  ValueNotifier<CaptureModes> captureMode = ValueNotifier(CaptureModes.PHOTO);
  ValueNotifier<Size> photoSize = ValueNotifier(Size(142, 142));
  ValueNotifier<Sensors> sensor = ValueNotifier(Sensors.FRONT);

  // Properties
  final result = Rx<File?>(null);

  // References
  late final PictureController _pictureController;

  // ** Initialize Method ** //
  onInit() async {
    _pictureController = PictureController();
    super.onInit();
  }

  /// @ Method to Capture Picture
  captureAvatar() async {
    // Set Path
    var temp = await getApplicationDocumentsDirectory();
    var photoDir = await Directory('${temp.path}/photos').create(recursive: true);
    var path = '${photoDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Capture Photo
    await _pictureController.takePicture(path);
    result(File(path));
    status(ProfileViewStatus.ViewPicture);
  }

  /// @ Method to Confirm New Picture
  confirmAvatar() async {
    if (result.value != null) {
      UserService.contact.setPicture(result.value!.readAsBytesSync());
    }
    exitToViewing();
  }

  /// @ Start Editing Picture
  void setAddPicture() {
    HapticFeedback.heavyImpact();
    status(ProfileViewStatus.AddPicture);
  }

  void shiftScreen(ContactOptions option) {
    switch (option) {
      case ContactOptions.Names:
        HapticFeedback.heavyImpact();
        status(ProfileViewStatus.FieldName);
        break;
      case ContactOptions.Addresses:
        HapticFeedback.heavyImpact();
        status(ProfileViewStatus.FieldAddresses);
        break;
      case ContactOptions.Gender:
        HapticFeedback.heavyImpact();
        status(ProfileViewStatus.FieldGender);
        break;
    }
  }

  /// @ Start Editing for Social Tile
  void setAddTile() {
    HapticFeedback.heavyImpact();
    // step(TileStep(nextStep, previousStep, saveTile));
    Get.dialog(AddTileView(), barrierDismissible: false);
  }

  /// @ Start Editing for Details
  void setEditingMode() {
    HapticFeedback.heavyImpact();
    status(ProfileViewStatus.EditView);
  }

  /// @ End Add/Edit State
  void exitToViewing() {
    HapticFeedback.mediumImpact();
    status(ProfileViewStatus.Viewing);
  }

  /// @ Completed Editing Details
  void saveEditedDetails() {
    // Update Values in Profile Controller
    UserService.contact.setFirstName(editedFirstName.value);
    UserService.contact.setLastName(editedLastName.value);
    UserService.contact.addPhone(editedPhone.value);
    status(ProfileViewStatus.Viewing);
  }

  // @ Method to Request Camera Permissions
  requestCamera() async {
    if (DeviceService.isMobile) {
      var granted = await Permission.camera.request().isGranted;
      Get.find<MobileService>().updatePermissionsStatus();
      status(ProfileViewStatusUtils.statusFromPermissions(granted));
    }
  }
}
