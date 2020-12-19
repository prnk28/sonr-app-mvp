import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'transfer_controller.dart';
import 'dart:math';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:google_fonts/google_fonts.dart';

class CompassView extends GetView<TransferController> {
  CompassView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                          buildCenterBulb(controller.direction.value,
                              controller.gradient.value),

                          // Spokes
                          Transform.rotate(
                              angle: ((controller.direction.value ?? 0) *
                                  (pi / 180) *
                                  -1),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Stack(
                                  children: <Widget>[
                                    // ** <North> **//
                                    buildMajorSpoke(0,
                                        isNegativeAlignment: true,
                                        textColor: Colors.red[900],
                                        textValue: "N",
                                        textPadding: EdgeInsets.only(
                                            bottom: K_MAJOR_BOTTOM_PADDING)),
                                    // ** </North> **//

                                    // <MinorSpokes> //
                                    buildMinorSpoke(11.25),
                                    buildMinorSpoke(22.5),
                                    buildMinorSpoke(33.75),
                                    // </MinorSpokes> //

                                    // NorthEast
                                    buildAuxiliarySpoke(45),

                                    // <MinorSpokes> //
                                    buildMinorSpoke(56.25),
                                    buildMinorSpoke(67.5),
                                    buildMinorSpoke(78.75),
                                    // </MinorSpokes> //

                                    // ** <East> **//
                                    buildMajorSpoke(90,
                                        textValue: "W",
                                        textPadding: EdgeInsets.only(
                                            top: K_MAJOR_TOP_PADDING)),
                                    // ** </East> **//

                                    // <MinorSpokes> //
                                    buildMinorSpoke(101.25),
                                    buildMinorSpoke(112.5),
                                    buildMinorSpoke(123.75),
                                    // </MinorSpokes> //

                                    // SouthEast
                                    buildAuxiliarySpoke(135),

                                    // <MinorSpokes> //
                                    buildMinorSpoke(146.25),
                                    buildMinorSpoke(157.5),
                                    buildMinorSpoke(168.75),
                                    // </MinorSpokes> //

                                    // ** <South> **//
                                    buildMajorSpoke(180,
                                        isNegativeAlignment: true,
                                        textValue: "S",
                                        textPadding: EdgeInsets.only(
                                            bottom: K_MAJOR_BOTTOM_PADDING)),
                                    // ** </South> **//

                                    // <MinorSpokes> //
                                    buildMinorSpoke(191.25),
                                    buildMinorSpoke(202.5),
                                    buildMinorSpoke(213.75),
                                    // </MinorSpokes> //

                                    // SouthWest
                                    buildAuxiliarySpoke(225),

                                    // <MinorSpokes> //
                                    buildMinorSpoke(236.25),
                                    buildMinorSpoke(247.5),
                                    buildMinorSpoke(258.75),
                                    // </MinorSpokes> //

                                    // ** <West> **//
                                    buildMajorSpoke(270,
                                        textValue: "E",
                                        textPadding: EdgeInsets.only(
                                            top: K_MAJOR_TOP_PADDING)),
                                    // ** </West> **//

                                    // <MinorSpokes> //
                                    buildMinorSpoke(281.25),
                                    buildMinorSpoke(292.5),
                                    buildMinorSpoke(303.75),
                                    // </MinorSpokes> //

                                    // NorthWest
                                    buildAuxiliarySpoke(315),

                                    // <MinorSpokes> //
                                    buildMinorSpoke(326.25),
                                    buildMinorSpoke(337.5),
                                    buildMinorSpoke(348.75),
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
}

// ******************************* //
// *******----------------********* //
// ******| HELPER METHODS |******* //
// *******----------------******** //
// ******************************* //
const double _K_MAJOR_SPOKE_WIDTH = 18; // Spoke Length
const double K_MAJOR_TOP_PADDING = 45; // West, East
const double K_MAJOR_BOTTOM_PADDING = 20; // North, South

// Minor Constants
const double _K_MINOR_SPOKE_WIDTH = 12;

Widget buildMajorSpoke(
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
      alignment: directionToAlignment(multiplier * 1, direction),
      child: Stack(
        alignment: directionToAlignment(multiplier * 1, direction),
        children: [
          // Create Spoke
          RotationTransition(
              turns: new AlwaysStoppedAnimation(
                  directionToDegrees(direction) / 360),
              child: Padding(
                  padding: EdgeInsets.only(left: _K_MAJOR_SPOKE_WIDTH),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: 20,
                    ),
                    child: Container(
                      width: _K_MAJOR_SPOKE_WIDTH,
                      height: 1.5,
                      decoration: BoxDecoration(color: Colors.grey[700]),
                    ),
                  ))),
          // Create Text
          RotationTransition(
              turns: new AlwaysStoppedAnimation(
                  directionToDegrees(direction + 90) / 360),
              child: Padding(
                  padding: textPadding,
                  child: Text(textValue,
                      style: _directionTextStyle(setColor: textColor)))),
        ],
      ));
}

Widget buildAuxiliarySpoke(double direction) {
  return Align(
      alignment: directionToAlignment(-1, direction),
      child: RotationTransition(
        turns: new AlwaysStoppedAnimation(directionToDegrees(direction) / 360),
        child: Padding(
          padding: EdgeInsets.only(left: _K_MINOR_SPOKE_WIDTH),
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

Widget buildMinorSpoke(double direction) {
  return Align(
      alignment: directionToAlignment(-1, direction),
      child: RotationTransition(
        turns: new AlwaysStoppedAnimation(directionToDegrees(direction) / 360),
        child: Padding(
          padding: EdgeInsets.only(left: _K_MINOR_SPOKE_WIDTH),
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: 20,
            ),
            child: Container(
              width: _K_MINOR_SPOKE_WIDTH,
              height: 1,
              decoration: BoxDecoration(color: Colors.grey),
            ),
          ),
        ),
      ));
}

Widget buildCenterBulb(double direction, FlutterGradientNames gradient) {
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
      child: Container(
          decoration: BoxDecoration(
              gradient: FlutterGradients.findByName(gradient,
                  type: GradientType.radial)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _getDirectionString(direction),
                  style: _bulbValueTextStyle(),
                ),
                Text(
                  _getCompassDesignation(direction),
                  style: _bulbDesignationTextStyle(),
                ),
              ])),
    ),
  );
}

// Direction Text
TextStyle _directionTextStyle({Color setColor}) {
  return GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: setColor ?? Colors.black87,
  );
}

// Bulb Direction
TextStyle _bulbValueTextStyle({Color setColor}) {
  return GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 46,
    color: setColor ?? Colors.white,
  );
}

// Bulb Designation
TextStyle _bulbDesignationTextStyle({Color setColor}) {
  return GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: setColor ?? Colors.white,
  );
}

// ********************************
// ** Compass Designation Finder **
// ********************************
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

String _getCompassDesignation(double degrees) {
  var compassValue = ((degrees / 22.5) + 0.5).toInt();

  var compassEnum = CompassDesignation.values[(compassValue % 16)];
  return compassEnum
      .toString()
      .substring(compassEnum.toString().indexOf('.') + 1);
}

String _getDirectionString(double degrees) {
  // Round
  var adjustedDegrees = degrees.round();
  var unit = "°";

  // Add 0 for Aesthetic
  if (adjustedDegrees >= 0 && adjustedDegrees <= 9) {
    return "0" + "0" + adjustedDegrees.toString() + unit;
  } else if (adjustedDegrees > 9 && adjustedDegrees <= 99) {
    return "0" + adjustedDegrees.toString() + unit;
  } else {
    return adjustedDegrees.toString() + unit;
  }
}

// ********************
// ** Math Functions **
// ********************
num directionToRads(num deg) {
  return (directionToDegrees(deg) * pi) / 180.0;
}

double directionToDegrees(double direction) {
  if (direction + 90 > 360) {
    return direction - 270;
  } else {
    return direction + 90;
  }
}

Alignment directionToAlignment(double r, double deg) {
  // Calculate radians
  double radAngle = directionToRads(deg);

  double x = cos(radAngle) * r;
  double y = sin(radAngle) * r;
  return Alignment(x, y);
}
