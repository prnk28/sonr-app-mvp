import 'package:rive/rive.dart';

class WiperAnimation extends SimpleAnimation {
  WiperAnimation(String animationName) : super(animationName);

  start() {
    instance.animation.loop = Loop.loop;
    isActive = true;
  }

  stop() => instance.animation.loop = Loop.oneShot;
}
