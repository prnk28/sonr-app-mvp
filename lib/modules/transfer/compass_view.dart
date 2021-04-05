import 'dart:math';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'transfer_controller.dart';

// ** Build CompassView ** //
class CompassView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Stack(alignment: Alignment.topCenter, children: [
            // Compass Total
            AspectRatio(
              aspectRatio: 1,
              child: controller.isFacingPeer.value
                  ? RipplesAnimation(
                      child: _CompassView(),
                    )
                  : _CompassView(),
            ),

            // Ticker
            Padding(
                padding: EdgeInsets.only(top: 15),
                child: Neumorphic(
                  style: NeumorphicStyle(depth: -20, lightSource: LightSource.topRight, intensity: 0.75),
                  child: Container(
                    width: 3,
                    height: 36,
                    decoration: BoxDecoration(color: Colors.red[900]),
                  ),
                )),

            // Ticker Handle
            Padding(
                padding: EdgeInsets.only(top: 50),
                child: Neumorphic(
                  style: NeumorphicStyle(depth: -20, lightSource: LightSource.topRight, intensity: 0.75),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(color: Colors.red[900]),
                  ),
                )),
          ]));
    });
  }
}

class _CompassView extends GetView<TransferController> {
  const _CompassView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: EdgeInsets.all(14),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
      ),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 14,
          boxShape: NeumorphicBoxShape.circle(),
        ),
        margin: EdgeInsets.all(20),
        child: Neumorphic(
          style: NeumorphicStyle(
            depth: -8,
            boxShape: NeumorphicBoxShape.circle(),
          ),
          margin: EdgeInsets.all(10),
          // Interior Compass
          child: Stack(fit: StackFit.expand, alignment: Alignment.center, children: [
            // Center Circle
            Obx(() => _CompassBulb(controller.string.value, controller.heading.value,
                controller.isShiftingEnabled.value ? SonrGradient.bulbLight : SonrGradient.bulbDark)),

            // Spokes
            Obx(() => _Spokes(controller.angle.value)),
          ]),
        ),
      ),
    );
  }
}

// ** Builds Compass View Spokes ** //
enum SpokeType { Major, Minor, Aux }

class _Spokes extends HookWidget {
  final double angle;
  _Spokes(this.angle);
  @override
  Widget build(BuildContext context) {
    // Smoothly Rotate
    final controller = useAnimationController();

    // Build Spokes
    List<_Spoke> spokes = [];
    for (double i = 0; i <= 348.75; i += 11.25) {
      // Create Spokes
      spokes.add(_Spoke.fromList(i));
    }

    // Rotate Spokes on Direction
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        return Transform.rotate(angle: angle, child: child);
      },
      child: Padding(
        key: Key('animated-spokes'),
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: spokes,
        ),
      ),
    );
  }
}

class _Spoke extends StatelessWidget {
  final SpokeType type;
  final double direction;
  final double multiplier;
  final String textValue;
  final EdgeInsets textPadding;

  _Spoke(this.type, this.direction, {this.multiplier = 0.0, this.textValue = "", this.textPadding}) : assert(type != null);

  // ^ List Builder ^ //
  factory _Spoke.fromList(double i) {
    // Is North
    if (i == 0) {
      return (_Spoke.major(i));
    } else if (i % 45 == 0) {
      // Is Major
      if (i % 90 == 0) {
        return (_Spoke.major(i));
      }
      // Is Auxiliary
      else {
        return (_Spoke(SpokeType.Aux, i));
      }
    }
    // Is Minor
    else {
      return (_Spoke(SpokeType.Minor, i));
    }
  }

  // ^ Major Spoke ^ //
  // ignore: missing_return
  factory _Spoke.major(double dir) {
    // Padding Ref
    final double kMajorTopPadding = 45; // West, East
    final double kMajorBottomPadding = 20; // North, South

    // North
    if (dir == 0) {
      return (_Spoke(
        SpokeType.Major,
        0,
        multiplier: -1,
        textValue: "N",
        textPadding: EdgeInsets.only(bottom: kMajorBottomPadding),
      ));
    }
    // West
    else if (dir == 90) {
      return (_Spoke(
        SpokeType.Major,
        90,
        multiplier: 1,
        textValue: "W",
        textPadding: EdgeInsets.only(top: kMajorTopPadding),
      ));
    }
    // South
    else if (dir == 180) {
      return (_Spoke(
        SpokeType.Major,
        180,
        multiplier: -1,
        textValue: "S",
        textPadding: EdgeInsets.only(bottom: kMajorBottomPadding),
      ));
    }

    // East
    else if (dir == 270) {
      return (_Spoke(
        SpokeType.Major,
        270,
        multiplier: 1,
        textValue: "E",
        textPadding: EdgeInsets.only(top: kMajorTopPadding),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _kMajorSpokeWidth = 18; // Major Spoke Length
    final double _kMinorSpokeWidth = 12; // Minor Spoke Length

    // @ Major Spoke
    if (type == SpokeType.Major) {
      return Align(
          alignment: alignment(multiplier * 1, direction),
          child: Stack(
            alignment: alignment(multiplier * 1, direction),
            children: [
              // Create Spoke
              RotationTransition(
                  turns: new AlwaysStoppedAnimation(degrees(direction) / 360),
                  child: Padding(
                      padding: EdgeInsets.only(left: _kMajorSpokeWidth),
                      child: Neumorphic(
                        style: NeumorphicStyle(
                          depth: 20,
                        ),
                        child: Container(
                          width: _kMajorSpokeWidth,
                          height: 1.5,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                      ))),
              // Create Text
              RotationTransition(
                  turns: new AlwaysStoppedAnimation(degrees(direction + 90) / 360),
                  child: Padding(
                      padding: textPadding,
                      child: Text(textValue,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: UserService.isDarkMode ? Colors.white54 : Colors.black54,
                          )))),
            ],
          ));
    }
    // @ Minor Spoke
    else if (type == SpokeType.Minor) {
      return Align(
          alignment: alignment(-1, direction),
          child: RotationTransition(
            turns: new AlwaysStoppedAnimation(degrees(direction) / 360),
            child: Padding(
              padding: EdgeInsets.only(left: _kMinorSpokeWidth),
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: 20,
                ),
                child: Container(
                  width: _kMinorSpokeWidth,
                  height: 1,
                  decoration: BoxDecoration(color: Colors.grey),
                ),
              ),
            ),
          ));
    }
    // @ Aux Spoke
    else {
      return Align(
          alignment: alignment(-1, direction),
          child: RotationTransition(
            turns: new AlwaysStoppedAnimation(degrees(direction) / 360),
            child: Padding(
              padding: EdgeInsets.only(left: _kMinorSpokeWidth),
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: 20,
                ),
                child: Container(
                  width: 15,
                  height: 1.35,
                  decoration: BoxDecoration(color: Colors.grey),
                ),
              ),
            ),
          ));
    }
  }

  Alignment alignment(double r, double deg) {
    // Degrees
    if (deg + 90 > 360) {
      deg = deg - 270;
    } else {
      deg = deg + 90;
    }

    // Calculate radians
    double radAngle = (deg * pi) / 180.0;

    // Calculate radians
    double x = cos(radAngle) * r;
    double y = sin(radAngle) * r;
    return Alignment(x, y);
  }

  double degrees(double deg) {
    // Calculate Degrees
    if (deg + 90 > 360) {
      return (deg - 270);
    } else {
      return (deg + 90);
    }
  }
}

// ** Builds Compass View Bulb ** //
class _CompassBulb extends StatelessWidget {
  final String direction;
  final String heading;
  final Gradient gradient;
  _CompassBulb(this.direction, this.heading, this.gradient);
  @override
  Widget build(BuildContext context) {
    // Return View
    return Neumorphic(
        style: NeumorphicStyle(
          depth: -5,
          boxShape: NeumorphicBoxShape.circle(),
        ),
        margin: EdgeInsets.all(65),
        child: Neumorphic(
            style: NeumorphicStyle(
              depth: 10,
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            margin: EdgeInsets.all(7.5),
            child: AnimatedContainer(
                duration: Duration(seconds: 1),
                decoration: BoxDecoration(gradient: gradient),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  SonrText.gradient(
                    direction,
                    FlutterGradientNames.glassWater,
                    weight: FontWeight.w900,
                    size: 44,
                    key: ValueKey<String>(direction),
                  ),
                  AnimatedSlideSwitcher.slideDown(
                      child: SonrText.gradient(
                    heading,
                    FlutterGradientNames.glassWater,
                    weight: FontWeight.w300,
                    size: 24,
                    key: ValueKey<String>(heading),
                  ))
                ]))));
  }
}
