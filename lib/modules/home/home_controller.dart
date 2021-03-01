import 'dart:async';

import 'package:sonr_app/data/constants.dart';
import 'package:sonr_app/theme/theme.dart';

enum ToggleFilter { All, Media, Contact, Links }
enum HomeState { Loading, Ready, None, New, First }
const K_ALLOWED_FILE_TYPES = ['pdf', 'doc', 'docx', 'ttf', 'mp3', 'xml', 'csv', 'key', 'ppt', 'pptx', 'xls', 'xlsm', 'xlsx', 'rtf', 'txt'];

class HomeController extends GetxController {
  // Properties
  final cards = RxList<TransferCard>(Get.find<SQLService>().cards);
  final status = Rx<HomeState>();
  final category = Rx<ToggleFilter>(ToggleFilter.All);

  // Widget Elements
  final isShareExpanded = false.obs;
  final pageIndex = 0.obs;
  final toggleIndex = 0.obs;

  // References
  PageController pageController;
  StreamSubscription<List<TransferCard>> cardStream;

  // ^ Controller Constructer ^
  onInit() {
    // Add Stream Handlers
    cardStream = Get.find<SQLService>().cards.stream.listen(_handleCardStream);

    // Set Initial Status
    if (cards.length > 0) {
      status(HomeState.Ready);
    } else {
      if (UserService.isNewUser.value) {
        status(HomeState.First);
        SonrService.connect();
      } else {
        status(HomeState.None);
      }
    }
    super.onInit();
  }

  // ^ On Dispose ^ //
  void onDispose() {
    cardStream.cancel();
  }

  // ^ Handle Cards Update ^ //
  _handleCardStream(List<TransferCard> onData) {
    status(HomeState.Loading);
    if (onData.length > 0) {
      // Check if Card Added
      if (onData.length > cards.length) {
        cards(onData);
        cards.length == 1 ? status(HomeState.Ready) : status(HomeState.New);
      }
      // Set Cards
      else {
        cards(onData);
        status(HomeState.Ready);
      }
    }
    // No Cards Available
    else {
      status(HomeState.None);
    }
  }

  // ^ Helper Method for Category Filter ^ //
  Widget getToggleCategory() {
    // Change Category
    if (toggleIndex.value == 0) {
      category(ToggleFilter.All);
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SonrIcon.gradient(SonrIconData.all_categories, FlutterGradientNames.premiumDark, size: 22, color: Colors.black.withOpacity(0.7)),
        Padding(padding: EdgeInsets.all(6)),
        SonrText.medium("All", size: 16),
      ]);
    } else if (toggleIndex.value == 1) {
      category(ToggleFilter.Media);
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SonrIcon.gradient(SonrIconData.media, FlutterGradientNames.premiumDark, size: 20, color: Colors.black.withOpacity(0.7)),
        SonrText.medium("Media", size: 16),
      ]);
    } else if (toggleIndex.value == 2) {
      category(ToggleFilter.Media);
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SonrIcon.gradient(SonrIconData.friends, FlutterGradientNames.premiumDark, size: 18, color: Colors.black.withOpacity(0.7)),
        SonrText.medium("Friends", size: 16),
      ]);
    } else {
      category(ToggleFilter.Links);
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SonrIcon.gradient(SonrIconData.url, FlutterGradientNames.premiumDark, size: 22, color: Colors.black.withOpacity(0.7)),
        SonrText.medium("Links", size: 16),
      ]);
    }
  }

  // ^ Method for Returning Current Card List ^ //
  List<TransferCard> getCardList() {
    if (status.value != HomeState.None) {
      if (toggleIndex.value == 1) {
        return Get.find<SQLService>().media;
      } else if (toggleIndex.value == 2) {
        return Get.find<SQLService>().contacts;
      } else {
        return Get.find<SQLService>().cards;
      }
    } else {
      return [];
    }
  }

  // ^ Method for Setting Category Filter ^ //
  setToggleCategory(int index) {
    toggleIndex(index);

    // Haptic Feedback
    HapticFeedback.mediumImpact();

    // Change Category
    if (status.value == HomeState.Ready) {
      pageController.animateToPage(0, duration: 650.milliseconds, curve: Curves.bounceOut);
    }
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
