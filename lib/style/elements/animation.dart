import 'package:flutter/material.dart';
import '../style.dart';
import 'package:rive/rive.dart' hide LinearGradient, RadialGradient;
import 'package:lottie/lottie.dart';

/// @ Animated Down Big/ Up Big
class AnimatedBounce extends StatefulWidget {
  final Widget child;
  final bool isDisplayed;
  final BounceDirection direction;

  const AnimatedBounce({
    required this.child,
    required this.isDisplayed,
    required this.direction,
  });

  @override
  _AnimatedBounce createState() => _AnimatedBounce();
}

class _AnimatedBounce extends State<AnimatedBounce> {
  bool oldIsDisplayed = true;

  @override
  void didUpdateWidget(AnimatedBounce oldWidget) {
    if (oldWidget.isDisplayed != widget.isDisplayed) {
      oldIsDisplayed = oldWidget.isDisplayed;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isDisplayed
        ? widget.direction.inAnimation(
            child: widget.child,
          )
        : widget.direction.outAnimation(
            child: widget.child,
          );
  }
}

/// @ Animated Down Big/ Up Big
class AnimatedBig extends StatefulWidget {
  final Widget child;
  final bool isDisplayed;
  final BigDirection direction;

  const AnimatedBig({
    required this.child,
    required this.isDisplayed,
    required this.direction,
  });

  @override
  _AnimatedBigState createState() => _AnimatedBigState();
}

class _AnimatedBigState extends State<AnimatedBig> {
  bool oldIsDown = true;

  @override
  void didUpdateWidget(AnimatedBig oldWidget) {
    if (oldWidget.isDisplayed != widget.isDisplayed) {
      oldIsDown = oldWidget.isDisplayed;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isDisplayed
        ? widget.direction.inAnimation(
            child: widget.child,
          )
        : widget.direction.outAnimation(
            child: widget.child,
          );
  }
}

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

class AnimatedSlider extends StatelessWidget {
  final SwitchType type;
  final Widget child;
  final Duration duration;

  // * Constructer * //
  const AnimatedSlider(this.type, this.child, this.duration);

  // * Factory Fade * //
  factory AnimatedSlider.fade({required Widget child, Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
    return AnimatedSlider(SwitchType.Fade, child, duration);
  }

  // * Factory Slide Up * //
  factory AnimatedSlider.slideUp({required Widget child, Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
    return AnimatedSlider(SwitchType.SlideUp, child, duration);
  }

  // * Factory Slide Down * //
  factory AnimatedSlider.slideDown({required Widget child, Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
    return AnimatedSlider(SwitchType.SlideDown, child, duration);
  }

  // * Factory Slide Left * //
  factory AnimatedSlider.slideLeft({required Widget child, Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
    return AnimatedSlider(SwitchType.SlideLeft, child, duration);
  }

  // * Factory Slide Right * //
  factory AnimatedSlider.slideRight({required Widget child, Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
    return AnimatedSlider(SwitchType.SlideRight, child, duration);
  }

  /// @ Build View Method
  @override
  Widget build(BuildContext context) {
    // Return Switcher
    return AnimatedSwitcher(
        duration: duration,
        switchOutCurve: Curves.easeInOutSine,
        switchInCurve: Curves.fastLinearToSlowEaseIn,
        transitionBuilder: type.transition,
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return currentChild!;
        },
        child: child);
  }
}

/// @ Lottie Based Progress Indicator
class HourglassIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.2,
      child: SizedBox(
        width: 24,
        height: 24,
        child: Lottie.asset(
          LottieFile.Loader.path,
          fit: BoxFit.contain,
          width: 42,
          height: 42,
          animate: true,
          repeat: true,
        ),
      ),
    );
  }
}

/// @ Rive Animation Container Widget
class RiveContainer extends StatefulWidget {
  final double width;
  final double height;
  final RiveBoard type;
  final Widget? placeholder;

  const RiveContainer({Key? key, required this.type, this.width = 55, this.height = 55, this.placeholder}) : super(key: key);
  @override
  _RiveContainer createState() => _RiveContainer();
}

class _RiveContainer extends State<RiveContainer> {
  // Properties
  Artboard? _riveArtboard;

  // ** Constructer Initial ** //
  @override
  void initState() {
    // Load the RiveFile from the binary data.
    widget.type.load().then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // Retreive Artboard
        final artboard = file.mainArtboard;

        // Determine Animation by Tile Type
        artboard.addController(SimpleAnimation('Default'));
        if (mounted) {
          setState(() => _riveArtboard = artboard);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Center(
          child: _riveArtboard == null
              ? widget.placeholder ?? Container()
              : Rive(
                  fit: BoxFit.fitHeight,
                  artboard: _riveArtboard!,
                )),
    );
  }
}
