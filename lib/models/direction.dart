import 'package:equatable/equatable.dart';

class Direction extends Equatable {
  // *******************
  // ** Sensor Values **
  // *******************
  final double degrees;
  final double antipodalDegrees;
  final String compassDesignation;
  final DateTime lastUpdated;

// *********************
  // ** Constructor Var **
  // *********************
  const Direction({
    this.degrees,
    this.antipodalDegrees,
    this.compassDesignation,
    this.lastUpdated
  });

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [
    degrees,
    antipodalDegrees,
    compassDesignation,
    lastUpdated
      ];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Direction create({double degrees}) {
    // Both Events Provided
      return Direction(
          degrees: degrees,
          antipodalDegrees: _getAntipodalDegrees(degrees),
          compassDesignation: _getCompassDesignation(degrees),
          lastUpdated: DateTime.now());
  }

  static double _getAntipodalDegrees(double degrees) {
    // Find Antipodal
    if (degrees >= 180) {
      return (360 - degrees);
    } else {
      return (degrees + 180);
    }
  }

  static String _getCompassDesignation(double degrees) {
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

  // *********************
  // ** JSON Conversion **
  // *********************
  // Generation Method
  toJSON() {
    return {
      'degrees': degrees,
      'antipodal_degrees': antipodalDegrees,
      'compass_designation': compassDesignation,
      'last_updated': lastUpdated
    };
  }
}
