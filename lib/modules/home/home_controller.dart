import 'dart:async';
import 'package:sonr_app/data/core/arguments.dart';
import 'package:sonr_app/theme/theme.dart';

enum ToggleFilter { All, Media, Contact, Links }
enum HomeState { Loading, Ready, None, New, First }
const K_ALLOWED_FILE_TYPES = ['pdf', 'doc', 'docx', 'ttf', 'mp3', 'xml', 'csv', 'key', 'ppt', 'pptx', 'xls', 'xlsm', 'xlsx', 'rtf', 'txt'];

class HomeController extends GetxController {
  // Properties
  final cards = RxList<TransferCard>(Get.find<SQLService>().cards);
  final status = Rx<HomeState>();
  final category = Rx<ToggleFilter>(ToggleFilter.All);

  // Elements
  final titleText = "Home".obs;
  final pageIndex = 0.obs;
  final toggleIndex = 1.obs;
  final bottomIndex = 0.obs;
  final lastPage = BottomNavButton.Grid.obs;
  final page = BottomNavButton.Grid.obs;

  // References
  StreamSubscription<List<TransferCard>> cardStream;

  // Conditional
  bool _hasPromptedAutoSave = false;

  HomeController();

  // ^ Controller Constructer ^
  onInit() {
    // Set View Properties
    toggleIndex(1);
    pageIndex(0);
    super.onInit();

    // Initialize
    HomeArguments args = Get.arguments;
    if (args.isFirstLoad) {
      MediaService.checkInitialShare();
    }
  }

  @override
  void onReady() {
    // Add Stream Handlers
    cardStream = Get.find<SQLService>().cards.listen(_handleCardStream);

    // Set Initial Status
    if (cards.length > 0) {
      status(HomeState.Ready);
    } else {
      if (UserService.isNewUser.value) {
        status(HomeState.First);
      } else {
        status(HomeState.None);
      }
    }
    super.onReady();
  }

  // ^ On Dispose ^ //
  @override
  void onClose() {
    cardStream.cancel();

    toggleIndex(1);
    pageIndex(0);
    super.onClose();
  }

  // ^ Handle Cards Update ^ //
  _handleCardStream(List<TransferCard> onData) {
    status(HomeState.Loading);
    if (onData.length > 0) {
      // Check if Card Added
      if (onData.length > cards.length) {
        cards(onData);
        cards.length == 1 ? status(HomeState.Ready) : status(HomeState.New);
        cards.refresh();
      }
      // Set Cards
      else {
        cards(onData);
        status(HomeState.Ready);
        cards.refresh();
      }
    }
    // No Cards Available
    else {
      status(HomeState.None);
    }
  }

  AnimSwitch getSwitcherAnimation() {
    switch (page.value) {
      case BottomNavButton.Grid:
        if (lastPage.value == BottomNavButton.Profile) {
          lastPage(page.value);
          return AnimSwitch.SlideUp;
        } else if (lastPage.value == BottomNavButton.Remote) {
          lastPage(page.value);
          return AnimSwitch.SlideDown;
        } else {
          lastPage(page.value);
          return AnimSwitch.SlideLeft;
        }
        break;
      case BottomNavButton.Profile:
        lastPage(page.value);
        return AnimSwitch.SlideDown;
        break;
      case BottomNavButton.Alerts:
        lastPage(page.value);
        return AnimSwitch.SlideRight;
        break;
      case BottomNavButton.Remote:
        lastPage(page.value);
        return AnimSwitch.SlideUp;
        break;
      default:
        lastPage(page.value);
        return AnimSwitch.SlideLeft;
    }
  }

  // ^ Method for Returning Current Card List ^ //
  List<TransferCard> getCardList() {
    if (status.value != HomeState.None) {
      if (toggleIndex.value == 1) {
        return Get.find<SQLService>().cards;
      } else if (toggleIndex.value == 2) {
        return Get.find<SQLService>().contacts;
      } else {
        return Get.find<SQLService>().media;
      }
    } else {
      return [];
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
    } else {
      SonrSnack.error("Error finding the suggested card.");
    }
  }

  // ^ Prompts first time user Auto Save ^ //
  promptAutoSave() async {
    if (!_hasPromptedAutoSave && cards.length == 1) {
      Future.delayed(2400.milliseconds, () {
        if (UserService.isNewUser.value && !UserService.permissions.value.hasGallery && !SonrOverlay.isOpen) {
          Get.find<UserService>().requestGallery(
              description: "Next time Sonr can automatically save media files to your gallery but needs permission, would you like to enable?");
        }
      });
    }
  }

  // ^ Method for Setting Category Filter ^ //
  setToggleCategory(int index) {
    toggleIndex(index);
    category(ToggleFilter.values[index]);

    // Haptic Feedback
    HapticFeedback.mediumImpact();
  }

  // ^ Update Bottom Bar Index ^ //
  setBottomIndex(int newIndex) {
    bottomIndex(newIndex);
    if (newIndex == 1) {
      page(BottomNavButton.Profile);
    } else if (newIndex == 2) {
      page(BottomNavButton.Alerts);
    } else if (newIndex == 3) {
      page(BottomNavButton.Remote);
    } else {
      page(BottomNavButton.Grid);
    }
  }
}
