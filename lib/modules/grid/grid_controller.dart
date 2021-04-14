import 'package:sonr_app/modules/common/contact/contact.dart';
import 'package:sonr_app/modules/common/file/file.dart';
import 'package:sonr_app/modules/common/media/media.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';

enum ToggleFilter { All, Media, Contact, Links }

class GridController extends GetxController with SingleGetTickerProviderMixin {
  final category = Rx<ToggleFilter>(ToggleFilter.All);
  final tagIndex = 0.obs;

  // References
  TabController tabController;

  // ^ Controller Constructer ^
  @override
  onInit() {
    // Handle Tab Controller
    tabController = TabController(vsync: this, length: 4);
    tabController.addListener(() {
      tagIndex(tabController.index);
    });

    // Set Default Properties
    tagIndex(0);

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

  // @ Helper Method Builds Cards for List
  Widget buildCard(TransferCardItem item) {
    if (item.payload == Payload.MEDIA) {
      return MediaCardView(item);
    } else if (item.payload == Payload.CONTACT) {
      return ContactCardView(item);
    } else {
      return FileCardView(item);
    }
  }
}
