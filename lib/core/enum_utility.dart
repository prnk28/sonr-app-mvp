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
  Decline,
  Transfer,
  Complete,
  Cancel,
}

// Stage in Sonar Transfer
enum SonarStage {
  // Initial
  CONNECTED,
  READY,
  // Sending
  SENDING,
  SENDER_MATCH_FOUND,
  SENDER_MATCH_SELECTED,
  SENDER_MATCH_PENDING,
  // Receiving
  RECEIVING,
  RECEIVER_OFFERED,
  RECEIVER_AUTHORIZED,
  RECEIVER_DECLINED,

  // Transfer
  TRANSFERRING,
  TRANSFER_STOP,
  TRANSFER_COMPLETE,
  
  // Errors
  ERROR_RECEIVER_DECLINED,
  ERROR_SENDER_CANCELLED,
  ERROR_SENDER_TIMEOUT,
  ERROR_TRANSFER_FAIL,
  ERROR_WS_DOWN
}

// ****************************
// ** Enum Centric Methods ****
// ****************************
// Used by Message Model
IncomingMessageDataType getDataTypeFromString(String type) {
  type = 'IncomingMessageDataType.$type';
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

// Get Action for OutgoingMessageAction
String getShortMessageAction(OutgoingMessageAction action) {
  // Switch of Action
  switch (action) {
    case OutgoingMessageAction.Initialize:
      return "INITIALIZE";
    case OutgoingMessageAction.Sending:
      return "SENDING";
    case OutgoingMessageAction.Receiving:
      return "RECEIVING";
    case OutgoingMessageAction.Select:
      return "SELECT";
    case OutgoingMessageAction.Request:
      return "REQUEST";
    case OutgoingMessageAction.Authorize:
      return "AUTHORIZE";
    case OutgoingMessageAction.Decline:
      return "DECLINE";
    case OutgoingMessageAction.Transfer:
      return "TRANSFER";
    case OutgoingMessageAction.Complete:
      return "COMPLETE";
    case OutgoingMessageAction.Cancel:
      return "CANCEL";
  }
  return "NONE";
}
