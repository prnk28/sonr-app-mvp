import 'dart:async';
import 'package:sonr_app/data/core/arguments.dart';
import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';

enum ToggleFilter { All, Media, Contact, Links }
enum HomeState { Loading, Ready, None, New, First }
enum HomeView { Home, Profile, Alerts, Remote }

class HomeController extends GetxController {
  // Properties
  final status = Rx<HomeState>(HomeState.None);
  final category = Rx<ToggleFilter>(ToggleFilter.All);
  final isBottomBarVisible = true.obs;
  final isTitleVisible = true.obs;
  final isFilterOpen = false.obs;

  // Elements
  final titleText = "Home".obs;
  final pageIndex = 0.obs;
  final toggleIndex = 1.obs;
  final bottomIndex = 0.obs;
  final page = HomeView.Home.obs;
  final sonrStatus = Rx<Status>(SonrService.status.value);

  // References
  HomeView _lastPage = HomeView.Home;
  StreamSubscription<List<TransferCard>> _cardStream;
  StreamSubscription<int> _lobbySizeStream;
  StreamSubscription<Status> _statusStream;
  int _lobbySizeRef = 0;
  bool _timeoutActive = false;
  bool _isSwiping = false;

  // ^ Controller Constructer ^
  @override
  onInit() {
    // Set efault Properties
    toggleIndex(1);
    pageIndex(0);
    setStatus();

    // Initialize
    super.onInit();

    // Check Entry Arguments
    HomeArguments args = Get.arguments;
    if (args.isFirstLoad) {
      MediaService.checkInitialShare();
    }

    // Handle Streams
    DeviceService.keyboardVisible.listen(_handleKeyboardVisibility);
    _lobbySizeStream = LobbyService.localSize.listen(_handleLobbySizeStream);
    _statusStream = SonrService.status.listen(_handleStatus);
  }

  // ^ Update Home State ^ //
  setStatus() async {
    // Set Initial Status
    if (await CardService.cardCount() > 0) {
      status(HomeState.Ready);
    } else {
      if (UserService.isNewUser.value) {
        status(HomeState.First);
      } else {
        status(HomeState.None);
      }
    }
  }

  // ^ On Dispose ^ //
  @override
  void onClose() {
    _cardStream.cancel();
    _lobbySizeStream.cancel();
    _statusStream.cancel();
    toggleIndex(1);
    pageIndex(0);
    super.onClose();
  }

  // ^ Method to Handle Action Button ^ //
  void handleAction() {
    if (page.value == HomeView.Home) {
      // Set Open and Close Title
      isFilterOpen(!isFilterOpen.value);
      isTitleVisible(!isFilterOpen.value);

      // Close after Delay
      Future.delayed(5.seconds, () {
        if (isFilterOpen.value) {
          isFilterOpen(false);
          isTitleVisible(!isFilterOpen.value);
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
    // Check if Bottom Index is different
    if (newIndex != bottomIndex.value) {
      // Shrink Share Button
      Get.find<ShareController>().shrink(delay: 100.milliseconds);

      // Change Index
      bottomIndex(newIndex);

      // Set Page
      if (newIndex == 1) {
        page(HomeView.Profile);
      } else if (newIndex == 2) {
        page(HomeView.Alerts);
      } else if (newIndex == 3) {
        page(HomeView.Remote);
      } else {
        page(HomeView.Home);
      }

      // Update Title
      titleText(page.value.title);

      // Close Sharebutton if open
      if (Get.find<ShareController>().status.value.isExpanded) {
        Get.find<ShareController>().shrink();
      }
    }
  }

  // ^ Update Bottom Index from Swipe Left ^ //
  swipeLeft() {
    if (!_isSwiping) {
      _isSwiping = true;
      if (page.value.isNotLast) {
        page(page.value.pageNext);
        titleText(page.value.title);
        bottomIndex(HomeView.values.indexOf(page.value));
      }
    }
  }

  // ^ Update Bottom Index from Swipe Right ^ //
  swipeRight() {
    if (!_isSwiping) {
      _isSwiping = true;
      if (page.value.isNotFirst) {
        page(page.value.pageBefore);
        titleText(page.value.title);
        bottomIndex(HomeView.values.indexOf(page.value));
      }
    }
  }

  // ^ Swipe has Finished ^ //
  swipeComplete() {
    _isSwiping = false;
  }

  // @ Swaps Title when Lobby Size Changes ^ //
  void swapTitleText(String val, {Duration timeout = const Duration(milliseconds: 3500)}) {
    if (!_timeoutActive && !isClosed && isTitleVisible.value) {
      // Swap Text
      titleText(val);
      HapticFeedback.mediumImpact();
      _timeoutActive = true;

      // Revert Text
      Future.delayed(timeout, () {
        if (!isClosed) {
          titleText(page.value.title);
          _timeoutActive = false;
        }
      });
    }
  }

  // @ Return Animation by Page Index
  SwitchType get switchAnimation {
    if (_lastPage.index > page.value.index) {
      _lastPage = page.value;
      return SwitchType.SlideLeft;
    } else {
      _lastPage = page.value;
      return SwitchType.SlideRight;
    }
  }

  // # Handle Keyboard Visibility
  _handleKeyboardVisibility(bool keyboardVisible) {
    isBottomBarVisible(!keyboardVisible);
  }

  // @ Handle Size Update ^ //
  _handleLobbySizeStream(int onData) {
    // Peer Joined
    if (onData > _lobbySizeRef) {
      var diff = onData - _lobbySizeRef;
      swapTitleText("$diff Joined");
      DeviceService.playSound(type: UISoundType.Joined);
    }
    // Peer Left
    else if (onData < _lobbySizeRef) {
      var diff = _lobbySizeRef - onData;
      swapTitleText("$diff Left");
    }
    _lobbySizeRef = onData;
  }

  // @ Handle Status Update ^ //
  _handleStatus(Status val) {
    sonrStatus(val);
    if (val.isConnected) {
      // Entry Text
      titleText("Hello, ${UserService.firstName.value}");
      _timeoutActive = true;

      // Nearby Peers Text
      Future.delayed(const Duration(milliseconds: 3500), () {
        if (!isClosed) {
          titleText("${LobbyService.localSize.value} Nearby");
        }
      });

      // Revert Text
      Future.delayed(const Duration(milliseconds: 3500) * 2, () {
        if (!isClosed) {
          titleText(page.value.title);
          _timeoutActive = false;
        }
      });
    }
  }
}

// ^ Home View Enum Extension ^ //
extension HomeViewUtils on HomeView {
  // # Returns IconData for Type
  IconData get iconData {
    switch (this) {
      case HomeView.Home:
        return Icons.home;
      case HomeView.Profile:
        return Icons.person;
      case HomeView.Alerts:
        return Icons.notifications;
      case HomeView.Remote:
        return SonrIconData.remote;
      default:
        return Icons.deck;
    }
  }

  // # Returns Icon Path for Type
  String get disabled {
    switch (this) {
      case HomeView.Profile:
        return "assets/bar/profile_disabled.png";
      case HomeView.Alerts:
        return "assets/bar/alerts_disabled.png";
      case HomeView.Remote:
        return "assets/bar/remote_disabled.png";
      default:
        return "assets/bar/home_disabled.png";
    }
  }

  LottieIconType get lottie {
    switch (this) {
      case HomeView.Profile:
        return LottieIconType.Profile;
      case HomeView.Alerts:
        return LottieIconType.Alerts;
      case HomeView.Remote:
        return LottieIconType.Remote;
      default:
        return LottieIconType.Home;
    }
  }

  // # Returns Icon Size
  double get iconSize {
    switch (this) {
      case HomeView.Home:
        return 32;
      case HomeView.Profile:
        return 32;
      case HomeView.Alerts:
        return 32;
      case HomeView.Remote:
        return 38;
      default:
        return 32;
    }
  }

  String get title {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }

  bool get isNotFirst {
    var i = HomeView.values.indexOf(this);
    return i != 0;
  }

  bool get isNotLast {
    var i = HomeView.values.indexOf(this);
    return i != HomeView.values.length - 1;
  }

  HomeView get pageBefore {
    var i = HomeView.values.indexOf(this);
    return this.isNotFirst ? HomeView.values[i - 1] : this;
  }

  HomeView get pageNext {
    var i = HomeView.values.indexOf(this);
    return this.isNotLast ? HomeView.values[i + 1] : this;
  }

  // # Return State for Int
  static HomeView fromIndex(int i) {
    return HomeView.values[i];
  }
}
