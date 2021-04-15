import 'dart:async';
import 'package:sonr_app/data/core/arguments.dart';
import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/theme/form/theme.dart';

enum ToggleFilter { All, Media, Contact, Links }
enum HomeView { Main, Profile, Activity, Remote }

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  // Properties
  final isBottomBarVisible = true.obs;
  final isTitleVisible = true.obs;
  final isFilterOpen = false.obs;

  // Elements
  final titleText = "Home".obs;
  final pageIndex = 0.obs;
  final bottomIndex = 0.obs;
  final view = HomeView.Main.obs;
  final sonrStatus = Rx<Status>(SonrService.status.value);

  // References
  TabController tabController;
  HomeView _lastPage = HomeView.Main;
  StreamSubscription<int> _lobbySizeStream;
  StreamSubscription<Status> _statusStream;
  int _lobbySizeRef = 0;
  bool _timeoutActive = false;

  // Assets
  ImageIcon homeDefaultIcon = ImageIcon(NetworkImage(SonrAssetIcon.HomeDefault.link), size: 32, color: Colors.grey[400], key: ValueKey<bool>(false));
  ImageIcon profileDefaultIcon =
      ImageIcon(NetworkImage(SonrAssetIcon.ProfileDefault.link), size: 32, color: Colors.grey[400], key: ValueKey<bool>(false));
  ImageIcon activityDefaultIcon =
      ImageIcon(NetworkImage(SonrAssetIcon.ActivityDefault.link), size: 32, color: Colors.grey[400], key: ValueKey<bool>(false));
  ImageIcon remoteDefaultIcon =
      ImageIcon(NetworkImage(SonrAssetIcon.RemoteDefault.link), size: 38, color: Colors.grey[400], key: ValueKey<bool>(false));
  LottieIcon homeSelectIcon = LottieIcon(link: SonrAssetIcon.HomeSelected.link, size: 32, key: ValueKey<bool>(true));
  LottieIcon profileSelectIcon = LottieIcon(link: SonrAssetIcon.ProfileSelected.link, size: 32, key: ValueKey<bool>(true));
  LottieIcon activitySelectIcon = LottieIcon(link: SonrAssetIcon.ActivitySelected.link, size: 32, key: ValueKey<bool>(true));
  LottieIcon remoteSelectIcon = LottieIcon(link: SonrAssetIcon.RemoteSelected.link, size: 38, key: ValueKey<bool>(true));

  // ^ Controller Constructer ^
  @override
  onInit() {
    // Initalize Assets
    precacheImage(homeDefaultIcon.image, Get.context);
    precacheImage(profileDefaultIcon.image, Get.context);
    precacheImage(activityDefaultIcon.image, Get.context);
    precacheImage(remoteDefaultIcon.image, Get.context);

    // Handle Tab Controller
    tabController = TabController(vsync: this, length: 4);

    // Listen for Updates
    tabController.addListener(() {
      bottomIndex(tabController.index);
      // Set Page
      view(HomeView.values[tabController.index]);

      // Update Title
      titleText(view.value.title);
    });
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

  // ^ On Dispose ^ //
  @override
  void onClose() {
    _lobbySizeStream.cancel();
    _statusStream.cancel();
    pageIndex(0);
    super.onClose();
  }

  // ^ Returns Cached Image Icon Asset ^ //
  Widget getDefaultIconForView(HomeView view) {
    switch (view) {
      case HomeView.Main:
        return homeDefaultIcon;
      case HomeView.Profile:
        return profileDefaultIcon;
      case HomeView.Activity:
        return activityDefaultIcon;
      case HomeView.Remote:
        return remoteDefaultIcon;
      default:
        return Container();
    }
  }

// ^ Returns Lottie Icon Asset ^ //
  Widget getSelectedIconForView(HomeView view) {
    switch (view) {
      case HomeView.Main:
        return homeSelectIcon;
      case HomeView.Profile:
        return profileSelectIcon;
      case HomeView.Activity:
        return activitySelectIcon;
      case HomeView.Remote:
        return remoteSelectIcon;
      default:
        return Container();
    }
  }

  // ^ Method to Handle Action Button ^ //
  void handleAction() {
    if (view.value == HomeView.Main) {
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

  // ^ Update Bottom Bar Index ^ //
  setBottomIndex(int newIndex) {
    // Check if Bottom Index is different
    if (newIndex != bottomIndex.value) {
      // Shrink Share Button
      Get.find<ShareController>().shrink(delay: 100.milliseconds);

      // Change Index
      bottomIndex(newIndex);
      tabController.animateTo(newIndex);

      // Set Page
      view(HomeView.values[newIndex]);

      // Update Title
      titleText(view.value.title);

      // Close Sharebutton if open
      if (Get.find<ShareController>().status.value.isExpanded) {
        Get.find<ShareController>().shrink();
      }
    }
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
          titleText(view.value.title);
          _timeoutActive = false;
        }
      });
    }
  }

  // @ Return Animation by Page Index
  SwitchType get switchAnimation {
    if (_lastPage.index > view.value.index) {
      _lastPage = view.value;
      return SwitchType.SlideLeft;
    } else {
      _lastPage = view.value;
      return SwitchType.SlideRight;
    }
  }

  // @ Handle Keyboard Visibility
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
      titleText("${LobbyService.localSize.value} Nearby");
      _timeoutActive = true;

      // Revert Text
      Future.delayed(const Duration(milliseconds: 3500), () {
        if (!isClosed) {
          titleText(view.value.title);
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
      case HomeView.Main:
        return Icons.home;
      case HomeView.Profile:
        return Icons.person;
      case HomeView.Activity:
        return Icons.notifications;
      case HomeView.Remote:
        return SonrIconData.remote;
      default:
        return Icons.deck;
    }
  }

  // # Returns Icon Size
  double get iconSize {
    switch (this) {
      case HomeView.Main:
        return 32;
      case HomeView.Profile:
        return 32;
      case HomeView.Activity:
        return 32;
      case HomeView.Remote:
        return 38;
      default:
        return 32;
    }
  }

  String get title {
    if (this == HomeView.Main) {
      return "Welcome Back";
    } else {
      return this.toString().substring(this.toString().indexOf('.') + 1);
    }
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
