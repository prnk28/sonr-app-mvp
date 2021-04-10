import 'package:flutter_hooks/flutter_hooks.dart';
import '../theme.dart';
import 'package:lottie/lottie.dart';

// ** Enums ** //
enum LottieBoard { David, JoinRemote }
enum LottieIconType { Home, Profile, Alerts, Remote }

// ^ Lottie Board Type extensions ^ //
extension LottieBoardUtils on LottieBoard {
  String get path {
    switch (this) {
      case LottieBoard.David:
        return "assets/lottie/david.json";
        break;
      case LottieBoard.JoinRemote:
        return "assets/lottie/join-remote.json";
        break;
      default:
        return "";
    }
  }
}

// ^ Lottie Icon Type extensions ^ //

extension LottieIconUtils on LottieIconType {
  String get path {
    switch (this) {
      case LottieIconType.Home:
        return "assets/bar/home.json";
        break;
      case LottieIconType.Profile:
        return "assets/bar/profile.json";
        break;
      case LottieIconType.Alerts:
        return "assets/bar/alerts.json";
        break;
      case LottieIconType.Remote:
        return "assets/bar/remote.json";
        break;
      default:
        return "";
    }
  }
}

// ^ Lottie Icon Widget ^ //
class LottieIcon extends HookWidget {
  final Function onComplete;
  final LottieIconType type;
  final double size;
  LottieIcon({@required this.type, this.onComplete, this.size = 24});
  @override
  Widget build(BuildContext context) {
    https://assets9.lottiefiles.com/packages/lf20_gctecpva.json
    final controller = useAnimationController();
    return Lottie.asset(
      type.path,
      controller: controller,
      width: size,
      repeat: false,
      animate: true,
      height: size,
      fit: BoxFit.contain,
      onLoaded: (composition) {
        var duration = composition.seconds.seconds;
        controller..duration = duration;
        controller.forward();
        _callbackComplete(duration);
      },
    );
  }

  // # Handles Animation Complete
  _callbackComplete(Duration time) {
    Future.delayed(time, () {
      if (onComplete != null) {
        onComplete();
      }
    });
  }
}

// ^ Lottie Animation Container Widget ^ //
class LottieContainer extends StatefulWidget {
  final double width;
  final double height;
  final BoxFit fit;
  final LottieBoard type;
  final Function onComplete;
  final bool repeat;
  final bool animate;
  final bool reverse;
  const LottieContainer(
      {Key key,
      @required this.type,
      this.onComplete,
      this.width = 200,
      this.height = 200,
      this.fit = BoxFit.fill,
      this.repeat = false,
      this.animate = true,
      this.reverse = true})
      : super(key: key);
  @override
  _LottieContainerState createState() => _LottieContainerState();
}

class _LottieContainerState extends State<LottieContainer> with TickerProviderStateMixin {
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
      widget.type.path,
      controller: _controller,
      width: widget.width,
      repeat: widget.repeat,
      reverse: widget.reverse,
      animate: widget.animate,
      height: widget.height,
      fit: BoxFit.contain,
      onLoaded: (composition) {
        _controller..duration = composition.seconds.seconds;
        if (widget.repeat) {
          _controller.repeat();
        } else {
          _controller.forward();
        }
      },
    );
  }
}
