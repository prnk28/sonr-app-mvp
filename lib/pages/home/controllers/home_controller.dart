export 'view.dart';
import 'dart:async';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style/style.dart';
import 'view.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  // Properties
  final appbarOpacity = 1.0.obs;
  final isConnecting = true.obs;
  final view = HomeView.Dashboard.obs;

  // Propeties
  final query = "".obs;
  final results = RxList<TransferCard>();

  // Global Keys
  final keyOne = GlobalKey();
  final keyTwo = GlobalKey();
  final keyThree = GlobalKey();
  final keyFour = GlobalKey();
  final keyFive = GlobalKey();

  // References
  late ScrollController scrollController;
  late TabController tabController;

  /// #### Controller Constructer
  @override
  onInit() {
    // Check Platform
    if (DeviceService.isMobile) {
      // Handle Tab Controller
      tabController = TabController(vsync: this, length: 2);
      scrollController = ScrollController(keepScrollOffset: false);

      // Handle Search Query
      query.listen(_handleQuery);
    } else {
      // Set View
      view(HomeView.Explorer);
    }

    // Initialize
    super.onInit();
  }

  @override
  void onReady() {
    // Check Entry Arguments
    HomeArguments args = Get.arguments;
    if (args.isFirstLoad) {
      if (DeviceService.isMobile) {
        SenderService.checkInitialShare();
      }
    }
    super.onReady();
  }

  /// #### On Dispose
  @override
  void onClose() {
    super.onClose();
  }

  /// #### Change View
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

  /// #### Update Bottom Bar Index
  void setBottomIndex(int newIndex) {
    // Check if Bottom Index is different
    if (view.value.isNotIndex(newIndex)) {
      // Change Index
      tabController.animateTo(newIndex);
      // Set Page
      view(HomeView.values[newIndex]);
    }
  }

  // # Handles Query Update
  _handleQuery(String newVal) {
    if (newVal.length > 0) {
      // Swap View to Searching if not Set
      if (view.value.isDashboard) {
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
