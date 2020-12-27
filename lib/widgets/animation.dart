import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sonar_app/theme/theme.dart';

class FadeAnimatedSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;
  const FadeAnimatedSwitcher(
      {this.child, this.duration = const Duration(milliseconds: 1500)});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: duration,
        switchOutCurve: Curves.easeInOutSine,
        switchInCurve: Curves.fastLinearToSlowEaseIn,
        layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
          return currentChild;
        },
        child: child);
  }
}

class SlideUpAnimatedSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;
  const SlideUpAnimatedSwitcher(
      {this.child, this.duration = const Duration(seconds: 2)});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: duration,
        switchOutCurve: Curves.easeInOutSine,
        switchInCurve: Curves.fastLinearToSlowEaseIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final offsetAnimation = TweenSequence([
            TweenSequenceItem(
                tween: Tween<Offset>(
                    begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)),
                weight: 1),
            TweenSequenceItem(
                tween: ConstantTween(Offset(0.0, 0.0)), weight: 1),
          ]).animate(animation);
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

class SlideDownAnimatedSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;
  const SlideDownAnimatedSwitcher(
      {this.child, this.duration = const Duration(seconds: 1)});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: duration,
        switchOutCurve: Curves.easeInOutSine,
        switchInCurve: Curves.fastLinearToSlowEaseIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final offsetAnimation = TweenSequence([
            TweenSequenceItem(
                tween: Tween<Offset>(
                    begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0)),
                weight: 1),
            TweenSequenceItem(
                tween: ConstantTween(Offset(0.0, 0.0)), weight: 2),
          ]).animate(animation);
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

class SlideRightAnimatedSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;
  const SlideRightAnimatedSwitcher(
      {this.child, this.duration = const Duration(seconds: 1)});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: duration,
        switchOutCurve: Curves.easeInOutCubic,
        switchInCurve: Curves.fastLinearToSlowEaseIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final offsetAnimation = TweenSequence([
            TweenSequenceItem(
                tween: Tween<Offset>(
                    begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)),
                weight: 1),
            TweenSequenceItem(
                tween: ConstantTween(Offset(0.0, 0.0)), weight: 3),
          ]).animate(animation);
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

class SlideLeftAnimatedSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;
  const SlideLeftAnimatedSwitcher(
      {this.child, this.duration = const Duration(seconds: 1)});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: duration,
        switchOutCurve: Curves.easeInOutCubic,
        switchInCurve: Curves.fastLinearToSlowEaseIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final offsetAnimation = TweenSequence([
            TweenSequenceItem(
                tween: Tween<Offset>(
                    begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0)),
                weight: 1),
            TweenSequenceItem(
                tween: ConstantTween(Offset(0.0, 0.0)), weight: 3),
          ]).animate(animation);
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

