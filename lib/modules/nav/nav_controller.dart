import 'dart:async';
import 'package:sonr_app/theme/theme.dart';

enum BottomShareButtonState { Default, Expanded }
enum NavPage { Home, Profile, Alerts, Remote, Transfer }

class NavController extends GetxController {
  // Properties
  final bottomIndex = 0.obs;
  final shareState = BottomShareButtonState.Default.obs;
  final shareCounter = 0.obs;
  final page = NavPage.Home.obs;

  // References
  Timer _timer;

  bool get isExpanded => shareState.value == BottomShareButtonState.Expanded;

  // ^ Expand Share Button ^ //
  expandShare(double timeout, BottomShareButtonState previousState) {
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

  // ^ Close Share Button ^ //
  void shrinkShare() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      HapticFeedback.mediumImpact();
      shareState(BottomShareButtonState.Default);
      shareCounter(0);
    }
  }

  // ^ Toggles Expanded Share Button ^ //
  void toggleShare() {
    if (shareState.value == BottomShareButtonState.Default) {
      shareState(BottomShareButtonState.Expanded);
      expandShare(6000, shareState.value);
    } else {
      shrinkShare();
    }
  }
}
