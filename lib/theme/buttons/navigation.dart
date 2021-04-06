import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';

// ^ Bottom Bar Button Types ^ //
enum BottomNavButton {
  Grid,
  Profile,
  Alerts,
  Remote,
}

// ^ Top Bar Button Types ^ //
enum TopNavButton {
  Menu,
  Search,
  Back,
  Details,
}

// ^ Bottom Bar Button Widget ^ //
class NavButton extends StatelessWidget {
  final bool isBottom;
  final TopNavButton topType;
  final BottomNavButton bottomType;
  final Function(int) onPressed;
  final RxInt currentIndex;
  NavButton(this.isBottom, this.onPressed, this.currentIndex, {this.bottomType, this.topType});
  factory NavButton.bottom(BottomNavButton type, Function(int) onPressed, RxInt currentIndex) {
    return NavButton(true, onPressed, currentIndex, bottomType: type);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onPressed(bottomType.index);
        },
        child: ObxValue<RxInt>(
            (idx) => AnimatedScale(
                  duration: 250.milliseconds,
                  child: Icon(bottomType.iconData, color: idx.value == bottomType.index ? SonrPalette.Primary : Colors.grey.shade400),
                  scale: idx.value == bottomType.index ? 1.2 : 1.0,
                ),
            currentIndex));
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
