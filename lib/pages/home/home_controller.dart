import 'dart:async';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:sonr_app/data/core/arguments.dart';
import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';

enum ToggleFilter { All, Media, Contact, Links }
enum HomeState { Loading, Ready, None, New, First }

class HomeController extends GetxController {
  // Properties
  final status = Rx<HomeState>(HomeState.None);
  final category = Rx<ToggleFilter>(ToggleFilter.All);
  final isBottomBarVisible = true.obs;

  // Elements
  final titleText = "Home".obs;
  final pageIndex = 0.obs;
  final toggleIndex = 1.obs;
  final bottomIndex = 0.obs;
  final page = NavButtonType.Grid.obs;

  // References
  var _lastPage = NavButtonType.Grid;
  StreamSubscription<List<TransferCard>> _cardStream;
  final _keyboardVisible = KeyboardVisibilityController();

  // ^ Controller Constructer ^
  @override
  onInit() {
    // Set efault Properties
    toggleIndex(1);
    pageIndex(0);
    setStatus();

    // Initialize
    super.onInit();

    // Check Entry Arguments
    HomeArguments args = Get.arguments;
    if (args.isFirstLoad) {
      MediaService.checkInitialShare();
    }

    // Handle Keyboard Visibility
    _keyboardVisible.onChange.listen(_handleKeyboardVisibility);
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

  // ^ Return Animation by Page Index
  SwitchType getSwitcherAnimation() {
    if (_lastPage.index > page.value.index) {
      _lastPage = page.value;
      return SwitchType.SlideLeft;
    } else {
      _lastPage = page.value;
      return SwitchType.SlideRight;
    }
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
    // Check if Bottom Index is different
    if (newIndex != bottomIndex.value) {
      // Shrink Share Button
      Get.find<ShareController>().shrink(delay: 100.milliseconds);

      // Change Index
      bottomIndex(newIndex);
      if (newIndex == 1) {
        page(NavButtonType.Profile);
      } else if (newIndex == 2) {
        page(NavButtonType.Alerts);
      } else if (newIndex == 3) {
        page(NavButtonType.Remote);
      } else {
        page(NavButtonType.Grid);
      }
    } else {}
  }

  // @ Handle Keyboard Visibility
  _handleKeyboardVisibility(bool keyboardVisible) {
    isBottomBarVisible(!keyboardVisible);
  }
}
