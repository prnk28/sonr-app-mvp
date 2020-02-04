// *******************
// ** GLOBAL ENUMS ***
// *******************
// Authentication Status for Sonar Process
enum AuthenticationStatus { Accepted, Declined, Default }

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

// Kind of Data Model Returned from Server
enum DataType { AuthorizationStatus, Circle, Client, Lobby, Match, None }

// Sonar Process Failed
enum FailType { None, MatchDeclined, UserCancelled, ServerError, NetworkError }

// Kind of File Sent from Sender
enum FileType { Contact, Photo, Video, Document, Unknown }

// Incoming Message: Type
enum IncomingMessageDataType {
  Info,
  Lobby,
  Senders,
  Receivers,
  Match,
  Error,
}

// Device Motion
enum Orientation { Default, Tilt, LandscapeLeft, LandscapeRight }

// Outgoing Message: Action
enum OutgoingMessageAction {
  Initialize,
  Sending,
  Receiving,
  Select,
  Request,
  Authorize,
  Transfer,
  Complete,
  Cancel,
  Error,
}

// Stage in Sonar Transfer
enum SonarStage {
  Connected,
  Ready,
  Sending,
  Receiving,
  Found,
  Pending,
  Transferring,
  Complete,
  Error
}

// ****************************
// ** Enum Centric Methods ****
// ****************************
// Used by Message Model
IncomingMessageDataType getMessageDataTypeFromString(String type) {
  type = 'IncomingMessageType.$type';
  return IncomingMessageDataType.values
      .firstWhere((f) => f.toString() == type, orElse: () => null);
}

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

// Used by Process Model
SonarStage getSonarStageFromString(String stage) {
  stage = 'SonarStage.$stage';
  return SonarStage.values
      .firstWhere((f) => f.toString() == stage, orElse: () => null);
}

// File Type from Strong
FileType getFileTypeFromString(String type) {
  type = 'FileType.$type';
  return FileType.values
      .firstWhere((f) => f.toString() == type, orElse: () => null);
}

// Used by Process Model
String getMessageForFailType(FailType failType) {
  // Message by enum to be displayed
  switch (failType) {
    case FailType.MatchDeclined:
      return "Match has declined to have Sonar Transfer.";
    case FailType.UserCancelled:
      return "Sonar Cancelled.";
    case FailType.ServerError:
      return "Server Error, Sonar can't be used right now.";
    case FailType.NetworkError:
      return "Your Device is having trouble connecting to the Internet.";
    default:
      return "";
  }
}

// Fail Type from Sonar Code
FailType getFailTypeFromCode(int code) {
  if (code == 40) {
    return FailType.UserCancelled;
  } else if (code == 41 || code == 31 || code == 44) {
    return FailType.ServerError;
  } else if (code == 52) {
    return FailType.MatchDeclined;
  } else {
    return FailType.None;
  }
}
