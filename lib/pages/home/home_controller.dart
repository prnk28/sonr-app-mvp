export 'models/arguments.dart';
export 'models/home_status.dart';
export 'models/recent_status.dart';
import 'dart:async';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style.dart';
import 'models/arguments.dart';
import 'models/home_status.dart';
import 'models/recent_status.dart';

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
  final sonrStatus = Rx<Status>(NodeService.status.value);

  // Propeties
  final query = "".obs;
  final results = RxList<TransferCard>();
  final recentsView = RecentsViewStatus.Default.obs;

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
    _lobbyStream = LocalService.lobby.listen(_handleLobbyStream);
    _statusStream = NodeService.status.listen(_handleStatus);
  }

  @override
  void onReady() {
    // Check Entry Arguments
    HomePageArgs args = Get.arguments;
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

  /// Sets View for Searching
  void closeSearch(BuildContext context) {
    DeviceService.hideKeyboard();
    query("");
    recentsView(RecentsViewStatus.Default);
    recentsView.refresh();
  }

  /// Sets View for Default
  void exitToDefault() {
    recentsView(RecentsViewStatus.Default);
    recentsView.refresh();
  }

  /// @ Handle Title Tap
  void onTitleTap() {
    if (LocalService.lobby.value.count > 0) {
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
    if (!_timeoutActive && !isClosed && isTitleVisible.value) {
      // Swap Text
      title(val);
      HapticFeedback.mediumImpact();
      _timeoutActive = true;

      // Revert Text
      Future.delayed(timeout, () {
        if (!isClosed) {
          title("${LocalService.lobby.value.count} Around");
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
      title("${LocalService.lobby.value.count} Nearby");
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
      if (recentsView.value.isDefault) {
        recentsView(RecentsViewStatus.Search);
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
      if (recentsView.value.isSearching) {
        recentsView(RecentsViewStatus.Default);
      }
    }
  }
}
