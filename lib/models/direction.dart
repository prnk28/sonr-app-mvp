import 'dart:developer';

class Direction {
  // Initial Variables
  final double degrees;

  // Resulting Variables
  double antipodalDegrees;
  String compassDesignation;

  // Constructor
  Direction(this.degrees) {
    // Set Antipodal
    if (this.degrees >= 180) {
      this.antipodalDegrees = 360 - degrees;
    } else {
      this.antipodalDegrees = degrees + 180;
    }

    // Set Designation
    var compassValue = ((this.degrees / 22.5) + 0.5).toInt();
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
    this.compassDesignation = compassArray[(compassValue % 16)];
    log(this.compassDesignation);
  }

  // JSON Generation
  toJSON() {
    return {
      'antipodal_degrees': antipodalDegrees.toString(),
      'compass_designation': compassDesignation,
      'degrees': degrees.toString()
    };
  }
}
