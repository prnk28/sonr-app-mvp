import 'dart:async';
import 'package:sonr_app/data/core/arguments.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';

enum ToggleFilter { All, Media, Contact, Links }
enum HomeState { Loading, Ready, None, New, First }
enum ShareButtonState { Default, Queue }
const K_ALLOWED_FILE_TYPES = ['pdf', 'doc', 'docx', 'ttf', 'mp3', 'xml', 'csv', 'key', 'ppt', 'pptx', 'xls', 'xlsm', 'xlsx', 'rtf', 'txt'];

class HomeController extends GetxController {
  // Properties

  final status = Rx<HomeState>();
  final category = Rx<ToggleFilter>(ToggleFilter.All);
  final shareCounter = 0.obs;
  final shareState = ShareButtonState.Default.obs;

  // Elements
  final titleText = "Home".obs;
  final pageIndex = 0.obs;
  final toggleIndex = 1.obs;
  final bottomIndex = 0.obs;
  final page = BottomNavButton.Grid.obs;
  bool get isQueueExpanded => shareState.value == ShareButtonState.Queue;

  // References
  var _lastPage = BottomNavButton.Grid;
  StreamSubscription<List<TransferCard>> _cardStream;
  bool _hasPromptedAutoSave = false;
  Timer _timer;

  // ^ Controller Constructer ^
  @override
  void onReady() {
    // Set View Properties
    toggleIndex(1);
    pageIndex(0);
    setStatus();
    super.onReady();
    // Initialize
    HomeArguments args = Get.arguments;
    if (args.isFirstLoad) {
      MediaService.checkInitialShare();
    }
  }

  // ^ Update Home State ^ //
  setStatus() async {
    // Set Initial Status
    if (await CardService.cardCount() > 0) {
      status(HomeState.Ready);
    } else {
      if (UserService.isNewUser.value) {
        status(HomeState.First);
      } else {
        status(HomeState.None);
      }
    }
  }

  // ^ On Dispose ^ //
  @override
  void onClose() {
    _cardStream.cancel();

    toggleIndex(1);
    pageIndex(0);
    super.onClose();
  }

  AnimSwitch getSwitcherAnimation() {
    switch (page.value) {
      case BottomNavButton.Grid:
        if (_lastPage == BottomNavButton.Profile) {
          _lastPage = page.value;
          return AnimSwitch.SlideUp;
        } else if (_lastPage == BottomNavButton.Remote) {
          _lastPage = page.value;
          return AnimSwitch.SlideDown;
        } else {
          _lastPage = page.value;
          return AnimSwitch.SlideLeft;
        }
        break;
      case BottomNavButton.Profile:
        _lastPage = page.value;
        return AnimSwitch.SlideDown;
        break;
      case BottomNavButton.Alerts:
        _lastPage = page.value;
        return AnimSwitch.SlideRight;
        break;
      case BottomNavButton.Remote:
        _lastPage = page.value;
        return AnimSwitch.SlideUp;
        break;
      default:
        _lastPage = page.value;
        return AnimSwitch.SlideLeft;
    }
  }

  // ^ Expand Share Button ^ //
  expandShare(double timeout, ShareButtonState previousState) {
    HapticFeedback.heavyImpact();

    // Create Timeout
    _timer = Timer.periodic(500.milliseconds, (_) {
      // Add to Counter
      shareCounter(shareCounter.value += 500);

      // Check if Timeout Reached
      if (shareCounter.value == timeout) {
        if (shareState.value == previousState) {
          shrinkShare();
        }
      }
    });
  }

  // ^ Method for Setting Category Filter ^ //
  setToggleCategory(int index) {
    toggleIndex(index);
    category(ToggleFilter.values[index]);

    // Haptic Feedback
    HapticFeedback.mediumImpact();
  }

  // ^ Update Bottom Bar Index ^ //
  setBottomIndex(int newIndex) {
    bottomIndex(newIndex);
    if (newIndex == 1) {
      page(BottomNavButton.Profile);
    } else if (newIndex == 2) {
      page(BottomNavButton.Alerts);
    } else if (newIndex == 3) {
      page(BottomNavButton.Remote);
    } else {
      page(BottomNavButton.Grid);
    }
  }

  // ^ Close Share Button ^ //
  void shrinkShare({Duration delay = const Duration(milliseconds: 0)}) {
    Future.delayed(delay, () {
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
        HapticFeedback.mediumImpact();
        shareState(ShareButtonState.Default);
        shareCounter(0);
      }
    });
  }

  // ^ Toggles Expanded Share Button ^ //
  void toggleShare() {
    if (shareState.value == ShareButtonState.Default) {
      shareState(ShareButtonState.Queue);
      expandShare(6000, shareState.value);
    } else {
      shrinkShare();
    }
  }
}
