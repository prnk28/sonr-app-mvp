import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'compass_controller.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

// ^ Build Compass View ^ //
class CompassView extends GetView<CompassController> {
  final double _kMajorSpokeWidth = 18; // Spoke Length
  final double _kMajorTopPadding = 45; // West, East
  final double _kMajorBottomPadding = 20; // North, South
  final double _kMinorSpokeWidth = 12; // Minor Spoke Length

  CompassView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final direction = controller.direction.value;
      return Align(
          alignment: Alignment.bottomCenter,
          child: Stack(alignment: Alignment.topCenter, children: [
            // Compass Total
            AspectRatio(
              aspectRatio: 1,
              child: Neumorphic(
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
                    child: Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          // Center Circle
                          _CompassBulb(),

                          // Spokes
                          Transform.rotate(
                              angle: ((direction ?? 0) * (pi / 180) * -1),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Stack(
                                  children: <Widget>[
                                    // ** <North> **//
                                    _buildMajorSpoke(0,
                                        isNegativeAlignment: true,
                                        textColor: Colors.red[900],
                                        textValue: "N",
                                        textPadding: EdgeInsets.only(
                                            bottom: _kMajorBottomPadding)),
                                    // ** </North> **//

                                    // <MinorSpokes> //
                                    _buildMinorSpoke(11.25),
                                    _buildMinorSpoke(22.5),
                                    _buildMinorSpoke(33.75),
                                    // </MinorSpokes> //

                                    // NorthEast
                                    _buildAuxiliarySpoke(45),

                                    // <MinorSpokes> //
                                    _buildMinorSpoke(56.25),
                                    _buildMinorSpoke(67.5),
                                    _buildMinorSpoke(78.75),
                                    // </MinorSpokes> //

                                    // ** <East> **//
                                    _buildMajorSpoke(90,
                                        textValue: "W",
                                        textPadding: EdgeInsets.only(
                                            top: _kMajorTopPadding)),
                                    // ** </East> **//

                                    // <MinorSpokes> //
                                    _buildMinorSpoke(101.25),
                                    _buildMinorSpoke(112.5),
                                    _buildMinorSpoke(123.75),
                                    // </MinorSpokes> //

                                    // SouthEast
                                    _buildAuxiliarySpoke(135),

                                    // <MinorSpokes> //
                                    _buildMinorSpoke(146.25),
                                    _buildMinorSpoke(157.5),
                                    _buildMinorSpoke(168.75),
                                    // </MinorSpokes> //

                                    // ** <South> **//
                                    _buildMajorSpoke(180,
                                        isNegativeAlignment: true,
                                        textValue: "S",
                                        textPadding: EdgeInsets.only(
                                            bottom: _kMajorBottomPadding)),
                                    // ** </South> **//

                                    // <MinorSpokes> //
                                    _buildMinorSpoke(191.25),
                                    _buildMinorSpoke(202.5),
                                    _buildMinorSpoke(213.75),
                                    // </MinorSpokes> //

                                    // SouthWest
                                    _buildAuxiliarySpoke(225),

                                    // <MinorSpokes> //
                                    _buildMinorSpoke(236.25),
                                    _buildMinorSpoke(247.5),
                                    _buildMinorSpoke(258.75),
                                    // </MinorSpokes> //

                                    // ** <West> **//
                                    _buildMajorSpoke(270,
                                        textValue: "E",
                                        textPadding: EdgeInsets.only(
                                            top: _kMajorTopPadding)),
                                    // ** </West> **//

                                    // <MinorSpokes> //
                                    _buildMinorSpoke(281.25),
                                    _buildMinorSpoke(292.5),
                                    _buildMinorSpoke(303.75),
                                    // </MinorSpokes> //

                                    // NorthWest
                                    _buildAuxiliarySpoke(315),

                                    // <MinorSpokes> //
                                    _buildMinorSpoke(326.25),
                                    _buildMinorSpoke(337.5),
                                    _buildMinorSpoke(348.75),
                                    // </MinorSpokes> //
                                  ],
                                ),
                              )),
                        ]),
                  ),
                ),
              ),
            ),

            // Ticker
            Padding(
                padding: EdgeInsets.only(top: 15),
                child: Neumorphic(
                  style: NeumorphicStyle(
                      depth: -20,
                      lightSource: LightSource.topRight,
                      intensity: 0.75),
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
                  style: NeumorphicStyle(
                      depth: -20,
                      lightSource: LightSource.topRight,
                      intensity: 0.75),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(color: Colors.red[900]),
                  ),
                )),
          ]));
    });
  }

  Widget _buildMajorSpoke(
    double direction, {
    bool isNegativeAlignment = false,
    Color textColor = Colors.black54,
    String textValue,
    EdgeInsets textPadding,
  }) {
    // Check Negative Alignment
    double multiplier;
    if (isNegativeAlignment) {
      multiplier = -1;
    } else {
      multiplier = 1;
    }
    // Build Major Spoke
    return Align(
        alignment: _directionToAlignment(multiplier * 1, direction),
        child: Stack(
          alignment: _directionToAlignment(multiplier * 1, direction),
          children: [
            // Create Spoke
            RotationTransition(
                turns: new AlwaysStoppedAnimation(
                    _directionToDegrees(direction) / 360),
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
                turns: new AlwaysStoppedAnimation(
                    _directionToDegrees(direction + 90) / 360),
                child: Padding(
                    padding: textPadding,
                    child: Text(textValue,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black54,
                        )))),
          ],
        ));
  }

  Widget _buildMinorSpoke(double direction) {
    return Align(
        alignment: _directionToAlignment(-1, direction),
        child: RotationTransition(
          turns:
              new AlwaysStoppedAnimation(_directionToDegrees(direction) / 360),
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

  Widget _buildAuxiliarySpoke(double direction) {
    return Align(
        alignment: _directionToAlignment(-1, direction),
        child: RotationTransition(
          turns:
              new AlwaysStoppedAnimation(_directionToDegrees(direction) / 360),
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

  num _directionToRads(num deg) {
    return (_directionToDegrees(deg) * pi) / 180.0;
  }

  double _directionToDegrees(double direction) {
    if (direction + 90 > 360) {
      return direction - 270;
    } else {
      return direction + 90;
    }
  }

  Alignment _directionToAlignment(double r, double deg) {
    // Calculate radians
    double radAngle = _directionToRads(deg);

    double x = cos(radAngle) * r;
    double y = sin(radAngle) * r;
    return Alignment(x, y);
  }
}

// ^ Center Compass Bulb ^ //
// ** Compass Designation Enum **
enum CompassDesignation {
  N,
  NNE,
  NE,
  ENE,
  E,
  ESE,
  SE,
  SSE,
  S,
  SSW,
  SW,
  WSW,
  W,
  WNW,
  NW,
  NNW
}

class _CompassBulb extends HookWidget {
  // @ Builder Method
  @override
  Widget build(BuildContext context) {
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
        child: Obx(() {
          // @ Get Data
          double direction = Get.find<CompassController>().direction.value;
          List<Gradient> gradients = Get.find<CompassController>().gradients;

          // @ Initialize
          String dirString;
          String desString;
          var adjustedDegrees = direction.round();
          var adjustedDesignation = ((direction / 22.5) + 0.5).toInt();
          var unit = "°";

          // @ Convert To String
          if (adjustedDegrees >= 0 && adjustedDegrees <= 9) {
            dirString = "0" + "0" + adjustedDegrees.toString() + unit;
          } else if (adjustedDegrees > 9 && adjustedDegrees <= 99) {
            dirString = "0" + adjustedDegrees.toString() + unit;
          } else {
            dirString = adjustedDegrees.toString() + unit;
          }

          // @ Get Designation Value
          var compassEnum =
              CompassDesignation.values[(adjustedDesignation % 16)];
          desString = compassEnum
              .toString()
              .substring(compassEnum.toString().indexOf('.') + 1);

          // @ Build View
          return Container(
              decoration:
                  BoxDecoration(gradient: useAnimatedGradient(gradients)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                        duration: Duration(milliseconds: 250),
                        child: Text(
                          dirString,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 46,
                            color: Colors.white,
                          ),
                        )),
                    AnimatedSwitcher(
                        duration: Duration(milliseconds: 250),
                        child: Text(
                          desString,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ))
                  ]));
        }),
      ),
    );
  }
}
