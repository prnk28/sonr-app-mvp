// Major Constants
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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

Widget buildCenterBulb(double direction) {
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
              gradient: FlutterGradients.angelCare(type: GradientType.radial)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Stack(
              alignment: AlignmentDirectional.topEnd,
              clipBehavior: Clip.none,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 0, top: 5),
                    child: Text(
                      "°",
                      style: _bulbValueTextStyle(),
                    )),
                Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Text(
                      _getDirectionString(direction),
                      style: _bulbValueTextStyle(),
                    )),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(right: 6),
                child: Text(
                  _getCompassDesignation(direction),
                  style: _bulbDesignationTextStyle(),
                )),
          ])),
    ),
  );
}

// Direction Text
TextStyle _directionTextStyle({Color setColor}) {
  return TextStyle(
    fontFamily: "Raleway",
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: setColor ?? Colors.black87,
  );
}

// Bulb Direction
TextStyle _bulbValueTextStyle({Color setColor}) {
  return TextStyle(
    fontFamily: "Raleway",
    fontWeight: FontWeight.bold,
    fontSize: 46,
    color: setColor ?? Colors.white,
  );
}

// Bulb Designation
TextStyle _bulbDesignationTextStyle({Color setColor}) {
  return TextStyle(
    fontFamily: "Raleway",
    fontWeight: FontWeight.bold,
    fontSize: 18,
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

  // Add 0 for Aesthetic
  if (adjustedDegrees >= 0 && adjustedDegrees <= 9) {
    return "0" + "0" + adjustedDegrees.toString();
  } else if (adjustedDegrees > 9 && adjustedDegrees <= 99) {
    return "0" + adjustedDegrees.toString();
  } else {
    return adjustedDegrees.toString();
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