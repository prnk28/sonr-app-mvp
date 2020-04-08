import 'package:equatable/equatable.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

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

// Sender Requests Authorization
class Request extends SonarEvent {
  final String id;
  const Request(this.id);
}

// Receiver Gets Authorization Request
class Offered extends SonarEvent {
  final dynamic profileData;
  final dynamic fileData;
  const Offered({this.profileData, this.fileData});
}

// Receiver Gets Authorization Request
class Authorize extends SonarEvent {
  final bool decision;
  final String matchId;
  const Authorize(this.decision, this.matchId);
}

// Receiver has Accepted
class Accepted extends SonarEvent {
  final dynamic profile;
  final String matchId;
  const Accepted(this.profile, this.matchId);
}

// Receiver has Declined
class Declined extends SonarEvent {
  final String matchId;
  final dynamic profile;
  const Declined(this.profile, this.matchId);
}

// Update Sensory Input
class Refresh extends SonarEvent {
  final Direction newDirection;

  Refresh({this.newDirection});
}
