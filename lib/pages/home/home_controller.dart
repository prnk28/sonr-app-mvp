export 'models/arguments.dart';
export 'models/status.dart';
import 'dart:async';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style.dart';
import 'models/arguments.dart';
import 'models/status.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  // Properties
  final appbarOpacity = 1.0.obs;
  final title = "Home".obs;
  final subtitle = "".obs;
  final pageIndex = 0.obs;
  final bottomIndex = 0.obs;
  final view = HomeView.Dashboard.obs;
  final sonrStatus = Rx<Status>(Sonr.status.value);

  // Propeties
  final query = "".obs;
  final results = RxList<TransferCard>();

  // Controllers
  late final TabController tabController;

  // References
  late StreamSubscription<Lobby?> _lobbyStream;
  late StreamSubscription<Status> _statusStream;
  late ScrollController scrollController;
  int _lobbySizeRef = 0;
  bool _timeoutActive = false;

  /// @ Controller Constructer
  @override
  onInit() {
    // Check Platform
    if (DeviceService.isMobile) {
      // Handle Tab Controller
      tabController = TabController(vsync: this, length: 2);
      scrollController = ScrollController(keepScrollOffset: false);

      // Handle Search Query
      query.listen(_handleQuery);

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
    _lobbyStream = LobbyService.lobby.listen(_handleLobbyStream);
    _statusStream = Sonr.status.listen(_handleStatus);
  }

  @override
  void onReady() {
    // Check Entry Arguments
    HomeArguments args = Get.arguments;
    if (args.isFirstLoad && DeviceService.isMobile) {
      SenderService.checkInitialShare();
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
    if (newView == HomeView.Search) {
      // Handle Keyboard/Opacity
      appbarOpacity(0);
      DeviceService.keyboardShow();

      // Set New View with Delay
      Future.delayed(200.milliseconds, () {
        view(newView);
        view.refresh();
      });
    } else {
      // Handle Keyboard/Opacity
      appbarOpacity(1);
      DeviceService.keyboardHide();

      // Set New View
      view(newView);
      view.refresh();
    }
  }

  /// @ Handle Title Tap
  void onTitleTap() {
    if (LobbyService.lobby.value.count > 0) {
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
    // Check Valid
    if (!_timeoutActive && !isClosed) {
      // Swap Text
      title(val);
      HapticFeedback.mediumImpact();
      _timeoutActive = true;

      // Revert Text
      Future.delayed(timeout, () {
        if (!isClosed) {
          title("${LobbyService.lobby.value.count} Around");
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
      DeviceService.playSound(type: Sounds.Joined);
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
      title("${LobbyService.lobby.value.count} Nearby");
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

  // # Handles Query Update
  _handleQuery(String newVal) {
    if (newVal.length > 0) {
      // Swap View to Searching if not Set
      if (view.value.isDefault) {
        view(HomeView.Search);
      }

      // Fetch Results
      var dateResults = CardService.all.where((e) => e.matchesDate(newVal)).toList();
      var nameResults = CardService.all.where((e) => e.matchesName(newVal)).toList();
      var payloadResults = CardService.all.where((e) => e.matchesPayload(newVal)).toList();

      // Update Results
      results.addAll(dateResults);
      results.addAll(nameResults);
      results.addAll(payloadResults);
      results.toSet();
      results.refresh();
    } else {
      // Swap View to Searching if not Set
      if (view.value.isSearch) {
        changeView(HomeView.Dashboard);
      }
    }
  }
}
