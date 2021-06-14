import 'dart:async';
import 'package:sonr_app/data/core/arguments.dart';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style.dart';

enum HomeView { Dashboard, Contact, Explorer }

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  // Properties
  final isTitleVisible = true.obs;
  final isTransferVisible = false.obs;

  // Elements
  final title = "Home".obs;
  final subtitle = "".obs;
  final pageIndex = 0.obs;
  final bottomIndex = 0.obs;
  final view = HomeView.Dashboard.obs;
  final sonrStatus = Rx<Status>(SonrService.status.value);

  // Controllers
  late final TabController tabController;
  late final ScrollController scrollController;

  // References
  late StreamSubscription<Lobby?> _lobbyStream;
  late StreamSubscription<Status> _statusStream;
  int _lobbySizeRef = 0;
  bool _timeoutActive = false;

  /// @ Controller Constructer
  @override
  onInit() {
    // Check Platform
    if (DeviceService.isMobile) {
      // Handle Tab Controller
      tabController = TabController(vsync: this, length: 2);
      scrollController = ScrollController();

      // Listen for Updates
      tabController.addListener(() {
        // Set Index
        bottomIndex(tabController.index);

        // Set Page
        view(HomeView.values[tabController.index]);

        // Update Title
        title(view.value.title);
      });
    } else {
      // Set View
      view(HomeView.Explorer);
    }

    // Initialize
    super.onInit();

    // Handle Streams
    _lobbyStream = LobbyService.local.listen(_handleLobbyStream);
    _statusStream = SonrService.status.listen(_handleStatus);
  }

  @override
  void onReady() {
    // Check Entry Arguments
    HomeArguments args = Get.arguments;
    if (args.isFirstLoad && DeviceService.isMobile) {
      MobileService.checkInitialShare();
    }
    super.onReady();
  }

  /// @ On Dispose
  @override
  void onClose() {
    _lobbyStream.cancel();
    _statusStream.cancel();
    pageIndex(0);
    super.onClose();
  }

  /// @ Change View
  void changeView(HomeView newView) {
    view(newView);
    view.refresh();
  }

  /// @ Handle Title Tap
  void onTitleTap() {
    if (LobbyService.local.value.count > 0) {
      AppPage.Transfer.off();
    }
  }

  /// @ Update Bottom Bar Index
  void setBottomIndex(int newIndex) {
    // Check if Bottom Index is different
    if (newIndex != bottomIndex.value) {
      // Change Index
      bottomIndex(newIndex);
      tabController.animateTo(newIndex);

      // Set Page
      view(HomeView.values[newIndex]);

      // Update Title
      title(view.value.title);
    }
  }

  // @ Swaps Title when Lobby Size Changes
  void swapTitleText(String val, {Duration timeout = const Duration(milliseconds: 3500)}) {
    // Check Keyboard
    if (DeviceService.isMobile) {
      MobileService.closeKeyboard();
    }

    // Check Valid
    if (!_timeoutActive && !isClosed && isTitleVisible.value) {
      // Swap Text
      title(val);
      HapticFeedback.mediumImpact();
      _timeoutActive = true;

      // Revert Text
      Future.delayed(timeout, () {
        if (!isClosed) {
          title("${LobbyService.local.value.count} Around");
          _timeoutActive = false;
        }
      });
    }
  }

  // @ Handle Size Update
  _handleLobbyStream(Lobby? onData) {
    // Peer Joined
    if (onData!.count > _lobbySizeRef) {
      var diff = onData.count - _lobbySizeRef;
      swapTitleText("$diff Joined");
      DeviceService.playSound(type: UISoundType.Joined);
    }
    // Peer Left
    else if (onData.count < _lobbySizeRef) {
      var diff = _lobbySizeRef - onData.count;
      swapTitleText("$diff Left");
    }
    _lobbySizeRef = onData.count;
  }

  // @ Handle Status Update
  _handleStatus(Status val) {
    sonrStatus(val);
    if (val.isConnected) {
      // Entry Text
      title("${LobbyService.local.value.count} Nearby");
      _timeoutActive = true;

      // Revert Text
      Future.delayed(const Duration(milliseconds: 3500), () {
        if (!isClosed) {
          title(view.value.title);
          _timeoutActive = false;
        }
      });
    }
  }
}

/// @ Home View Enum Extension
extension HomeViewUtils on HomeView {
  bool get isMain => this == HomeView.Dashboard;

  // # Returns IconData for Type
  IconData iconData(bool isSelected) {
    switch (this) {
      case HomeView.Dashboard:
        return isSelected ? SonrIcons.HomeActive : SonrIcons.HomeInactive;
      case HomeView.Contact:
        return isSelected ? SonrIcons.PersonalActive : SonrIcons.PersonalInactive;
      default:
        return Icons.deck;
    }
  }

  // # Returns Icon Size
  double get iconSize {
    switch (this) {
      case HomeView.Dashboard:
        return 32;
      case HomeView.Contact:
        return 32;
      default:
        return 32;
    }
  }

  String get title {
    if (this == HomeView.Dashboard) {
      if (UserService.isNewUser.value) {
        return "Nice to meet you.";
      }
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
