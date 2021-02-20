import 'package:sonr_app/service/constant_service.dart';
import 'package:sonr_app/theme/theme.dart';

enum ToggleFilter { All, Media, Contact, Links }
const K_ALLOWED_FILE_TYPES = ['pdf', 'doc', 'docx', 'ttf', 'mp3', 'xml', 'csv', 'key', 'ppt', 'pptx', 'xls', 'xlsm', 'xlsx', 'rtf', 'txt'];

class HomeController extends GetxController {
  // Properties
  final cards = RxList<TransferCard>(Get.find<SQLService>().cards);

  // Widget Elements
  final isShareExpanded = false.obs;
  final pageIndex = 0.obs;
  final toggleIndex = 0.obs;

  // References
  PageController pageController;
  final category = Rx<ToggleFilter>(ToggleFilter.All);

  onInit() {
    if (!SonrService.connected.value) {
      SonrService.connect();
    }

    super.onInit();
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
      return Get.find<SQLService>().media;
    } else if (toggleIndex.value == 2) {
      return Get.find<SQLService>().contacts;
    } else {
      return Get.find<SQLService>().cards;
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
    var index = cards.indexWhere((c) => c.id == card.id);

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
}
