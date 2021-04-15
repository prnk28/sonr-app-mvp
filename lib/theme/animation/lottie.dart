import 'package:flutter_hooks/flutter_hooks.dart';
import '../form/theme.dart';
import 'package:lottie/lottie.dart';

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
  final SonrAssetLottie type;
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
    return Lottie.network(
      type.link,
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
  final SonrAssetLottie type;
  const LottieShareContainer({Key key, @required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController();
    return Lottie.asset(
      type.link,
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
