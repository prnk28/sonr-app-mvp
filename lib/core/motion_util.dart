// *******************
// ** Motion Enums ***
// *******************
// Device Heading Postion
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

// Device Motion Orientation
enum Orientation { Default, Tilt, LandscapeLeft, LandscapeRight }

// ****************************
// ** Enum Centric Methods ****
// ****************************
// Used by Direction Model
CompassDesignation getCompassDesignationFromDegrees(double degrees) {
  var compassValue = ((degrees / 22.5) + 0.5).toInt();

  return CompassDesignation.values[(compassValue % 16)];
}

// Used in Motion Model
Orientation getOrientationFromAccelerometer(double x, double y) {
  // Set Sonar State by Accelerometer
  if (x > 7.5) {
    return Orientation.LandscapeLeft;
  } else if (x < -7.5) {
    return Orientation.LandscapeRight;
  } else {
    // Detect Position for Default and Tilt
    if (y > 4.1) {
      return Orientation.Default;
    } else {
      return Orientation.Tilt;
    }
  }
}
