import 'package:sonr_app/style.dart';
import 'mode.dart';

/// @ Method Builds Slide Transition
class FlatModeAnimation {
  final FlatModeTransition type;
  FlatModeAnimation(this.type);

  Curve get switchOutCurve {
    return Curves.easeOut;
  }

  Curve get switchInCurve {
    return Curves.easeIn;
  }

  // # Helper to Find End Offset
  TweenSequence<Offset> _buildTweenSequence() {
    switch (this.type) {
      // @ Slide In
      case FlatModeTransition.SlideIn:
        return TweenSequence([
          TweenSequenceItem(tween: Offset(0, -1).tweenTo(Offset(0.0, 0.0)), weight: 1),
          TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 1),
        ]);

      // @ Slide In Single
      case FlatModeTransition.SlideInSingle:
        return TweenSequence([
          TweenSequenceItem(tween: Offset(0, -1).tweenTo(Offset(0.0, 0.0)), weight: 1),
          TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 1),
        ]);

      // @ Slide Out
      case FlatModeTransition.SlideOut:
        return TweenSequence([
          TweenSequenceItem(tween: Offset(0, 0.5).tweenTo(Offset(0.0, -1)), weight: 1),
          TweenSequenceItem(tween: ConstantTween(Offset(0.0, -1)), weight: 1),
        ]);

      // @ Slide Down
      case FlatModeTransition.SlideDown:
        return TweenSequence([
          TweenSequenceItem(tween: Offset(0, 0.0).tweenTo(Offset(0.0, 1)), weight: 1),
          TweenSequenceItem(tween: ConstantTween(Offset(0.0, 1)), weight: 1),
        ]);

      default:
        return TweenSequence([TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 1)]);
    }
  }

  // # Switcher Transition Method
  Widget Function(Widget, Animation<double>) transition() {
    return (Widget child, Animation<double> animation) {
      final offsetAnimation = _buildTweenSequence().animate(animation);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    };
  }

  // # Switcher Layout Method
  Widget? Function(Widget? currentChild, List<Widget> previousChildren) layout() {
    return (Widget? currentChild, List<Widget> previousChildren) {
      if (type == FlatModeTransition.SlideIn) {
        List<Widget> children = previousChildren;
        if (currentChild != null) children = children.toList()..add(currentChild);
        return Stack(
          children: children,
          alignment: Alignment.center,
        );
      } else if (type == FlatModeTransition.Standby) {
        return Align(alignment: Alignment.bottomCenter, child: Container(child: currentChild, padding: EdgeWith.bottom(48)));
      } else if (type == FlatModeTransition.SlideDown) {
        return currentChild;
      } else if (type == FlatModeTransition.SlideInSingle) {
        return Center(child: currentChild);
      } else {
        return Center(child: currentChild);
      }
    };
  }
}
