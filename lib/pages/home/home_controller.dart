import 'dart:async';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sonr_app/data/core/arguments.dart';
import 'package:sonr_app/modules/share/share_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'search/search_view.dart';

enum ToggleFilter { All, Media, Contact, Links }
enum HomeView { Main, Profile, Activity, Remote }

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  // Properties
  final isTitleVisible = true.obs;
  final isSearchVisible = false.obs;

  // Elements
  final titleText = "Home".obs;
  final pageIndex = 0.obs;
  final bottomIndex = 0.obs;
  final view = HomeView.Main.obs;
  final sonrStatus = Rx<Status>(SonrService.status.value);

  // Controllers
  TabController tabController;
  FloatingSearchBarController searchBarController;

  // References
  HomeView _lastPage = HomeView.Main;
  StreamSubscription<int> _lobbySizeStream;
  StreamSubscription<Status> _statusStream;
  int _lobbySizeRef = 0;
  bool _timeoutActive = false;

  // ^ Controller Constructer ^
  @override
  onInit() {
    // Handle Tab Controller
    tabController = TabController(vsync: this, length: 4);
    searchBarController = FloatingSearchBarController();
    searchBarController.close();

    // Listen for Updates
    tabController.addListener(() {
      // Play Sound
      if (tabController.index != bottomIndex.value) {
        DeviceService.playSound(type: UISoundType.Swipe);
      }

      // Set Index
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

  // ^ Update Bottom Bar Index ^ //
  void setBottomIndex(int newIndex) {
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
    // Check Keyboard
    DeviceService.closeKeyboard();

    // Check Valid
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

  // @ Toggle Search View
  void toggleSearch() {
    // Update Value
    isSearchVisible(!isSearchVisible.value);

    // Present View
    if (isSearchVisible.value) {}
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
        return SonrIcons.Remote;
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
