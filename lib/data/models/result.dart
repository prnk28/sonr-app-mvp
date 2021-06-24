import 'package:connectivity/connectivity.dart';
import 'package:sonr_app/style.dart';

extension ConnectivityResultUtils on ConnectivityResult {
  /// Convert Package Enum to ConnectionRequest_InternetType enum
  ConnectionRequest_InternetType toInternetType() {
    switch (this) {
      case ConnectivityResult.wifi:
        return ConnectionRequest_InternetType.Wifi;
      case ConnectivityResult.mobile:
        return ConnectionRequest_InternetType.Mobile;
      case ConnectivityResult.none:
        return ConnectionRequest_InternetType.None;
    }
  }
}


/// Animated Bounce In Direction
enum BounceDirection { Left, Right, Up, Down }
extension BounceDirectionUtils on BounceDirection {
  /// Checks if Direction is `Left`
  bool get isLeft => this == BounceDirection.Left;

  /// Checks if Direction is `Right`
  bool get isRight => this == BounceDirection.Right;

  /// Checks if Direction is `Up`
  bool get isTop => this == BounceDirection.Up;

  /// Checks if Direction is `Down`
  bool get isDown => this == BounceDirection.Down;

  /// Returns In Animation for Widget based On Direction
  Widget inAnimation({required Widget child}) {
    // Initialize Parameters
    final duration = 300.milliseconds;
    final animate = true;
    final delay = 200.milliseconds;

    // Return Widget
    switch (this) {
      case BounceDirection.Left:
        return BounceInLeft(child: child, delay: delay, duration: duration, animate: animate);
      case BounceDirection.Right:
        return BounceInRight(child: child, delay: delay, duration: duration, animate: animate);
      case BounceDirection.Up:
        return BounceInUp(child: child, delay: delay, duration: duration, animate: animate);
      case BounceDirection.Down:
        return BounceInDown(child: child, delay: delay, duration: duration, animate: animate);
    }
  }

  /// Returns Out Animation for Widget based On Direction
  Widget outAnimation({required Widget child}) {
    // Initialize Parameters
    final duration = 200.milliseconds;
    final animate = true;

    // Return Widget
    switch (this) {
      case BounceDirection.Left:
        return FadeOutRight(child: child, animate: animate, duration: duration);
      case BounceDirection.Right:
        return FadeOutLeft(child: child, animate: animate, duration: duration);
      case BounceDirection.Up:
        return FadeOutDown(child: child, animate: animate, duration: duration);
      case BounceDirection.Down:
        return FadeOutUp(child: child, animate: animate, duration: duration);
    }
  }

  /// ### Initializer from Offest
  /// Returns Bounce Direction based on Offset
  static BounceDirection fromOffset({double? top, double? left, double? right, double? bottom}) {
    // Check Top
    if (top != null) {
      // Compare with Right
      if (right != null) {
        if (right > top) {
          return BounceDirection.Left;
        }
      }

      // Compare with Left
      if (left != null) {
        if (left > top) {
          return BounceDirection.Right;
        }
      }
      return BounceDirection.Down;
    }

    // Check Bottom
    else {
      // Compare with Right
      if (right != null) {
        if (right > bottom!) {
          return BounceDirection.Left;
        }
      }

      // Compare with Left
      if (left != null) {
        if (left > bottom!) {
          return BounceDirection.Right;
        }
      }
      return BounceDirection.Up;
    }
  }
}

/// Animated Fade Big Direction
enum BigDirection { Up, Down }

extension BigDirectionUtils on BigDirection {
  /// Checks if Direction is `Up`
  bool get isTop => this == BigDirection.Up;

  /// Checks if Direction is `Down`
  bool get isDown => this == BigDirection.Down;

  /// Returns In Animation for Widget based On Direction
  Widget inAnimation({required Widget child}) {
    // Initialize Parameters
    final duration = 350.milliseconds;
    final delay = 200.milliseconds;

    // Return Widget
    switch (this) {
      case BigDirection.Up:
        return FadeInUpBig(
          animate: true,
          from: 200,
          delay: delay,
          duration: duration,
          child: child,
        );
      case BigDirection.Down:
        return FadeInDownBig(
          animate: true,
          from: 200,
          delay: delay,
          duration: duration,
          child: child,
        );
    }
  }

  /// Returns Out Animation for Widget based On Direction
  Widget outAnimation({required Widget child}) {
    // Initialize Parameters
    final duration = 200.milliseconds;
    final animate = true;

    // Return Widget
    switch (this) {
      case BigDirection.Up:
        return FadeOutDown(
          child: child,
          animate: animate,
          duration: duration,
        );
      case BigDirection.Down:
        return FadeOutUp(
          child: child,
          animate: animate,
          duration: duration,
        );
    }
  }
}
