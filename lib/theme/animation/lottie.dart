import 'package:flutter_hooks/flutter_hooks.dart';
import '../form/theme.dart';
import 'package:lottie/lottie.dart';

// ** Enums ** //
enum LottieBoard { David, JoinRemote, Access, Gallery, Location }
enum LottieShare { Camera, Files, Gallery }

// ^ Lottie Board Type extensions ^ //
extension LottieBoardUtils on LottieBoard {
  String get path {
    switch (this) {
      case LottieBoard.David:
        return "assets/lottie/david.json";

      case LottieBoard.JoinRemote:
        return "assets/lottie/join-remote.json";

      case LottieBoard.Access:
        return "assets/lottie/access.json";

      case LottieBoard.Gallery:
        return "assets/lottie/gallery.json";

      case LottieBoard.Location:
        return "assets/lottie/location.json";

      default:
        return "";
    }
  }
}

// ^ Lottie Icon Type extensions ^ //
extension LottieShareUtils on LottieShare {
  String get path {
    switch (this) {
      case LottieShare.Camera:
        return "assets/share/camera.json";
      case LottieShare.Files:
        return "assets/share/files.json";
      default:
        return "assets/share/gallery.json";
    }
  }
}

// ^ Lottie Icon Widget ^ //
class LottieIcon extends HookWidget {
  final Function onComplete;
  final String link;
  final double size;

  LottieIcon({@required this.link, this.onComplete, this.size = 24, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    assert(link.isURL);
    final controller = useAnimationController();
    return Lottie.network(
      link,
      controller: controller,
      repeat: false,
      animate: true,
      width: size,
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
class LottieContainer extends HookWidget {
  final double width;
  final double height;
  final BoxFit fit;
  final LottieBoard type;
  final Function onComplete;
  final bool repeat;
  final bool animate;
  const LottieContainer(
      {Key key,
      @required this.type,
      this.onComplete,
      this.width = 200,
      this.height = 200,
      this.fit = BoxFit.fill,
      this.repeat = true,
      this.animate = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController();
    return Lottie.asset(
      type.path,
      controller: controller,
      width: width,
      repeat: repeat,
      animate: animate,
      height: height,
      fit: BoxFit.contain,
      onLoaded: (composition) {
        controller..duration = composition.seconds.seconds;
        if (repeat) {
          controller.repeat();
        } else {
          controller.forward();
        }
      },
    );
  }
}

// ^ Lottie Animation Container Widget ^ //
class LottieShareContainer extends HookWidget {
  final LottieShare type;
  const LottieShareContainer({Key key, @required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController();
    return Lottie.asset(
      type.path,
      controller: controller,
      width: 55,
      repeat: true,
      animate: true,
      height: 55,
      fit: BoxFit.fitWidth,
      onLoaded: (composition) {
        controller..duration = composition.seconds.seconds;
        controller.repeat();
      },
    );
  }
}
