import 'package:sonar_app/models/models.dart';
import 'package:flutter_compass/flutter_compass.dart';

class DirectionRepository {
  double _getAntipodalDegrees(double degrees) {
    // Initial Value
    double result;

    // Set Antipodal
    if (degrees >= 180) {  
      result = 360 - degrees;
    } else {
      result = degrees + 180;
    }

    // Return Value
    return result;
  }

  Direction getDirection(double degrees) {
    double antipodal = _getAntipodalDegrees(degrees);
    String designation = _getCompassDesignation(degrees);
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
