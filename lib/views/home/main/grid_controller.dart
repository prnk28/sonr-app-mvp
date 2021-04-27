import 'dart:math';
import 'package:sonr_app/theme/theme.dart';

enum ToggleFilter { All, Media, Contact, Links }

class GridController extends GetxController with SingleGetTickerProviderMixin {
  // Tag Management
  final category = Rx<ToggleFilter>(ToggleFilter.All);
  final tagIndex = 0.obs;

  // References
  TabController tabController;
  ScrollController scrollController;


  // ^ Controller Constructer ^
  @override
  onInit() {
    // Set Scroll Controller
    scrollController = ScrollController(keepScrollOffset: false);

    // Set Default Properties
    tagIndex(0);

    // Handle Tab Controller
    tabController = TabController(vsync: this, length: 5);
    tabController.addListener(() {
      tagIndex(tabController.index);
    });

    // Initialize
    super.onInit();
  }

  // ^ Method for Setting Category Filter ^ //
  setTag(int index) {
    tagIndex(index);
    category(ToggleFilter.values[index]);
    tabController.animateTo(index);

    // Haptic Feedback
    HapticFeedback.mediumImpact();
  }

  // ^ Method for Returning Random Image Path
  String randomNoFilesPath() {
    return "assets/illustrations/no_files-${Random().nextInt(3) + 1}.png";
  }
}
