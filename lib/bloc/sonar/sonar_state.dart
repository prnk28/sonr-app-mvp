part of 'sonar_bloc.dart';

enum SonarBlocStatus {
  Initial,
  Ready,
  Loading,
  Sending,
  Receiving,
  Pending,
  PreTransfer,
  Failed,
  InProgress,
  Complete
}

abstract class SonarState extends Equatable {
  const SonarState({this.status});
  final SonarBlocStatus status;
  @override
  List<Object> get props => [status];
}

// ********************
// ** Preload State ***
// ********************
class Initial extends SonarState {
  final Motion currentMotion;
  final Direction currentDirection;
  const Initial(
      {this.currentMotion,
      this.currentDirection,
      status: SonarBlocStatus.Initial});
}

// ****************************
// ** Connected to Lobby/WS ***
// ****************************
class Ready extends SonarState {
  final Motion currentMotion;
  final Direction currentDirection;
  const Ready(
      {this.currentMotion,
      this.currentDirection,
      status: SonarBlocStatus.Ready});
}

// ********************************
// ** Between Reads from Server ***
// ********************************
class Loading extends SonarState {
  final Motion currentMotion;
  final Direction currentDirection;
  const Loading(
      {this.currentMotion,
      this.currentDirection,
      status: SonarBlocStatus.Loading});
}

// **************************
// ** In Sending Position ***
// **************************
class Sending extends SonarState {
  final Circle matches;
  final Motion currentMotion;
  final Direction currentDirection;
  const Sending(
      {this.matches,
      this.currentMotion,
      this.currentDirection,
      status: SonarBlocStatus.Sending});
}

// ****************************
// ** In Receiving Position ***
// ****************************
class Receiving extends SonarState {
  final Circle matches;
  final Motion currentMotion;
  final Direction currentDirection;
  const Receiving(
      {this.matches,
      this.currentMotion,
      this.currentDirection,
      status: SonarBlocStatus.Receiving});
}

// **********************************************
// ** After Request Pending Receiver Decision ***
// **********************************************
class Pending extends SonarState {
  final dynamic match;
  final TransferFile file;
  final dynamic offer;

  const Pending(
      {this.match, this.file, this.offer, status: SonarBlocStatus.Pending});
}

// *******************************************
// ** Post Authorization Receiver Accepted ***
// *******************************************
class PreTransfer extends SonarState {
  final dynamic profile;
  final String matchId;
  const PreTransfer(
      {this.profile, this.matchId, status: SonarBlocStatus.PreTransfer});
}

// *******************************************
// ** Post Authorization Receiver Declined ***
// *******************************************
class Failed extends SonarState {
  final dynamic profile;
  final String matchId;
  const Failed({this.profile, this.matchId, status: SonarBlocStatus.Failed});
}

// *********************************************
// ** In WebRTC Transfer or Contact Transfer ***
// *********************************************
class InProgress extends SonarState {
  final double progress;
  const InProgress({this.progress, status: SonarBlocStatus.InProgress});
}

// *************************
// ** Transfer Succesful ***
// *************************
class Complete extends SonarState {
  // Sender/Receiver
  final String deviceStatus;
  final File file;

  const Complete(this.deviceStatus,
      {this.file, status: SonarBlocStatus.Complete});
}
