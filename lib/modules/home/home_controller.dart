// import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/service/sql_service.dart';
import 'package:flutter/services.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';
import '../media/camera_view.dart';
import '../media/picker_sheet.dart';

enum ToggleFilter { All, Media, Contact, Links }
const K_ALLOWED_FILE_TYPES = ['pdf', 'doc', 'docx', 'ttf', 'mp3', 'xml', 'csv', 'key', 'ppt', 'pptx', 'xls', 'xlsm', 'xlsx', 'rtf', 'txt'];

class HomeController extends GetxController {
  // Properties
  final allCards = <TransferCard>[].obs;
  final contactCards = <TransferCard>[].obs;
  final mediaCards = <TransferCard>[].obs;

  // Widget Elements
  final isExpanded = false.obs;
  final pageIndex = 0.obs;

  final pageOffset = 0.0.obs;
  final toggleIndex = 0.obs;

  // References
  final pageController = PageController(viewportFraction: 0.8, keepPage: false);
  final category = Rx<ToggleFilter>(ToggleFilter.All);

  @override
  void onInit() {
    // Set PageController
    pageController.addListener(() {
      pageOffset(pageController.page);
    });

    // Fetch Data
    refreshCards();
    super.onInit();
  }

  // ^ Method Refreshes TransferCards ^ //
  Future<void> refreshCards() async {
    // Reset Cards
    allCards.clear();
    contactCards.clear();
    mediaCards.clear();

    // Fetch Data
    var data = await Get.find<SQLService>().fetchAll();

    // Iterate Data
    data.forEach((c) {
      // Add to All
      allCards.add(c);

      // Check Type
      if (c.payload == Payload.MEDIA) {
        mediaCards.add(c);
      } else if (c.payload == Payload.CONTACT) {
        contactCards.add(c);
      }
    });

    // Refresh Cards
    allCards.refresh();
    mediaCards.refresh();
    contactCards.refresh();
  }

  // ^ Helper Method for Category Filter ^ //
  SonrText getToggleCategory() {
    // Haptic Feedback
    HapticFeedback.mediumImpact();

    // Change Category
    if (toggleIndex.value == 0) {
      category(ToggleFilter.All);
      return SonrText.medium("All");
    } else if (toggleIndex.value == 1) {
      category(ToggleFilter.Media);
      return SonrText.medium("Media");
    } else if (toggleIndex.value == 2) {
      category(ToggleFilter.Media);
      return SonrText.medium("Contacts");
    } else {
      category(ToggleFilter.Links);
      return SonrText.medium("Links");
    }
  }

  // ^ Method for Returning Current Card List ^ //
  List<TransferCard> getCardList() {
    if (toggleIndex.value == 1) {
      return mediaCards;
    } else if (toggleIndex.value == 2) {
      return contactCards;
    } else {
      return allCards;
    }
  }

  // ^ Method for Setting Category Filter ^ //
  setToggleCategory(int index) {
    toggleIndex(index);

    // Haptic Feedback
    HapticFeedback.mediumImpact();

    // Change Category
    pageController.animateToPage(0, duration: 650.milliseconds, curve: Curves.bounceOut);
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

  // ^ Finds Index of Card and Scrolls to It ^ //
  void jumpToCard(TransferCard card) async {
    // Get Index
    var index = allCards.indexWhere((c) => c.id == card.id);

    // Validate Index
    if (index != -1) {
      // Pop View
      Get.back();

      // Jump to Page
      pageController.animateToPage(index, duration: 650.milliseconds, curve: Curves.bounceOut);
    } else {
      SonrSnack.error("Error finding the suggested card.");
    }
  }

  // ^ Opens Camera Picker ^ //
  void openCamera() async {
    // Check for Permssions
    if (await Permission.camera.request().isGranted) {
      // Toggle Share Expand
      toggleShareExpand(options: ToggleForced(false));

      // Show Picker
      Get.dialog(CameraView(), useSafeArea: false);
    } else {
      // Display Error
      SonrSnack.error("Sonr isnt permitted to access your media.");
    }
  }

  // ^ Opens Media Picker UI ^ //
  void openMediaPicker() async {
    // Check for Permssions
    if (await Permission.photos.request().isGranted) {
      // Toggle Share Expand
      toggleShareExpand(options: ToggleForced(true));

      // Display Bottom Sheet
      Get.bottomSheet(MediaSheet(), isDismissible: false);
    } else {
      // Display Error
      SonrSnack.error("Sonr isnt permitted to access your media.");
    }
  }

  // ^ Queues a Contact for Transfer ^ //
  void queueContact() {
    Get.find<SonrService>().setPayload(Payload.CONTACT);

    // Close Share Button
    Get.find<HomeController>().toggleShareExpand();

    // Go to Transfer
    Get.offNamed("/transfer");
  }

  // ^ Adds a Card to Screen ^ //
  void addCard(TransferCard card) {
    // Add to All Cards
    allCards.add(card);
    allCards.refresh();

    // Update Toggle
    setToggleCategory(0);

    // Shift to Item
    pageController.animateToPage(allCards.length - 1, duration: 800.milliseconds, curve: Curves.bounceIn);
  }
}

class ToggleForced {
  final bool value;
  ToggleForced(this.value);
}
