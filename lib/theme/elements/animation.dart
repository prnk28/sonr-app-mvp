import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import '../theme.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart' hide LinearGradient, RadialGradient;

enum AnimType { None, Shake, SlideIn, Fade }
enum AnimSwitch { Fade, SlideUp, SlideDown, SlideLeft, SlideRight }
enum LottieBoard { Complete, Empty, Pending, Progress, Computer, David, Phone, Gallery, Progress_Alt, Camera, Contact }
enum RiveBoard { Camera, Icon, Gallery, Contact, Feed, Splash, NotFound, Documents }

class AnimatedScale extends StatefulWidget {
  final Widget child;
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
  AnimationController _controller;
  Animation<double> _animation;
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

// ^ Sonr Animated Wave Icon for Screen Transitions ^ //
class AnimatedWaveIcon extends HookWidget {
  // Properties
  final IconData iconData;
  final double size;
  final Duration duration;
  final Function onCompleted;
  final FlutterGradientNames gradient;

  // Constructer
  AnimatedWaveIcon(this.iconData, {this.gradient, this.onCompleted, this.duration = const Duration(milliseconds: 1250), this.size = 325})
      : super(key: GlobalKey());

  @override
  Widget build(BuildContext context) {
    // Hook Controller
    final controller = useAnimationController(duration: Duration(seconds: 1));
    final iconKey = GlobalKey();
    controller.forward();

    // Reactive to Progress
    return Stack(
      alignment: Alignment.center,
      key: UniqueKey(),
      children: <Widget>[
        SizedBox(
          height: size,
          width: size,
          child: AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget child) {
              return CustomPaint(
                painter: IconWavePainter(
                  iconKey: iconKey,
                  waveAnimation: controller,
                  percent: controller.value,
                  gradient: gradient != null ? FlutterGradients.findByName(gradient) : SonrGradient.progress(),
                  boxHeight: size,
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: size,
          width: size,
          child: ShaderMask(
            blendMode: BlendMode.srcOut,
            shaderCallback: (bounds) => LinearGradient(
              colors: [SonrColor.White],
              stops: [0.0],
            ).createShader(bounds),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Center(
                child: Icon(
                  iconData,
                  size: size * 0.8,
                  key: iconKey,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class RipplesAnimation extends StatefulWidget {
  const RipplesAnimation({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;
  @override
  _RipplesAnimationState createState() => _RipplesAnimationState();
}

class _RipplesAnimationState extends State<RipplesAnimation> with TickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = 400.0;
    return Center(
      child: CustomPaint(
        painter: CirclePainter(
          _controller,
        ),
        child: SizedBox(
          width: size * 4.125,
          height: size * 4.125,
          child: ScaleTransition(
              scale: Tween(begin: 0.98, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: const CurveWave(),
                ),
              ),
              child: widget.child),
        ),
      ),
    );
  }
}

class Animated extends GetWidget<AnimatedController> {
  final Widget child;
  final AnimType animation;
  final Duration delay;
  final Duration duration;
  final double scaleStart;
  final double scaleEnd;

  const Animated({
    @required this.child,
    this.scaleStart,
    this.scaleEnd,
    this.animation = AnimType.SlideIn,
    this.duration = const Duration(seconds: 1),
    this.delay = const Duration(milliseconds: 0),
  });

  @override
  Widget build(BuildContext context) {
    if (animation == AnimType.Shake) {
      return TweenAnimationBuilder<double>(
          key: key,
          tween: Tween(begin: 0.0, end: 1.0),
          duration: 1.seconds,
          builder: (context, animation, child) => Transform.translate(
                offset: controller.shakeOffset(animation),
                child: child,
              ));
    } else if (animation == AnimType.SlideIn) {
      return TweenAnimationBuilder<Offset>(
        key: key,
        tween: Tween(begin: Offset.zero, end: Offset(0.0, 1.0)),
        duration: 1.seconds,
        builder: (context, animation, child) => Transform.translate(
          offset: animation,
          child: child,
        ),
      );
    }
    return child;
  }

  void scale() => controller.shake();
  void shake() => controller.shake();

  void reset() {
    controller.type(AnimType.None);
    controller.type.refresh();
  }
}

class AnimatedController extends GetxController {
  // Properties
  final type = AnimType.None.obs;

  // ^ Duration Returners ^ //
  Duration get shakeDuration => 1000.milliseconds;
  Duration get fadeInDuration => 250.milliseconds;
  Duration get fadeOutDuration => 150.milliseconds;

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

  // ^ Get Animated Offset for Shake Method ^ //
  Offset shakeOffset(double animation) {
    var shake = 2 * (0.5 - (0.5 - Curves.bounceOut.transform(animation)).abs());
    return Offset(18 * shake, 0);
  }
}

class AnimatedSlideSwitcher extends StatelessWidget {
  final AnimSwitch _animation;
  final Widget child;
  final Duration duration;

  // * Constructer * //
  const AnimatedSlideSwitcher(this._animation, this.child, this.duration);

  // * Factory Fade * //
  factory AnimatedSlideSwitcher.fade({@required child, Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
    return AnimatedSlideSwitcher(AnimSwitch.Fade, child, duration);
  }

  // * Factory Slide Up * //
  factory AnimatedSlideSwitcher.slideUp({@required child, Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
    return AnimatedSlideSwitcher(AnimSwitch.SlideUp, child, duration);
  }

  // * Factory Slide Down * //
  factory AnimatedSlideSwitcher.slideDown({@required child, Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
    return AnimatedSlideSwitcher(AnimSwitch.SlideDown, child, duration);
  }

  // * Factory Slide Left * //
  factory AnimatedSlideSwitcher.slideLeft({@required child, Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
    return AnimatedSlideSwitcher(AnimSwitch.SlideLeft, child, duration);
  }

  // * Factory Slide Right * //
  factory AnimatedSlideSwitcher.slideRight({@required child, Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
    return AnimatedSlideSwitcher(AnimSwitch.SlideRight, child, duration);
  }

  // ^ Build View Method ^ //
  @override
  Widget build(BuildContext context) {
    // Initialize Transition Map
    Map<AnimSwitch, Widget Function(Widget, Animation<double>)> transitionMap = {
      AnimSwitch.Fade: AnimatedSwitcher.defaultTransitionBuilder,
      AnimSwitch.SlideDown: _slideTransition(0, -1),
      AnimSwitch.SlideUp: _slideTransition(0, 1),
      AnimSwitch.SlideLeft: _slideTransition(-1, 0),
      AnimSwitch.SlideRight: _slideTransition(1, 0),
    };

    // Return Switcher
    return AnimatedSwitcher(
        duration: duration,
        switchOutCurve: Curves.easeInOutSine,
        switchInCurve: Curves.fastLinearToSlowEaseIn,
        transitionBuilder: transitionMap[_animation],
        layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
          return currentChild;
        },
        child: child);
  }

  // ^ Method Builds Slide Transition ^ //
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

// ^ Lottie Animation Container Widget ^ //
class LottieContainer extends StatefulWidget {
  final double width;
  final double height;
  final BoxFit fit;
  final LottieBoard type;
  final Function onComplete;
  final bool repeat;
  final bool animate;
  final bool reverse;
  const LottieContainer(
      {Key key,
      @required this.type,
      this.onComplete,
      this.width = 200,
      this.height = 200,
      this.fit = BoxFit.fill,
      this.repeat = false,
      this.animate = true,
      this.reverse = true})
      : super(key: key);
  @override
  _LottieContainerState createState() => _LottieContainerState();
}

class _LottieContainerState extends State<LottieContainer> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      _getPathFromBoard(),
      controller: _controller,
      width: widget.width,
      repeat: widget.repeat,
      reverse: widget.reverse,
      animate: widget.animate,
      height: widget.height,
      fit: BoxFit.contain,
      onLoaded: (composition) {
        _controller..duration = composition.seconds.seconds;
        if (widget.repeat) {
          _controller.repeat();
        } else {
          _controller.forward();
        }
      },
    );
  }

  _getPathFromBoard() {
    switch (widget.type) {
      case LottieBoard.Complete:
        return "assets/animations/lottie/complete.json";
        break;
      case LottieBoard.Empty:
        return "assets/animations/lottie/empty-lobby.json";
        break;
      case LottieBoard.Pending:
        return "assets/animations/lottie/pending.json";
        break;
      case LottieBoard.Progress:
        return "assets/animations/lottie/progress.json";
        break;
      case LottieBoard.Computer:
        return "assets/animations/lottie/computer.json";
        break;
      case LottieBoard.David:
        return "assets/animations/lottie/david.json";
        break;
      case LottieBoard.Phone:
        return "assets/animations/lottie/phone.json";
        break;
      case LottieBoard.Gallery:
        return "assets/animations/lottie/gallery.json";
        break;
      case LottieBoard.Progress_Alt:
        return "assets/animations/lottie/progress-alt.json";
        break;
      case LottieBoard.Camera:
        return "assets/animations/lottie/camera.json";
        break;
      case LottieBoard.Contact:
        return "assets/animations/lottie/contact.json";
        break;
    }
  }
}

// ^ Rive Animation Container Widget ^ //
class RiveContainer extends StatefulWidget {
  final double width;
  final double height;
  final RiveBoard type;
  final Widget placeholder;

  const RiveContainer({Key key, @required this.type, this.width = 55, this.height = 55, this.placeholder}) : super(key: key);
  @override
  _RiveContainer createState() => _RiveContainer();
}

class _RiveContainer extends State<RiveContainer> {
  // References
  final String _splashPath = 'assets/animations/rive/splash_screen.riv';
  final String _tilePath = 'assets/animations/rive/tile_preview.riv';
  final String _notFoundPath = 'assets/animations/rive/not_found.riv';
  final String _documentsPath = 'assets/animations/rive/documents.riv';

  // Properties
  Artboard _riveArtboard;

  // ** Constructer Initial ** //
  @override
  void initState() {
    // Load the RiveFile from the binary data.
    if (widget.type == RiveBoard.Splash) {
      rootBundle.load(_splashPath).then(
        (data) async {
          // Await Loading
          final file = RiveFile.import(data);

          // Retreive Artboard
          final artboard = file.mainArtboard;

          // Determine Animation by Tile Type
          artboard.addController(SimpleAnimation('Default'));
          setState(() => _riveArtboard = artboard);
        },
      );
    } else if (widget.type == RiveBoard.NotFound) {
      rootBundle.load(_notFoundPath).then(
        (data) async {
          // Await Loading
          final file = RiveFile.import(data);
          // Retreive Artboard
          final artboard = file.mainArtboard;

          // Determine Animation by Tile Type
          artboard.addController(SimpleAnimation('Default'));
          setState(() => _riveArtboard = artboard);
        },
      );
    } else if (widget.type == RiveBoard.Documents) {
      rootBundle.load(_documentsPath).then(
        (data) async {
          // Await Loading
          final file = RiveFile.import(data);
          // Retreive Artboard
          final artboard = file.mainArtboard;

          // Determine Animation by Tile Type
          artboard.addController(SimpleAnimation('Default'));
          setState(() => _riveArtboard = artboard);
        },
      );
    } else {
      rootBundle.load(_tilePath).then(
        (data) async {
          // Await Loading
          final file = RiveFile.import(data);
          // Retreive Artboard
          final artboard = file.mainArtboard;

          // Retreive Camera
          if (widget.type == RiveBoard.Camera) {
            artboard.addController(SimpleAnimation('Camera'));
          }

          // Retreive Showcase Loop
          else if (widget.type == RiveBoard.Gallery) {
            artboard.addController(SimpleAnimation('Showcase'));
          }
          // Retreive Showcase Loop
          else if (widget.type == RiveBoard.Feed) {
            artboard.addController(SimpleAnimation('Feed'));
          }
          // Retreive Icon Loop
          else {
            artboard.addController(SimpleAnimation('Icon'));
          }
          setState(() => _riveArtboard = artboard);
        },
      );
    }
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
                  artboard: _riveArtboard,
                )),
    );
  }
}
