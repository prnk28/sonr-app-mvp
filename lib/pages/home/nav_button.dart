import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';

import 'home_controller.dart';

// ^ Bottom Bar Button Types ^ //
enum NavButtonType {
  Grid,
  Profile,
  Alerts,
  Remote,
}

// ^ Bottom Bar Button Status ^ //
enum NavButtonStatus { Default, Animating, Completed }

// ^ Bottom Bar Button Widget ^ //
class NavButton extends GetView<HomeController> {
  final NavButtonType bottomType;
  final Function(int) onPressed;
  final RxInt currentIndex;
  NavButton(this.bottomType, this.onPressed, this.currentIndex);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onPressed(bottomType.index);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ObxValue<RxInt>(
              (idx) => AnimatedScale(
                    duration: 250.milliseconds,
                    child: idx.value == bottomType.index ? _buildSelected() : _buildDefault(),
                    scale: idx.value == bottomType.index ? 1.25 : 1.0,
                  ),
              currentIndex),
        ));
  }

  Widget _buildDefault() {
    return ImageIcon(
      AssetImage(bottomType.disabled),
      size: bottomType.iconSize,
      color: Colors.grey[400],
    );
  }

  Widget _buildSelected() {
    return LottieIcon(
      type: bottomType.lottie,
      size: bottomType.iconSize,
    );
  }
}

// ^ Bottom Bar Button Type Utility ^ //
extension BottomNavButtonUtils on NavButtonType {
  // # Returns IconData for Type
  IconData get iconData {
    switch (this) {
      case NavButtonType.Grid:
        return Icons.home;
        break;
      case NavButtonType.Profile:
        return Icons.person;
        break;
      case NavButtonType.Alerts:
        return Icons.notifications;
        break;
      case NavButtonType.Remote:
        return SonrIconData.remote;
        break;
      default:
        return Icons.deck;
    }
  }

  // # Returns Icon Path for Type
  String get disabled {
    switch (this) {
      case NavButtonType.Profile:
        return "assets/bar/profile_disabled.png";
      case NavButtonType.Alerts:
        return "assets/bar/alerts_disabled.png";
      case NavButtonType.Remote:
        return "assets/bar/remote_disabled.png";
      default:
        return "assets/bar/home_disabled.png";
    }
  }

  LottieIconType get lottie {
    switch (this) {
      case NavButtonType.Profile:
        return LottieIconType.Profile;
        break;
      case NavButtonType.Alerts:
        return LottieIconType.Alerts;
        break;
      case NavButtonType.Remote:
        return LottieIconType.Remote;
        break;
      default:
        return LottieIconType.Home;
    }
  }

  // # Returns Icon Size
  double get iconSize {
    switch (this) {
      case NavButtonType.Grid:
        return 32;
        break;
      case NavButtonType.Profile:
        return 32;
        break;
      case NavButtonType.Alerts:
        return 32;
        break;
      case NavButtonType.Remote:
        return 38;
        break;
      default:
        return 32;
    }
  }

  // # Returns Index for Type
  int get index {
    switch (this) {
      case NavButtonType.Grid:
        return 0;
        break;
      case NavButtonType.Profile:
        return 1;
        break;
      case NavButtonType.Alerts:
        return 2;
        break;
      case NavButtonType.Remote:
        return 3;
        break;
      default:
        return -1;
    }
  }
}
