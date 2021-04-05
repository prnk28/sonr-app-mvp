import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sonr_app/theme/theme.dart';
import 'nav_controller.dart';

// ^ Bottom Bar Button Types ^ //
enum BottomBarButtonType {
  Home,
  Profile,
  Settings,
  Alerts,
}

// ^ Bottom Bar Button Widget ^ //
class BottomBarButton extends GetView<SonrNavController> {
  final BottomBarButtonType type;
  BottomBarButton(this.type);
  @override
  Widget build(BuildContext context) {
    final animatedIcon = _BottomBarButtonIcon(lottiePath: type.lottiePath);
    return GestureDetector(
        onTap: () {
          controller.setBottomIndex(type.index);
        },
        child: controller.isBottomIndex(type.index) ? animatedIcon : Icon(type.iconData, color: Colors.grey.shade400));
  }
}

// ^ Lottie Animation Button Widget ^ //
class _BottomBarButtonIcon extends StatefulWidget {
  final String lottiePath;
  const _BottomBarButtonIcon({Key key, this.lottiePath}) : super(key: key);

  @override
  _BottomBarButtonIconState createState() => _BottomBarButtonIconState();
}

class _BottomBarButtonIconState extends State<_BottomBarButtonIcon> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.lottiePath,
      controller: _controller,
      width: 40,
      height: 40,
      animate: true,
      fit: BoxFit.fitWidth,
      onLoaded: (composition) {
        _controller..duration = composition.seconds.seconds;
        _controller.forward();
      },
    );
  }
}

// ^ Bottom Bar Button Type Utility ^ //
extension BottomBarButtonTypeUtils on BottomBarButtonType {
  // # Returns Lottie File for Type
  String get lottiePath {
    switch (this) {
      case BottomBarButtonType.Home:
        return 'assets/icons/home.json';
        break;
      case BottomBarButtonType.Profile:
        return 'assets/icons/profile.json';
        break;
      case BottomBarButtonType.Settings:
        return 'assets/icons/settings.json';
        break;
      case BottomBarButtonType.Alerts:
        return 'assets/icons/alert.json';
        break;
      default:
        return "";
    }
  }

  // # Returns IconData for Type
  IconData get iconData {
    switch (this) {
      case BottomBarButtonType.Home:
        return Icons.home;
        break;
      case BottomBarButtonType.Profile:
        return Icons.person;
        break;
      case BottomBarButtonType.Settings:
        return Icons.settings;
        break;
      case BottomBarButtonType.Alerts:
        return Icons.notifications;
        break;
      default:
        return Icons.deck;
    }
  }

  // # Returns Index for Type
  int get index {
    switch (this) {
      case BottomBarButtonType.Home:
        return 0;
        break;
      case BottomBarButtonType.Profile:
        return 1;
        break;
      case BottomBarButtonType.Alerts:
        return 2;
        break;
      case BottomBarButtonType.Settings:
        return 3;
        break;
      default:
        return -1;
    }
  }
}
