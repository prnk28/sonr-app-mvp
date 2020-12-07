import 'package:flutter/foundation.dart';
import 'package:rive/rive.dart';

// ^ Single Shot Animation ^ //
class OneShotAnimation extends SimpleAnimation {
  OneShotAnimation(String animationName) : super(animationName);
  Function() _next;
  ValueNotifier<bool> _enterValue;

  start() {
    instance.animation.loop = Loop.oneShot;
  }

  startWait(ValueNotifier<bool> enterValue) {
    // Wait Until Exit Value True
    _enterValue = enterValue;
    _enterValue.addListener(_enterListener);
  }

  startThen(Function() next) {
    _next = next;
    instance.animation.loop = Loop.oneShot;
    this.isActiveChanged.addListener(_listener);
  }

  bool advance(double amount) {
    instance.animation.loop = Loop.oneShot;
    return instance.advance(amount);
  }

  _enterListener() {
    if (_enterValue != null && _enterValue.value == true) {
      // Play Animation
      instance.animation.loop = Loop.oneShot;
      this.isActiveChanged.addListener(_listener);
    }
  }

  _listener() {
    if (_next != null && !this.isActive) {
      _next();
      this.dispose();
    }
  }
}

// ^ Ping Pong Animation ^ //
class PingPongAnimation extends SimpleAnimation {
  PingPongAnimation(String animationName) : super(animationName);
  ValueNotifier<bool> _exitValue;

  start() {
    instance.animation.loop = Loop.pingPong;
    isActive = true;
  }

  startUntil(ValueNotifier<bool> exitValue) {
    // Play Animation
    _exitValue = exitValue;
    instance.animation.loop = Loop.pingPong;
    isActive = true;

    // Wait Until Exit Value True
    _exitValue.addListener(_exitListener);
  }

  stop() => instance.animation.loop = Loop.oneShot;

  _exitListener() {
    if (_exitValue != null && _exitValue.value == true) {
      stop();
      this.isActiveChanged.addListener(_listener);
    }
  }

  _listener() {
    if (!this.isActive) {
      this.dispose();
    }
  }
}

// ^ Loop Animation ^ //
class LoopAnimation extends SimpleAnimation {
  LoopAnimation(String animationName) : super(animationName);
  ValueNotifier<bool> _exitValue;

  start() {
    instance.animation.loop = Loop.loop;
    isActive = true;
  }

  startUntil(ValueNotifier<bool> exitValue) {
    // Play Animation
    instance.animation.loop = Loop.pingPong;
    isActive = true;

    // Wait Until Exit Value True
    _exitValue.addListener(_exitListener);
  }

  stop() => instance.animation.loop = Loop.oneShot;

  _exitListener() {
    if (_exitValue != null && _exitValue.value == true) {
      stop();
      this.isActiveChanged.addListener(_listener);
    }
  }

  _listener() {
    if (!this.isActive) {
      this.dispose();
    }
  }
}
