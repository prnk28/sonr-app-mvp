import 'package:equatable/equatable.dart';
import 'package:sonar_app/controllers/controllers.dart';
import 'package:sonar_app/models/models.dart';

abstract class SonarState extends Equatable {
  const SonarState();
  @override
  List<Object> get props => [];
}

// Preload State
class Initial extends SonarState {
  final Motion currentMotion;
  final Direction currentDirection;
  const Initial({this.currentMotion, this.currentDirection});
}

// Connected to Lobby/WS
class Ready extends SonarState {
  final Process runningProcess;
  final Motion currentMotion;
  final Direction currentDirection;
  const Ready({this.runningProcess, this.currentMotion, this.currentDirection});
}

// In Sending Position
class Sending extends SonarState {
  final Process runningProcess;
  final Circle matches;
  final Motion currentMotion;
  final Direction currentDirection;
  const Sending(
      {this.runningProcess,
      this.matches,
      this.currentMotion,
      this.currentDirection});
}

// In Receiving Position
class Receiving extends SonarState {
  final Process runningProcess;
  final Circle matches;
  final Motion currentMotion;
  final Direction currentDirection;
  const Receiving(
      {this.runningProcess,
      this.matches,
      this.currentMotion,
      this.currentDirection});
}

class Loading extends SonarState {
  final Motion currentMotion;
  final Direction currentDirection;
  const Loading({this.currentMotion, this.currentDirection});
}

// Found Match: Either Select or AutoSelect
class Found extends SonarState {
  final Process runningProcess;
  final Motion currentMotion;
  final Direction currentDirection;
  const Found({this.runningProcess, this.currentMotion, this.currentDirection});
}

// Pending Transfer Confirmation
class Authenticating extends SonarState {
  final Process runningProcess;
  final Motion currentMotion;
  final Direction currentDirection;
  const Authenticating(
      {this.runningProcess, this.currentMotion, this.currentDirection});
}

// In WebRTC Transfer or Contact Transfer
class Transferring extends SonarState {
  final Process runningProcess;
  final Motion currentMotion;
  final Direction currentDirection;
  const Transferring(
      {this.runningProcess, this.currentMotion, this.currentDirection});
}

// Transfer Succesful
class Complete extends SonarState {
  final Process runningProcess;
  final Motion currentMotion;
  final Direction currentDirection;
  const Complete(
      {this.runningProcess, this.currentMotion, this.currentDirection});
}

// Failed Sonar: Cancel/Decline/Error
class Failed extends SonarState {
  final Process runningProcess;
  final Motion currentMotion;
  final Direction currentDirection;
  const Failed(
      {this.runningProcess, this.currentMotion, this.currentDirection});
}
