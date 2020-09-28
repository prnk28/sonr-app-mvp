import 'package:equatable/equatable.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/repository/repository.dart';

class Direction extends Equatable {
  // *******************
  // ** Sensor Values **
  // *******************
  final double degrees;
  final double antipodalDegrees;
  final DateTime lastUpdated;

  final String id;

// *********************
  // ** Constructor Var **
  // *********************
  const Direction(
      {this.id, this.degrees, this.antipodalDegrees, this.lastUpdated});

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [degrees, antipodalDegrees, lastUpdated, id];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Direction create({double degrees, double accelerometerX}) {
    if (accelerometerX != null) {
      return Direction(
          degrees: degrees,
          antipodalDegrees: _getAntipodalDegrees(degrees, accelerometerX),
          lastUpdated: DateTime.now());
    } else {
      return Direction(degrees: degrees, lastUpdated: DateTime.now());
    }
    // Both Events Provided
  }

  static Direction fromMap(Map data) {
    if (data["antipodal_degrees"] == null) {
      return Direction(
        id: data["id"],
        degrees: data["degrees"],
      );
    } else {
      return Direction(
        id: data["id"],
        degrees: data["degrees"],
        antipodalDegrees: data["antipodal_degrees"],
      );
    }
  }

  static double _getAntipodalDegrees(double degrees, double accelerometerX) {
    // Right Tilt
    if (accelerometerX < 0) {
      // Adjust by Degrees
      if (degrees < 270) {
        // Get Temp Value
        var temp = degrees + 90;

        // Get Reciprocal of Adjusted
        if (temp < 180) {
          return temp + 180;
        } else {
          return temp - 180;
        }
      } else {
        // Get Temp Value
        var temp = degrees - 270;

        // Get Reciprocal of Adjusted
        if (temp < 180) {
          return temp + 180;
        } else {
          return temp - 180;
        }
      }
    }
    // Left Tilt
    else {
      // Adjust by Degrees
      if (degrees < 90) {
        // Get Temp Value
        var temp = 270 - degrees;

        // Get Reciprocal of Adjusted
        if (temp < 180) {
          return temp + 180;
        } else {
          return temp - 180;
        }
      } else {
        // Get Temp Value
        var temp = degrees - 90;

        // Get Reciprocal of Adjusted
        if (temp < 180) {
          return temp + 180;
        } else {
          return temp - 180;
        }
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
    };
  }

  toSendMap() {
    return {
      'degrees': degrees,
    };
  }
}
