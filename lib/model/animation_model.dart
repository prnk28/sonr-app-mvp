import 'package:flutter/foundation.dart';
import 'package:rive/rive.dart';

class OneShotAnimation extends SimpleAnimation {
  OneShotAnimation(String animationName) : super(animationName);

  start() {
    instance.animation.loop = Loop.oneShot;
  }

  startThen(Function() next) {
    instance.animation.loop = Loop.oneShot;
    this.isActiveChanged.addListener(() {
      if (!this.isActive) {
        next();
      }
    });
  }

  bool advance(double amount) {
    instance.animation.loop = Loop.oneShot;
    return instance.advance(amount);
  }
}

class PingPongAnimation extends SimpleAnimation {
  PingPongAnimation(String animationName) : super(animationName);

  start() {
    instance.animation.loop = Loop.pingPong;
    isActive = true;
  }

  startUntil(Artboard artboard, ValueNotifier<bool> exitValue) {
    // Wait Until Exit Value True
    exitValue.addListener(() {
      if (exitValue.value == true) {
        stop();
        if (!this.isActive) {
          artboard.removeController(this);
        }
      }
    });

    // Play Animation
    instance.animation.loop = Loop.pingPong;
    isActive = true;
  }

  stop() => instance.animation.loop = Loop.oneShot;
}

class LoopAnimation extends SimpleAnimation {
  LoopAnimation(String animationName) : super(animationName);

  start() {
    instance.animation.loop = Loop.loop;
    isActive = true;
  }

  startUntil(Artboard artboard, ValueNotifier<bool> exitValue) {
    // Wait Until Exit Value True
    exitValue.addListener(() {
      if (exitValue.value == true) {
        stop();
        if (!this.isActive) {
          artboard.removeController(this);
        }
      }
    });

    // Play Animation
    instance.animation.loop = Loop.pingPong;
    isActive = true;
  }

  stop() => instance.animation.loop = Loop.oneShot;
}
