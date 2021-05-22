import 'package:sonr_app/style/style.dart';

enum ToggleFilter { All, Media, Contact, Links }

class RecentsController extends GetxController with SingleGetTickerProviderMixin {
  // Tag Management
  final category = Rx<ToggleFilter>(ToggleFilter.All);
  final tagIndex = 0.obs;

  // References
  TabController? tabController;
  ScrollController? scrollController;

  /// @ Controller Constructer
  @override
  onInit() {
    // Set Scroll Controller
    scrollController = ScrollController(keepScrollOffset: false);

    // Set Default Properties
    tagIndex(0);

    // Handle Tab Controller
    tabController = TabController(vsync: this, length: 4);
    tabController!.addListener(() {
      tagIndex(tabController!.index);
    });

    // Initialize
    super.onInit();
  }

  /// @ Method for Setting Category Filter
  setTag(int index) {
    tagIndex(index);
    category(ToggleFilter.values[index]);
    tabController!.animateTo(index);

    // Haptic Feedback
    HapticFeedback.mediumImpact();
  }
}
