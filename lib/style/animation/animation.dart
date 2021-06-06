export 'lottie.dart';
export 'rive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../style.dart';

/// @ Animated Scale
class AnimatedScale extends StatefulWidget {
  final Widget? child;
  final double scale;
  final Duration duration;
  final Alignment alignment;

  const AnimatedScale({
    this.child,
    this.scale = 1,
    this.duration = const Duration(milliseconds: 150),
    this.alignment = Alignment.center,
  });

  @override
  _AnimatedScaleState createState() => _AnimatedScaleState();
}

class _AnimatedScaleState extends State<AnimatedScale> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double oldScale = 1;

  @override
  void initState() {
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: widget.scale, end: widget.scale).animate(_controller);
    super.initState();
  }

  @override
  void didUpdateWidget(AnimatedScale oldWidget) {
    if (oldWidget.scale != widget.scale) {
      _controller.reset();
      oldScale = oldWidget.scale;
      _animation = Tween<double>(begin: oldScale, end: widget.scale).animate(_controller);
      _controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}

/// @ Sonr Ripples
class AnimatedRipples extends HookWidget {
  const AnimatedRipples({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: const Duration(milliseconds: 2000))..repeat();
    final size = 400.0;
    return Center(
      child: CustomPaint(
        painter: CirclePainter(
          controller,
        ),
        child: SizedBox(
          width: size * 4.125,
          height: size * 4.125,
          child: ScaleTransition(
              scale: Tween(begin: 0.98, end: 1.0).animate(
                CurvedAnimation(
                  parent: controller,
                  curve: const CurveWave(),
                ),
              ),
              child: child),
        ),
      ),
    );
  }
}

/// @ Animated Slide Switch
enum _SwitchType { Fade, SlideUp, SlideDown, SlideLeft, SlideRight }
class AnimatedSlideSwitcher extends StatelessWidget {
  final _SwitchType _animation;
  final Widget child;
  final Duration duration;

  // * Constructer * //
  const AnimatedSlideSwitcher(this._animation, this.child, this.duration);

  // * Factory Fade * //
  factory AnimatedSlideSwitcher.fade({required Widget child, Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
    return AnimatedSlideSwitcher(_SwitchType.Fade, child, duration);
  }

  // * Factory Slide Up * //
  factory AnimatedSlideSwitcher.slideUp({required Widget child, Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
    return AnimatedSlideSwitcher(_SwitchType.SlideUp, child, duration);
  }

  // * Factory Slide Down * //
  factory AnimatedSlideSwitcher.slideDown({required Widget child, Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
    return AnimatedSlideSwitcher(_SwitchType.SlideDown, child, duration);
  }

  // * Factory Slide Left * //
  factory AnimatedSlideSwitcher.slideLeft({required Widget child, Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
    return AnimatedSlideSwitcher(_SwitchType.SlideLeft, child, duration);
  }

  // * Factory Slide Right * //
  factory AnimatedSlideSwitcher.slideRight({required Widget child, Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
    return AnimatedSlideSwitcher(_SwitchType.SlideRight, child, duration);
  }

  /// @ Build View Method
  @override
  Widget build(BuildContext context) {
    // Initialize Transition Map
    Map<_SwitchType, Widget Function(Widget, Animation<double>)> transitionMap = {
      _SwitchType.Fade: AnimatedSwitcher.defaultTransitionBuilder,
      _SwitchType.SlideDown: _slideTransition(0, -1),
      _SwitchType.SlideUp: _slideTransition(0, 1),
      _SwitchType.SlideLeft: _slideTransition(-1, 0),
      _SwitchType.SlideRight: _slideTransition(1, 0),
    };

    // Return Switcher
    return AnimatedSwitcher(
        duration: duration,
        switchOutCurve: Curves.easeInOutSine,
        switchInCurve: Curves.fastLinearToSlowEaseIn,
        transitionBuilder: transitionMap[_animation]!,
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return currentChild!;
        },
        child: child);
  }

  /// @ Method Builds Slide Transition
  Widget Function(Widget, Animation<double>) _slideTransition(double x, double y) {
    return (Widget child, Animation<double> animation) {
      final offsetAnimation = TweenSequence([
        TweenSequenceItem(tween: Tween<Offset>(begin: Offset(x, y), end: Offset(0.0, 0.0)), weight: 1),
        TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 2),
      ]).animate(animation);
      return ClipRect(
        child: SlideTransition(
          position: offsetAnimation,
          child: child,
        ),
      );
    };
  }
}
