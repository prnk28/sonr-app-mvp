// import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/service/sql_service.dart';
import 'package:flutter/services.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

enum ToggleFilter { All, Media, Contact, Links }
const K_ALLOWED_FILE_TYPES = ['pdf', 'doc', 'docx', 'ttf', 'mp3', 'xml', 'csv', 'key', 'ppt', 'pptx', 'xls', 'xlsm', 'xlsx', 'rtf', 'txt'];

class HomeController extends GetxController {
  // Properties
  final allCards = <TransferCard>[].obs;
  final contactCards = <TransferCard>[].obs;
  final mediaCards = <TransferCard>[].obs;

  // Widget Elements
  final isShareExpanded = false.obs;
  final pageIndex = 0.obs;
  final toggleIndex = 0.obs;

  // References
  PageController pageController;
  final category = Rx<ToggleFilter>(ToggleFilter.All);

  @override
  void onInit() {
    // Fetch Data
    refreshCards();
    super.onInit();
  }

  // ^ Method Refreshes TransferCards ^ //
  Future<void> refreshCards({bool jumpToLatest = false}) async {
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

    // Check for Jump
    if (jumpToLatest) {
      pageController.animateToPage(allCards.length - 1, duration: 650.milliseconds, curve: Curves.bounceOut);
    }
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

  // ^ Close Share Button ^ //
  void closeShare() {
    HapticFeedback.heavyImpact();
    isShareExpanded(false);
  }

  // ^ Expand Share Button ^ //
  void expandShare() {
    HapticFeedback.heavyImpact();
    isShareExpanded(true);
  }

  // ^ Toggles Expanded Share Button ^ //
  void toggleShare() {
    HapticFeedback.heavyImpact();
    isShareExpanded(!isShareExpanded.value);
  }

  // ^ Opens Camera Picker ^ //
  void presentCamera() async {
    // Check for Permssions
    if (await Permission.camera.request().isGranted) {
      // Toggle Share Expand
      closeShare();

      // Go to Camera View
      Get.offNamed("/camera");
    } else {
      // Display Error
      SonrSnack.error("Sonr isnt permitted to access your media.");
    }
  }

  // ^ Opens Media Picker UI ^ //
  void presentMediaPicker() async {
    // Check for Permssions
    if (await Permission.photos.request().isGranted) {
      // Toggle Share Expand
      closeShare();

      // Display Bottom Sheet
      //Get.bottomSheet(PickerSheet(), isDismissible: false);
    } else {
      // Display Error
      SonrSnack.error("Sonr isnt permitted to access your media.");
    }
  }

  // ^ Queues a Contact for Transfer ^ //
  void queueContact() {
    Get.find<SonrService>().setPayload(Payload.CONTACT);

    // Close Share Button
    closeShare();

    // Go to Transfer
    Get.offNamed("/transfer");
  }
}
