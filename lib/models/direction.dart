import 'package:equatable/equatable.dart';
import 'package:sonar_app/core/core.dart';

class Direction extends Equatable {
  // *******************
  // ** Sensor Values **
  // *******************
  final double degrees;
  final double antipodalDegrees;
  final CompassDesignation compassDesignation;
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
          compassDesignation: getCompassDesignationFromDegrees(degrees),
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

  // *********************
  // ** JSON Conversion **
  // *********************
  // Generation Method
  toJSON() {
    return {
      'degrees': degrees,
      'antipodal_degrees': antipodalDegrees,
      'compass_designation': compassDesignation.toString(),
      'last_updated': lastUpdated
    };
  }
}
