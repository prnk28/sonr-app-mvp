import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';

// ^ Bottom Bar Button Types ^ //
enum BottomNavButton {
  Grid,
  Profile,
  Alerts,
  Remote,
}

// ^ Bottom Bar Button Widget ^ //
class NavButton extends StatelessWidget {
  final BottomNavButton bottomType;
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
          padding: const EdgeInsets.all(6.0),
          child: ObxValue<RxInt>(
              (idx) => AnimatedScale(
                    duration: 250.milliseconds,
                    child: idx.value == bottomType.index ? _buildSelected() : _buildDefault(),
                    scale: idx.value == bottomType.index ? 1.2 : 1.0,
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
extension BottomNavButtonUtils on BottomNavButton {
  // # Returns IconData for Type
  IconData get iconData {
    switch (this) {
      case BottomNavButton.Grid:
        return Icons.home;
        break;
      case BottomNavButton.Profile:
        return Icons.person;
        break;
      case BottomNavButton.Alerts:
        return Icons.notifications;
        break;
      case BottomNavButton.Remote:
        return SonrIconData.remote;
        break;
      default:
        return Icons.deck;
    }
  }

  // # Returns Icon Path for Type
  String get disabled {
    switch (this) {
      case BottomNavButton.Profile:
        return "assets/bar/profile_disabled.png";
      case BottomNavButton.Alerts:
        return "assets/bar/alerts_disabled.png";
      case BottomNavButton.Remote:
        return "assets/bar/remote_disabled.png";
      default:
        return "assets/bar/home_disabled.png";
    }
  }

  LottieIconType get lottie {
    switch (this) {
      case BottomNavButton.Profile:
        return LottieIconType.Profile;
        break;
      case BottomNavButton.Alerts:
        return LottieIconType.Alerts;
        break;
      case BottomNavButton.Remote:
        return LottieIconType.Remote;
        break;
      default:
        return LottieIconType.Home;
    }
  }

  // # Returns Icon Size
  double get iconSize {
    switch (this) {
      case BottomNavButton.Grid:
        return 28;
        break;
      case BottomNavButton.Profile:
        return 28;
        break;
      case BottomNavButton.Alerts:
        return 28;
        break;
      case BottomNavButton.Remote:
        return 32;
        break;
      default:
        return 28;
    }
  }

  // # Returns Index for Type
  int get index {
    switch (this) {
      case BottomNavButton.Grid:
        return 0;
        break;
      case BottomNavButton.Profile:
        return 1;
        break;
      case BottomNavButton.Alerts:
        return 2;
        break;
      case BottomNavButton.Remote:
        return 3;
        break;
      default:
        return -1;
    }
  }
}
