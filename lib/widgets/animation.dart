import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';

enum AnimType { None, Shake, FadeIn, FadeOut }
enum AnimState { Instant, Await, Switcher }
enum AnimSwitch { Fade, SlideUp, SlideDown, SlideLeft, SlideRight }

class SonrAnimatedWidget extends GetWidget<AnimatedController> {
  final Widget child;
  final AnimState state;
  final AnimSwitch switcher;
  final Duration delay;
  SonrAnimatedWidget({
    Key key,
    @required this.child,
    @required this.state,
    this.switcher = AnimSwitch.Fade,
    this.delay = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // @ Check Animation State for Switcher
    if (state == AnimState.Switcher) {
      // Check SwitchFade Type
      if (switcher == AnimSwitch.Fade) {
        return AnimatedSwitcher(
            duration: controller.fadeSwitchDuration,
            switchOutCurve: Curves.easeInOutSine,
            switchInCurve: Curves.fastLinearToSlowEaseIn,
            layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
              return currentChild;
            },
            child: child);
      }
      // Other Slide Type
      else {
        return AnimatedSwitcher(
            duration: controller.slideDuration,
            switchOutCurve: Curves.easeInOutSine,
            switchInCurve: Curves.fastLinearToSlowEaseIn,
            transitionBuilder: (Widget child, Animation<double> animation) {
              final offsetAnimation = controller.slideAnimation(animation, switcher);
              print("Sliding");
              return ClipRect(
                child: SlideTransition(
                  position: offsetAnimation,
                  child: child,
                ),
              );
            },
            layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
              return currentChild;
            },
            child: child);
      }
    }

    // Build View
    return Obx(() {
      if (controller.type.value == AnimType.Shake) {
        return TweenAnimationBuilder<double>(
          key: key,
          tween: Tween(begin: 0.0, end: 1.0),
          duration: 1.seconds,
          builder: (context, animation, child) => Transform.translate(
            offset: controller.shakeOffset(animation),
            child: child,
          ),
          child: child,
        );
      } else if (controller.type.value == AnimType.FadeIn) {
        return PlayAnimation<double>(
            tween: (0.0).tweenTo(1.0),
            duration: 500.milliseconds,
            delay: delay,
            builder: (context, child, value) {
              return AnimatedOpacity(opacity: value, duration: 500.milliseconds, child: child);
            });
      } else if (controller.type.value == AnimType.FadeOut) {
        return PlayAnimation<double>(
            tween: (1.0).tweenTo(0.0),
            duration: 150.milliseconds,
            delay: delay,
            builder: (context, child, value) {
              return AnimatedOpacity(opacity: value, duration: 150.milliseconds, child: child);
            });
      }
      return child;
    });
  }

  void animate(AnimType anim) {
    switch (anim) {
      case AnimType.Shake:
        controller.shake();
        break;
      case AnimType.FadeIn:
        controller.fadeIn();
        break;
      case AnimType.FadeOut:
        controller.fadeOut();
        break;
      default:
        controller.slideSwitch(anim);
        break;
    }
  }

  void reset() {
    controller.type(AnimType.None);
    controller.type.refresh();
  }
}

class AnimatedController extends GetxController {
  // Properties
  final type = AnimType.None.obs;

  // References
  AnimatedController();

  // ^ Duration Returners ^ //
  Duration get shakeDuration => 1000.milliseconds;
  Duration get fadeInDuration => 250.milliseconds;
  Duration get fadeOutDuration => 150.milliseconds;
  Duration get fadeSwitchDuration => 1500.milliseconds;
  Duration get slideDuration => 2.milliseconds;

  // ^ Method to Begin Shake ^ //
  void shake() {
    // Start Animation
    type(AnimType.Shake);
    type.refresh();

    // Reset
    Future.delayed(shakeDuration, () {
      type(AnimType.None);
    });
  }

  void fadeIn() {
    // Start Animation
    type(AnimType.FadeIn);
    type.refresh();

    // Reset
    Future.delayed(fadeInDuration, () {
      type(AnimType.None);
    });
  }

  void fadeOut() {
    // Start Animation
    type(AnimType.FadeOut);
    type.refresh();

    // Reset
    Future.delayed(fadeOutDuration, () {
      type(AnimType.None);
    });
  }

  void slideSwitch(AnimType s) {
    // Enable Animation
    type(s);
    type.refresh();
  }

  // ^ Get Animated Offset for Shake Method ^ //
  Offset shakeOffset(double animation) {
    var shake = 2 * (0.5 - (0.5 - Curves.bounceOut.transform(animation)).abs());
    return Offset(18 * shake, 0);
  }

  // ^ Get Animated Offset for SlideSwitcher Method ^ //
  Animation<Offset> slideAnimation(Animation<double> animation, AnimSwitch switcher) {
    // Slide Up
    if (switcher == AnimSwitch.SlideUp) {
      return TweenSequence([
        TweenSequenceItem(tween: Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)), weight: 1),
        TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 1),
      ]).animate(animation);
    }
    // Slide Down
    else if (switcher == AnimSwitch.SlideDown) {
      return TweenSequence([
        TweenSequenceItem(tween: Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0)), weight: 1),
        TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 2),
      ]).animate(animation);
    }
    // Slide Left
    else if (switcher == AnimSwitch.SlideLeft) {
      return TweenSequence([
        TweenSequenceItem(tween: Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0)), weight: 1),
        TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 3),
      ]).animate(animation);
    }
    // Slide Right
    else {
      return TweenSequence([
        TweenSequenceItem(tween: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)), weight: 1),
        TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 3),
      ]).animate(animation);
    }
  }
}

// class SlideUpAnimatedSwitcher extends StatelessWidget {
//   final Widget child;
//   final Duration duration;
//   const SlideUpAnimatedSwitcher({this.child, this.duration = const Duration(seconds: 1)});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//         duration: duration,
//         switchOutCurve: Curves.easeInOutSine,
//         switchInCurve: Curves.fastLinearToSlowEaseIn,
//         transitionBuilder: (Widget child, Animation<double> animation) {
//           final offsetAnimation = TweenSequence([
//             TweenSequenceItem(tween: Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)), weight: 1),
//             TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 1),
//           ]).animate(animation);
//           return ClipRect(
//             child: SlideTransition(
//               position: offsetAnimation,
//               child: child,
//             ),
//           );
//         },
//         layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
//           return currentChild;
//         },
//         child: child);
//   }
// }

// class SlideDownAnimatedSwitcher extends StatelessWidget {
//   final Widget child;
//   final Duration duration;
//   const SlideDownAnimatedSwitcher({this.child, this.duration = const Duration(seconds: 1)});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//         duration: duration,
//         switchOutCurve: Curves.easeInOutSine,
//         switchInCurve: Curves.fastLinearToSlowEaseIn,
//         transitionBuilder: (Widget child, Animation<double> animation) {
//           final offsetAnimation = TweenSequence([
//             TweenSequenceItem(tween: Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0)), weight: 1),
//             TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 2),
//           ]).animate(animation);
//           return ClipRect(
//             child: SlideTransition(
//               position: offsetAnimation,
//               child: child,
//             ),
//           );
//         },
//         layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
//           return currentChild;
//         },
//         child: child);
//   }
// }

// class SlideRightAnimatedSwitcher extends StatelessWidget {
//   final Widget child;
//   final Duration duration;
//   const SlideRightAnimatedSwitcher({this.child, this.duration = const Duration(seconds: 1)});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//         duration: duration,
//         switchOutCurve: Curves.easeInOutCubic,
//         switchInCurve: Curves.fastLinearToSlowEaseIn,
//         transitionBuilder: (Widget child, Animation<double> animation) {
//           final offsetAnimation = TweenSequence([
//             TweenSequenceItem(tween: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)), weight: 1),
//             TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 3),
//           ]).animate(animation);
//           return ClipRect(
//             child: SlideTransition(
//               position: offsetAnimation,
//               child: child,
//             ),
//           );
//         },
//         layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
//           return currentChild;
//         },
//         child: child);
//   }
// }

// class SlideLeftAnimatedSwitcher extends StatelessWidget {
//   final Widget child;
//   final Duration duration;
//   const SlideLeftAnimatedSwitcher({this.child, this.duration = const Duration(seconds: 1)});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//         duration: duration,
//         switchOutCurve: Curves.easeInOutCubic,
//         switchInCurve: Curves.fastLinearToSlowEaseIn,
//         transitionBuilder: (Widget child, Animation<double> animation) {
//           final offsetAnimation = TweenSequence([
//             TweenSequenceItem(tween: Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0)), weight: 1),
//             TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 3),
//           ]).animate(animation);
//           return ClipRect(
//             child: SlideTransition(
//               position: offsetAnimation,
//               child: child,
//             ),
//           );
//         },
//         layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
//           return currentChild;
//         },
//         child: child);
//   }
// }
