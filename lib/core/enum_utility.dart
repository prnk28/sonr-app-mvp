// *******************
// ** GLOBAL ENUMS ***
// *******************
enum MessageCategory {
  Initialization,
  Lobby,
  Sender,
  Receiver,
  Authorization,
  WebRTC,
  Error,
}

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

enum Orientation { ZERO, SEND, RECEIVE }

// ****************************
// ** Enum Centric Methods ****
// ****************************
// Used by Message Model
MessageCategory getMessageCategoryFromString(String message) {
  message = 'MessageCategory.$message';
  return MessageCategory.values
      .firstWhere((f) => f.toString() == message, orElse: () => null);
}

// Used by Direction Model
CompassDesignation getCompassDesignationFromDegrees(double degrees) {
  var compassValue = ((degrees / 22.5) + 0.5).toInt();

  return CompassDesignation.values[(compassValue % 16)];
}

// Used in Motion Model
Orientation getOrientationFromAccelerometer(double x, double y) {
  // Set Sonar State by Accelerometer
  if (x > 7.5 || x < -7.5) {
    return Orientation.RECEIVE;
  } else {
    // Detect Position for Zero and Send
    if (y > 4.1) {
      return Orientation.ZERO;
    } else {
      return Orientation.SEND;
    }
  }
}
