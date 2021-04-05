import 'package:get/get.dart';
import 'package:sonr_app/modules/nav/nav_controller.dart';
import 'package:sonr_app/theme/theme.dart';


// ^ Bottom Bar Button Types ^ //
enum BottomNavButton {
  Home,
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
class NavButton extends GetView<NavController> {
  final bool isBottom;
  final TopNavButton topType;
  final BottomNavButton bottomType;
  NavButton(this.isBottom, {this.bottomType, this.topType});

  factory NavButton.top(TopNavButton type) {
    return NavButton(false, topType: type);
  }

  factory NavButton.bottom(BottomNavButton type) {
    return NavButton(true, bottomType: type);
  }
  @override
  Widget build(BuildContext context) {
    if (isBottom) {
      return GestureDetector(
          onTap: () {
            controller.setBottomIndex(bottomType.index);
          },
          child: Obx(() => AnimatedScale(
                duration: 250.milliseconds,
                child: Icon(bottomType.iconData, color: controller.isBottomIndex(bottomType.index) ? SonrPalette.Primary : Colors.grey.shade400),
                scale: controller.isBottomIndex(bottomType.index) ? 1.2 : 1.0,
              )));
    } else {
      return GestureDetector(
          onTap: () {

          },
          child: Obx(() => AnimatedScale(
                duration: 250.milliseconds,
                child: Icon(bottomType.iconData, color: controller.isBottomIndex(bottomType.index) ? SonrPalette.Primary : Colors.grey.shade400),
                scale: controller.isBottomIndex(bottomType.index) ? 1.2 : 1.0,
              )));
    }
  }
}

// ^ Bottom Bar Button Type Utility ^ //
extension BottomNavButtonUtils on BottomNavButton {
  // # Returns IconData for Type
  IconData get iconData {
    switch (this) {
      case BottomNavButton.Home:
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
      case BottomNavButton.Home:
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
