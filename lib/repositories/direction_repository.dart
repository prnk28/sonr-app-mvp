import 'dart:async';

import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:flutter_compass/flutter_compass.dart';

class DirectionRepository {

  // Check Threshold of Direction
  Future<double> _getDegrees() async {
    // Init Vars
    double degrees = 0;
    ThresholdList degreeValues = new ThresholdList(4);

    // Handle Stream
    await for (double newDegrees in FlutterCompass.events) {
      if(!degreeValues.isValidated){
        
      }
    }

    return degrees;
  }

  double _getAntipodalDegrees(double degrees) {
    // Find Antipodal
    if (degrees >= 180) {
      return (360 - degrees);
    } else {
      return (degrees + 180);
    }
  }

  Future<Direction> getDirection() async {
    // Async Values
    double degrees = await _getDegrees();

    // Interpreted Values
    double antipodal = _getAntipodalDegrees(degrees);
    String designation = _getCompassDesignation(degrees);

    // Return Value
    return new Direction(degrees, designation, antipodal);
  }

  String _getCompassDesignation(double degrees) {
    // Set Compass Value
    var compassValue = ((degrees / 22.5) + 0.5).toInt();

    // Possible Values
    var compassArray = [
      "N",
      "NNE",
      "NE",
      "ENE",
      "E",
      "ESE",
      "SE",
      "SSE",
      "S",
      "SSW",
      "SW",
      "WSW",
      "W",
      "WNW",
      "NW",
      "NNW"
    ];
    return compassArray[(compassValue % 16)];
  }
}
