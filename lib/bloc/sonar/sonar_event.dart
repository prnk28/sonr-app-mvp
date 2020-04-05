import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/models/transfer.dart';

abstract class SonarEvent extends Equatable {
  const SonarEvent();

  @override
  List<Object> get props => [];
}

// *********************
// ** Single Events ****
// *********************
// Connect to WS, Join/Create Lobby
class Initialize extends SonarEvent {
  final Motion currentMotion;
  final Direction currentDirection;
  const Initialize({this.currentDirection, this.currentMotion});
}

// Send to Server Sequence
class Send extends SonarEvent {
  final Circle map;
  final Motion currentMotion;
  final Direction currentDirection;

  const Send({this.map, this.currentDirection, this.currentMotion});
}

// Receive to Server Sequence
class Receive extends SonarEvent {
  final Circle map;
  final Motion currentMotion;
  final Direction currentDirection;

  const Receive({this.map, this.currentDirection, this.currentMotion});
}

// Update Event
class Update extends SonarEvent {
  final Circle map;
  final Motion currentMotion;
  final Direction currentDirection;

  const Update({this.map, this.currentDirection, this.currentMotion});
}

// Tap Peer from List or Point to Receiver for 2s
class Select extends SonarEvent {
  final Client match;
  final Motion currentMotion;
  final Direction currentDirection;

  const Select(
      {@required this.match, this.currentDirection, this.currentMotion});
}

// Sender Requests Authorization
class Request extends SonarEvent {
  final Client match;
  final Motion currentMotion;
  final Direction currentDirection;

  const Request(
      {@required this.match, this.currentDirection, this.currentMotion});
}

// Receiver Offerred Sonar Transfer
class Offered extends SonarEvent {
  final bool decision;
  final Client sender;
  final Motion currentMotion;
  final Direction currentDirection;

  const Offered(
      {@required this.sender,
      @required this.decision,
      this.currentDirection,
      this.currentMotion});
}

// Authentication Success
class StartTransfer extends SonarEvent {
  final Transfer transfer;
  final Motion currentMotion;
  final Direction currentDirection;

  const StartTransfer(
      {@required this.transfer, this.currentDirection, this.currentMotion});
}

// Transfer Complete
class CompleteTransfer extends SonarEvent {
  final Transfer transfer;
  final Motion currentMotion;
  final Direction currentDirection;

  const CompleteTransfer(
      {@required this.transfer, this.currentDirection, this.currentMotion});
}

// Cancel on Button Tap
class CancelSonar extends SonarEvent {
  final Motion currentMotion;
  final Direction currentDirection;

  const CancelSonar({this.currentDirection, this.currentMotion});
}

// On Cancel, On Done, On Zero
class ResetSonar extends SonarEvent {
  final Motion currentMotion;
  final Direction currentDirection;

  const ResetSonar({this.currentDirection, this.currentMotion});
}

// Update Sensory Input
class CompareDirections extends SonarEvent {
  final Direction lastDirection;
  final Direction newDirection;

  CompareDirections(this.lastDirection, this.newDirection);
}

// Update Sensory Input
class Refresh extends SonarEvent {
  final Direction newDirection;

  Refresh({this.newDirection});
}
