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

    // Initialize
    super.onInit();
  }

  /// Sets View for Default
  void exitToDefault() {
    view(RecentsViewStatus.Default);
    view.refresh();
  }

  /// Sets View for Searching
  void goToSearch() {
    view(RecentsViewStatus.Search);
    view.refresh();
  }

  /// ### SearchName:
  /// Enables Searching Local TransferCard DB with a given name.
  void search(String query) {
    // Set Query
    this.query(query);

    // Fetch Results
    var dateResults = CardService.all.where((e) => e.matchesDate(query)).toList();
    var nameResults = CardService.all.where((e) => e.matchesName(query)).toList();
    var payloadResults = CardService.all.where((e) => e.matchesPayload(query)).toList();

    // Update Results
    results.addAll(dateResults);
    results.addAll(nameResults);
    results.addAll(payloadResults);
    results.toSet();
    results.refresh();
  }

  /// @ Method for Setting Category Filter
  setTag(int index) {
    tagIndex(index);
    category(ToggleFilter.values[index]);
    tabController.animateTo(index);

    // Haptic Feedback
    HapticFeedback.mediumImpact();
  }
}
