import 'package:flutter/material.dart';
import '../style.dart';
import 'package:rive/rive.dart' hide LinearGradient, RadialGradient;
import 'package:lottie/lottie.dart';

/// #### Animated Down Big/ Up Big
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

/// #### Animated Down Big/ Up Big
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

class AnimatedGlow extends StatefulWidget {
  final Widget child;
  final double endRadius;
  final BoxShape shape;
  final Duration duration;
  final bool repeat;
  final bool animate;
  final Duration repeatPauseDuration;
  final Curve curve;
  final bool showTwoGlows;
  final Color glowColor;
  final Duration? startDelay;

  const AnimatedGlow({
    Key? key,
    required this.child,
    required this.endRadius,
    this.shape = BoxShape.circle,
    this.duration = const Duration(milliseconds: 2000),
    this.repeat = true,
    this.animate = true,
    this.repeatPauseDuration = const Duration(milliseconds: 100),
    this.curve = Curves.fastOutSlowIn,
    this.showTwoGlows = true,
    this.glowColor = Colors.white,
    this.startDelay,
  }) : super(key: key);

  @override
  _AnimatedGlowState createState() => _AnimatedGlowState();
}

class _AnimatedGlowState extends State<AnimatedGlow> with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  );
  late final _curve = CurvedAnimation(
    parent: controller,
    curve: widget.curve,
  );
  late final Animation<double> _smallDiscAnimation = Tween(
    begin: (widget.endRadius * 2) / 6,
    end: (widget.endRadius * 2) * (3 / 4),
  ).animate(_curve);
  late final Animation<double> _bigDiscAnimation = Tween(
    begin: 0.0,
    end: (widget.endRadius * 2),
  ).animate(_curve);
  late final Animation<double> _alphaAnimation = Tween(
    begin: 0.30,
    end: 0.0,
  ).animate(controller);

  late void Function(AnimationStatus status) _statusListener = (_) async {
    if (controller.status == AnimationStatus.completed) {
      await Future.delayed(widget.repeatPauseDuration);
      if (mounted && widget.repeat && widget.animate) {
        controller.reset();
        controller.forward();
      }
    }
  };

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(AnimatedGlow oldWidget) {
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void _startAnimation() async {
    controller.addStatusListener(_statusListener);
    if (widget.startDelay != null) {
      await Future.delayed(widget.startDelay!);
    }
    if (mounted) {
      controller.reset();
      controller.forward();
    }
  }

  void _stopAnimation() async {
    controller.removeStatusListener(_statusListener);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _alphaAnimation,
      child: widget.child,
      builder: (context, widgetChild) {
        final decoration = BoxDecoration(
          shape: widget.shape,
          // If the user picks a curve that goes below 0 or above 1
          // this opacity will have unexpected effects without clamping
          color: widget.glowColor.withOpacity(
            _alphaAnimation.value.clamp(
              0.0,
              1.0,
            ),
          ),
        );
        return Container(
          height: widget.endRadius * 2,
          width: widget.endRadius * 2,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AnimatedBuilder(
                animation: _bigDiscAnimation,
                builder: (context, widget) {
                  // If the user picks a curve that goes below 0,
                  // this will throw without clamping
                  final num size = _bigDiscAnimation.value.clamp(
                    0.0,
                    double.infinity,
                  );
                  return Container(
                    height: size as double?,
                    width: size as double?,
                    decoration: decoration,
                  );
                },
              ),
              widget.showTwoGlows
                  ? AnimatedBuilder(
                      animation: _smallDiscAnimation,
                      builder: (context, widget) {
                        final num size = _smallDiscAnimation.value.clamp(
                          0.0,
                          double.infinity,
                        );

                        return Container(
                          height: size as double?,
                          width: size as double?,
                          decoration: decoration,
                        );
                      },
                    )
                  : const SizedBox(height: 0.0, width: 0.0),
              widgetChild!,
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

/// #### Animated Scale
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

  /// #### Build View Method
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

/// #### Lottie Based Progress Indicator
class CircleLoader extends StatelessWidget {
  final double scale;

  const CircleLoader({Key? key, this.scale = 1.0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Lottie.asset(
          LottieFile.LoaderCircle.path,
          fit: BoxFit.contain,
          width: 36,
          height: 36,
          animate: true,
          repeat: true,
        ),
      ),
    );
  }
}

/// #### Lottie Based Progress Indicator
class SpringLoader extends StatelessWidget {
  final double scale;

  const SpringLoader({Key? key, this.scale = 1.0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: 42,
        height: 42,
        child: Lottie.asset(
          LottieFile.LoaderSpring.path,
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

/// #### Rive Animation Container Widget
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
