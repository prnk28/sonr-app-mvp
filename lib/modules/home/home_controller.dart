// import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/model_card.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/service/sql_service.dart';
import 'package:flutter/services.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';
import 'camera_picker.dart';
import 'media_picker.dart';

enum ToggleFilter { All, Media, Contact, Links }
const K_ALLOWED_FILE_TYPES = ['pdf', 'doc', 'docx', 'ttf', 'mp3', 'xml', 'csv', 'key', 'ppt', 'pptx', 'xls', 'xlsm', 'xlsx', 'rtf', 'txt'];

class HomeController extends GetxController {
  // Properties
  final cards = <CardModel>[].obs;
  final allCards = <CardModel>[].obs;

  // Widget Elements
  final isExpanded = false.obs;
  final pageIndex = 0.obs;
  final toggleIndex = 0.obs;

  // References
  final category = Rx<ToggleFilter>(ToggleFilter.All);

  @override
  void onInit() {
    // Fetch File Data
    Get.find<SQLService>().fetchFiles().then((data) {
      data.forEach((m) => allCards.add(CardModel.fromMetaSQL(m)));
    });

    // Fetch Contact Data
    Get.find<SQLService>().fetchContacts().then((data) {
      data.forEach((c) => allCards.add(CardModel.fromContactSQL(c)));
    });

    // Refresh Cards
    allCards.refresh();
    super.onInit();
  }

  // ^ Helper Method for Category Filter ^ //
  SonrText getToggleCategory() {
    // Haptic Feedback
    HapticFeedback.mediumImpact();

    // Change Category
    if (toggleIndex.value == 0) {
      category(ToggleFilter.All);
      return SonrText.normal("All");
    } else if (toggleIndex.value == 1) {
      category(ToggleFilter.Media);
      return SonrText.normal("Media");
    } else if (toggleIndex.value == 2) {
      category(ToggleFilter.Media);
      return SonrText.normal("Contacts");
    } else {
      category(ToggleFilter.Links);
      return SonrText.normal("Links");
    }
  }

  // ^ Toggles Expanded Share Button ^ //
  void toggleShareExpand({ToggleForced options}) {
    // Force Toggle
    if (options != null) {
      // Toggle Options
      HapticFeedback.heavyImpact();
      isExpanded(options.value);
    } else {
      // Toggle
      HapticFeedback.heavyImpact();
      isExpanded(!isExpanded.value);
    }
  }

  // ^ Opens Camera Picker ^ //
  void openCamera() async {
    // Check for Permssions
    Get.find<DeviceService>().requestPermission(PermissionType.Camera).then((result) {
      if (result) {
        // Toggle Share Expand
        toggleShareExpand(options: ToggleForced(false));

        // Show Picker
        Get.dialog(CameraPicker());
      } else {
        // Display Error
        SonrSnack.error("Sonr isnt permitted to access your media.");
      }
    });
  }

  // ^ Opens File Picker UI ^ //
  void openFilePicker() async {
    // // Await for Picker
    // FilePickerResult result = await FilePicker.platform.pickFiles(
    //     type: FileType.custom, allowedExtensions: K_ALLOWED_FILE_TYPES);

    // // Get File
    // if (result != null) {
    //   File file = File(result.files.single.path);
    // }
  }

  // ^ Opens Media Picker UI ^ //
  void openMediaPicker() async {
    // Check for Permssions
    Get.find<DeviceService>().requestPermission(PermissionType.Gallery).then((result) {
      if (result) {
        // Toggle Share Expand
        toggleShareExpand(options: ToggleForced(true));

        // Display Bottom Sheet
        Get.bottomSheet(MediaPicker(), isDismissible: false);
      } else {
        // Display Error
        SonrSnack.error("Sonr isnt permitted to access your media.");
      }
    });
  }

  // ^ Queues a Contact for Transfer ^ //
  void queueContact() {
    Get.find<SonrService>().process(Payload.CONTACT);

    // Close Share Button
    Get.find<HomeController>().toggleShareExpand();

    // Go to Transfer
    Get.offNamed("/transfer");
  }

  // ^ Adds a Card to Screen ^ //
  void addCard(CardModel card) {
    allCards.add(card);
    allCards.refresh();
  }

  // ^ Opens Card with Hero ^ //
  void openCard(CardModel card) {
    // TODO
  }
}

class ToggleForced {
  final bool value;
  ToggleForced(this.value);
}
