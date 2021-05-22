export 'editor/add_social.dart';
export 'editor/edit_details.dart';
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

// @ PeerStatus Enum
enum ProfileViewStatus { Viewing, EditDetails, AddSocial, AddPicture, ViewPicture, NeedCameraPermissions }

extension ProfileViewStatusUtils on ProfileViewStatus {
  bool get isEditing => this == ProfileViewStatus.EditDetails;
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
  final pageController = PageController();
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

  /// @ Start Editing for Social Tile
  void setAddTile() {
    HapticFeedback.heavyImpact();
    // step(TileStep(nextStep, previousStep, saveTile));
    status(ProfileViewStatus.AddSocial);
  }

  /// @ Start Editing for Details
  void setEditingMode() {
    HapticFeedback.heavyImpact();
    status(ProfileViewStatus.EditDetails);
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

  // // -- Set Privacy -- //
  // isPrivate(bool value) {
  //   step.update((val) {
  //     val!.isPrivate = value;
  //   });
  //   step.refresh();
  // }

  // // -- Set Current Provider -- //
  // provider(int index) {
  //   step.update((val) {
  //     val!.provider = options[index];
  //   });
  //   step.refresh();
  // }

  // // -- Set Tile Type -- //
  // type(Contact_Social_Tile type) {
  //   step.update((val) {
  //     val!.type = type;
  //   });
  //   step.refresh();
  // }

  // // -- Set Social User -- //
  // user(Contact_Social user) {
  //   step.update((val) {
  //     val!.user = user;
  //   });
  //   step.refresh();
  // }

  // /// @ Add Social Tile Move to Next Step
  // nextStep() async {
  //   // @ Step 2
  //   if (step.value!.current == 0) {
  //     if (dropdownIndex.value != -1) {
  //       provider(dropdownIndex.value);
  //       step.update((val) {
  //         val!.current = 1;
  //         pageController.nextPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
  //       });
  //       step.refresh();
  //     } else {
  //       // Display Error Snackbar
  //       SonrSnack.missing("Select a provider first");
  //     }
  //   }
  //   // @ Step 3
  //   else if (step.value!.current == 1) {
  //     // Update State
  //     if (step.value!.hasUser) {
  //       step.update((val) {
  //         val!.current = 2;
  //         pageController.nextPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
  //       });
  //       step.refresh();

  //       FocusScopeNode currentFocus = FocusScope.of(Get.context!);
  //       if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
  //         FocusManager.instance.primaryFocus!.unfocus();
  //       }
  //     }
  //   } else {
  //     // Display Error Snackbar
  //     SonrSnack.missing("Add your username or Link your account");
  //   }
  // }

  // /// @ Add Social Tile Move to Next Step
  // previousStep() {
  //   // Step 2
  //   if (step.value!.current == 1) {
  //     step.update((val) {
  //       val!.current = 0;
  //       pageController.previousPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
  //     });
  //     step.refresh();
  //   }
  //   // Step 3
  //   else if (step.value!.current == 2) {
  //     step.update((val) {
  //       val!.current = 1;
  //       pageController.previousPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
  //     });
  //     step.refresh();
  //   }
  // }

  // /// @ Finish and Save new Tile
  // saveTile() {
  //   // Validate
  //   if (step.value!.hasType && step.value!.current == 2) {
  //     // Create Tile from Values
  //     var tile = Contact_Social(
  //       username: step.value!.user!,
  //       media: step.value!.provider,

  //     );

  //     // Save to Profile
  //     UserService.contact.addSocial(tile);

  //     // Revert Status
  //     status(ProfileViewStatus.Viewing);
  //     reset();
  //   } else {
  //     // Display Error Snackbar
  //     SonrSnack.missing("Pick a Tile Type", isLast: true);
  //   }
  // }

  // /// @ Resets current info
  // reset() {
  //   step(TileStep(nextStep, previousStep, saveTile));
  //   step.refresh();
  // }

  // /// @ Expand a Tile
  // toggleExpand(int index, bool isExpanded) {
  //   focused(FocusedTile(index, isExpanded));
  //   update(['social-grid']);
  // }

  // @ Method to Request Camera Permissions
  requestCamera() async {
    if (DeviceService.isMobile) {
      var granted = await Permission.camera.request().isGranted;
      Get.find<MobileService>().updatePermissionsStatus();
      status(ProfileViewStatusUtils.statusFromPermissions(granted));
    }
  }
}
