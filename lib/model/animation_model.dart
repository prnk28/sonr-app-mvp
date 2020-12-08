import 'package:flutter/foundation.dart';
import 'package:rive/rive.dart';

// ^ Combined Animation Class ^ //
class AnimationModel extends SimpleAnimation {
  final Loop loopType;
  AnimationModel(String animationName, this.loopType) : super(animationName) {
    isActive = false;
  }

  start() {
    switch (this.loopType) {
      case Loop.oneShot:
        _oneShot();
        break;
      case Loop.loop:
        _loop();
        break;
      case Loop.pingPong:
        _pingPong();
        break;
    }
  }

  _oneShot() {
    instance.animation.loop = Loop.oneShot;
  }

  _loop() {
    instance.animation.loop = Loop.loop;
    isActive = true;
  }

  _pingPong() {
    instance.animation.loop = Loop.pingPong;
    isActive = true;
  }

  stop() => instance.animation.loop = Loop.oneShot;
}

// ^ Class that starts one animation after parameter ^ //
class AnimationTransitioner {
  // @ Properties
  final Artboard _artboard;
  AnimationModel _current;

  // @ Constructer
  AnimationTransitioner(this._artboard);

  pingPong(AnimationModel next) {
    if (_current != null) {
      _shift();
    }

    // Start First Animation
    _artboard.artboard.addController(next);
    next.start();
    _current = next;
  }

  // @ PingPong until value
  pingPongUntil(AnimationModel first, AnimationModel second,
      ValueNotifier<bool> exitValue) {
    // Check if Animation Active
    if (_current != null) {
      _shift();
    }
    // Start First Animation
    _artboard.artboard.addController(first);
    first.start();
    _current = first;

    // Add Listener for Exit
    exitValue.addListener(() {
      if (exitValue.value) {
        first.stop();
      }
    });

    // Check for First Animation State
    first.isActiveChanged.addListener(() {
      if (!first.isActive) {
        _artboard.artboard.addController(second);
        _artboard.artboard.removeController(first);
        second.start();
        _current = second;
      }
    });
  }

  // @ One shot then next animation
  oneShot(AnimationModel next) {
    // Check if Animation Active
    if (_current != null) {
      _shift();
    }

    // Start First Animation
    _artboard.artboard.addController(next);
    next.start();
    _current = next;

    // Check for First Animation State
    next.isActiveChanged.addListener(() {
      if (!next.isActive) {
        _artboard.artboard.removeController(next);
        _current = null;
      }
    });
  }

  // @ One shot then next animation
  oneShotThen(AnimationModel first, AnimationModel second) {
    // Check if Animation Active
    if (_current != null) {
      _shift();
    }

    // Start First Animation
    _artboard.artboard.addController(first);
    first.start();
    _current = first;

    // Check for First Animation State
    first.isActiveChanged.addListener(() {
      if (!first.isActive) {
        _artboard.artboard.addController(second);
        _artboard.artboard.removeController(first);
        second.start();
        _current = second;
      }
    });
  }

  // @ One shot then next animation until ValueNotifier
  oneShotThenUntil(AnimationModel first, AnimationModel second,
      ValueNotifier<bool> exitValue) {
    // Check if Animation Active
    if (_current != null) {
      _shift();
    }
    // Start First Animation
    _artboard.artboard.addController(first);
    first.start();
    _current = first;

    // Add Listener for Exit
    exitValue.addListener(() {
      if (exitValue.value) {
        second.stop();
      }
    });

    // Check for First Animation State
    first.isActiveChanged.addListener(() {
      if (!first.isActive) {
        _artboard.artboard.addController(second);
        _artboard.artboard.removeController(first);
        second.start();
        _current = second;
      }
    });

    second.isActiveChanged.addListener(() {
      if (!second.isActive) {
        _artboard.removeController(first);
        _current = null;
      }
    });
  }

  // @ Shift to Next Animation if one exists
  _shift() {
    if (_current.isActive) {
      // Stop active animation
      _current.stop();
      // Await State
      _current.isActiveChanged.addListener(() {
        if (!_current.isActive) {
          // Remove Current Controller
          _artboard.removeController(_current);
        }
      });
    } else {
      // Remove Current Controller
      _artboard.removeController(_current);
    }
  }
}
