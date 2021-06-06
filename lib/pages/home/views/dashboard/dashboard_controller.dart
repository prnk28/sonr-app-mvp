import 'package:sonr_app/style.dart';

enum RecentsViewStatus { Default, Search }

extension RecentsViewStatusUtil on RecentsViewStatus {
  /// Checks if Status is Search
  bool get isSearching => this == RecentsViewStatus.Search;

  /// Checks if Status is Default
  bool get isDefault => this == RecentsViewStatus.Default;
}

class DashboardController extends GetxController with SingleGetTickerProviderMixin {
  // Propeties
  final query = "".obs;
  final results = RxList<TransferCard>();
  final view = RecentsViewStatus.Default.obs;

  // References
  late ScrollController scrollController;

  /// @ Controller Constructer
  @override
  onInit() {
    // Set Scroll Controller
    scrollController = ScrollController(keepScrollOffset: false);

    // Handle Tab Controller
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
