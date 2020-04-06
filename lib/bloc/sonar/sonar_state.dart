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
  const Pending({this.match});
}

// ********************************
// ** After Offered from Sender ***
// ********************************
class Offered extends SonarState {
  // Sender Data and File Metadata
  final dynamic match;
  final dynamic file;

  const Offered({this.match, this.file});
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

// *****************************************
// ** Failed Sonar: Cancel/Decline/Error ***
// *****************************************
class Failed extends SonarState {
  final Process runningProcess;
  final Motion currentMotion;
  final Direction currentDirection;
  const Failed(
      {this.runningProcess, this.currentMotion, this.currentDirection});
}
