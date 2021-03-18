import 'dart:async';

import 'package:sonr_app/theme/theme.dart';

import 'home_binding.dart';

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

  // References
  PageController pageController;
  StreamSubscription<List<TransferCard>> cardStream;
  StreamSubscription<int> lobbySizeStream;

  // Conditional
  bool _hasPromptedAutoSave = false;
  int _lobbySizeRef = 0;
  bool _timeoutActive = false;

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
    lobbySizeStream = SonrService.lobbySize.listen(_handleLobbySizeStream);

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
  void onDispose() {
    cardStream.cancel();
    lobbySizeStream.cancel();

    toggleIndex(1);
    pageIndex(0);
  }

  // ^ Handle Cards Update ^ //
  _handleCardStream(List<TransferCard> onData) {
    status(HomeState.Loading);
    if (onData.length > 0) {
      // Check if Card Added
      if (onData.length > cards.length) {
        cards(onData);
        cards.length == 1 ? status(HomeState.Ready) : status(HomeState.New);

        // Check Status
        if (status.value == HomeState.New) {
          pageController.animateToPage(0, duration: 650.milliseconds, curve: Curves.bounceOut);
        }
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

  // ^ Handle Cards Update ^ //
  _handleLobbySizeStream(int onData) {
    if (onData > _lobbySizeRef) {
      var diff = onData - _lobbySizeRef;
      swapTitleText("$diff Joined");
    } else if (onData < _lobbySizeRef) {
      var diff = _lobbySizeRef - onData;
      swapTitleText("$diff Left");
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

      // Jump to Page
      pageController.animateToPage(index, duration: 650.milliseconds, curve: Curves.bounceOut);
    } else {
      SonrSnack.error("Error finding the suggested card.");
    }
  }

  // ^ Finds Index of Card and Scrolls to It ^ //
  void jumpToStart() async {
    if (status.value != HomeState.None) {
      pageController.animateToPage(0, duration: 650.milliseconds, curve: Curves.bounceOut);
    }
  }

  // ^ Finds Index of Card and Scrolls to It ^ //
  void jumpToEnd() async {
    if (status.value != HomeState.None) {
      pageController.animateToPage(cards.length - 1, duration: 650.milliseconds, curve: Curves.bounceOut);
    }
  }

  // ^ Prompts first time user Auto Save ^ //
  promptAutoSave() async {
    if (!_hasPromptedAutoSave && cards.length == 1) {
      Future.delayed(2400.milliseconds, () {
        if (UserService.isNewUser.value && !Get.find<DeviceService>().galleryPermitted.val && !SonrOverlay.isOpen) {
          Get.find<DeviceService>().requestGallery(
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

    // Change Category
    if (status.value == HomeState.Ready) {
      pageController.animateToPage(0, duration: 650.milliseconds, curve: Curves.bounceOut);
    }
  }

  // ^ Provides Information at home page ^ //
  void readyTitleText(int lobbySize, {Duration timeout = const Duration(milliseconds: 3500)}) {
    titleText("Hello, ${UserService.firstName.value}");
    _timeoutActive = true;
    Future.delayed(timeout, () {
      titleText("$lobbySize Nearby");
    });
    Future.delayed(timeout * 2, () {
      titleText("Home");
      _timeoutActive = false;
    });
  }

  // ^ Provides Information at home page ^ //
  void swapTitleText(String text, {Duration timeout = const Duration(milliseconds: 3500)}) {
    if (!_timeoutActive) {
      titleText(text);
      HapticFeedback.mediumImpact();
      _timeoutActive = true;
      Future.delayed(timeout, () {
        titleText("Home");
        _timeoutActive = false;
      });
    }
  }
}
