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
  const Direction(
      {this.degrees,
      this.antipodalDegrees,
      this.compassDesignation,
      this.lastUpdated});

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props =>
      [degrees, antipodalDegrees, compassDesignation, lastUpdated];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Direction create({double degrees, double accelerometerX}) {
    if (accelerometerX != null) {
      return Direction(
          degrees: degrees,
          antipodalDegrees: _getAntipodalDegrees(degrees, accelerometerX),
          compassDesignation: getCompassDesignationFromDegrees(degrees),
          lastUpdated: DateTime.now());
    } else {
      return Direction(
          degrees: degrees,
          compassDesignation: getCompassDesignationFromDegrees(degrees),
          lastUpdated: DateTime.now());
    }
    // Both Events Provided
  }

  // Create Object from Events
  static Direction fromMap(Map data) {
    return Direction(
        degrees: data["degrees"],
        antipodalDegrees: data["antipodal_degrees"],
        compassDesignation: data["compass_designation"],
        lastUpdated: data["last_updated"]);
  }

  static double _getAntipodalDegrees(double degrees, double accelerometerX) {
    // Right Tilt
    if (accelerometerX < 0) {
      // Adjust by Degrees
      if(degrees < 270){
        return (degrees + 90);
      }else{
        return (degrees - 270);
      }
    }
    // Left Tilt
    else {
      // Adjust by Degrees
      if(degrees < 90){
        return (270 - degrees);
      }else{
        return (degrees - 90);
      }
    }
  }

  // *********************
  // ** JSON Conversion **
  // *********************
  // Generation Method
  toReceiveMap() {
    return {
      'degrees': degrees,
      'antipodal_degrees': antipodalDegrees,
      'compass_designation': compassDesignation.toString(),
    };
  }

  toSendMap() {
    return {
      'degrees': degrees,
      'compass_designation': compassDesignation.toString(),
    };
  }
}
