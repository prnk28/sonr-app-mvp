import 'package:sonr_app/style/style.dart';

enum ToggleFilter { All, Media, Contact, Links }
enum RecentsViewStatus { Default, Search }

extension RecentsViewStatusUtil on RecentsViewStatus {
  /// Checks if Status is Search
  bool get isSearching => this == RecentsViewStatus.Search;

  /// Checks if Status is Default
  bool get isDefault => this == RecentsViewStatus.Default;
}

class RecentsController extends GetxController with SingleGetTickerProviderMixin {
  // Tag Management
  final category = ToggleFilter.All.obs;
  final query = "".obs;
  final results = RxList<TransferCard>();
  final tagIndex = 0.obs;
  final view = RecentsViewStatus.Default.obs;

  // References
  late TabController tabController;
  late ScrollController scrollController;

  /// @ Controller Constructer
  @override
  onInit() {
    // Set Scroll Controller
    scrollController = ScrollController(keepScrollOffset: false);

    // Handle Tab Controller
    tabController = TabController(vsync: this, length: 4);
    tabController.addListener(() {
      tagIndex(tabController.index);
    });
    query.listen(_handleQuery);

    // Initialize
    super.onInit();
  }

  /// Sets View for Default
  void exitToDefault() {
    view(RecentsViewStatus.Default);
    view.refresh();
  }

  /// Sets View for Searching
  void closeSearch(BuildContext context) {
    if (DeviceService.isMobile) {
      MobileService.closeKeyboard(context: context);
    }
    query("");
    view(RecentsViewStatus.Default);
    view.refresh();
  }

  /// @ Method for Setting Category Filter
  setTag(int index) {
    tagIndex(index);
    category(ToggleFilter.values[index]);
    tabController.animateTo(index);

    // Haptic Feedback
    HapticFeedback.mediumImpact();
  }

  // # Handles Query Update
  _handleQuery(String newVal) {
    if (newVal.length > 0) {
      // Swap View to Searching if not Set
      if (view.value.isDefault) {
        view(RecentsViewStatus.Search);
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
      if (view.value.isSearching) {
        view(RecentsViewStatus.Default);
      }
    }
  }
}
