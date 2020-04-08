import 'package:equatable/equatable.dart';
import 'package:sonar_app/controllers/controllers.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/core/core.dart';

abstract class SonarState extends Equatable {
  const SonarState();
  @override
  List<Object> get props => [];
}

// ********************
// ** Preload State ***
// ********************
class Initial extends SonarState {
  final Motion currentMotion;
  final Direction currentDirection;
  const Initial({this.currentMotion, this.currentDirection});
}

// ****************************
// ** Connected to Lobby/WS ***
// ****************************
class Ready extends SonarState {
  final Process runningProcess;
  final Motion currentMotion;
  final Direction currentDirection;
  const Ready({this.runningProcess, this.currentMotion, this.currentDirection});
}

// ********************************
// ** Between Reads from Server ***
// ********************************
class Loading extends SonarState {
  final Motion currentMotion;
  final Direction currentDirection;
  const Loading({this.currentMotion, this.currentDirection});
}

// **************************
// ** In Sending Position ***
// **************************
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

// ****************************
// ** In Receiving Position ***
// ****************************
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

// **********************************************
// ** After Request Pending Receiver Decision ***
// **********************************************
class Pending extends SonarState {
  final dynamic match;
  final dynamic file;

  // Sender/Receiver
  final String status;

  const Pending(this.status, {this.match, this.file});
}

// *******************************************
// ** Post Authorization Receiver Accepted ***
// *******************************************
class PreTransfer extends SonarState {
  final dynamic profile;
  final String matchId;
  const PreTransfer({this.profile, this.matchId});
}

// *******************************************
// ** Post Authorization Receiver Declined ***
// *******************************************
class Failed extends SonarState {
  final dynamic profile;
  final String matchId;
  const Failed({this.profile, this.matchId});
}

// *********************************************
// ** In WebRTC Transfer or Contact Transfer ***
// *********************************************
class Transferring extends SonarState {
  final Process runningProcess;
  final Motion currentMotion;
  final Direction currentDirection;
  const Transferring(
      {this.runningProcess, this.currentMotion, this.currentDirection});
}

// *************************
// ** Transfer Succesful ***
// *************************
class Complete extends SonarState {
  final Process runningProcess;
  final Motion currentMotion;
  final Direction currentDirection;
  const Complete(
      {this.runningProcess, this.currentMotion, this.currentDirection});
}
