part of 'web_bloc.dart';

enum WebBlocStatus {
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

abstract class WebState extends Equatable {
  const WebState({this.status});
  final WebBlocStatus status;
  @override
  List<Object> get props => [status];
}

// ********************
// ** Preload State ***
// ********************
class Initial extends WebState {
  final Motion currentMotion;
  final Direction currentDirection;
  const Initial(
      {this.currentMotion,
      this.currentDirection,
      status: WebBlocStatus.Initial});
}

// ****************************
// ** Connected to Lobby/WS ***
// ****************************
class Ready extends WebState {
  final Motion currentMotion;
  final Direction currentDirection;
  const Ready(
      {this.currentMotion, this.currentDirection, status: WebBlocStatus.Ready});
}

// ********************************
// ** Between Reads from Server ***
// ********************************
class Loading extends WebState {
  final Motion currentMotion;
  final Direction currentDirection;
  const Loading(
      {this.currentMotion,
      this.currentDirection,
      status: WebBlocStatus.Loading});
}

// **************************
// ** In Sending Position ***
// **************************
class Sending extends WebState {
  final Circle matches;
  final Motion currentMotion;
  final Direction currentDirection;
  const Sending(
      {this.matches,
      this.currentMotion,
      this.currentDirection,
      status: WebBlocStatus.Sending});
}

// ****************************
// ** In Receiving Position ***
// ****************************
class Receiving extends WebState {
  final Circle matches;
  final Motion currentMotion;
  final Direction currentDirection;
  const Receiving(
      {this.matches,
      this.currentMotion,
      this.currentDirection,
      status: WebBlocStatus.Receiving});
}

// **********************************************
// ** After Request Pending Receiver Decision ***
// **********************************************
class Pending extends WebState {
  final dynamic match;
  final FileTransfer file;
  final dynamic offer;

  const Pending(
      {this.match, this.file, this.offer, status: WebBlocStatus.Pending});
}

// *******************************************
// ** Post Authorization Receiver Accepted ***
// *******************************************
class PreTransfer extends WebState {
  final dynamic profile;
  final String matchId;
  const PreTransfer(
      {this.profile, this.matchId, status: WebBlocStatus.PreTransfer});
}

// *******************************************
// ** Post Authorization Receiver Declined ***
// *******************************************
class Failed extends WebState {
  final dynamic profile;
  final String matchId;
  const Failed({this.profile, this.matchId, status: WebBlocStatus.Failed});
}

// *********************************************
// ** In WebRTC Transfer or Contact Transfer ***
// *********************************************
class InProgress extends WebState {
  final double progress;
  const InProgress({this.progress, status: WebBlocStatus.InProgress});
}

// *************************
// ** Transfer Succesful ***
// *************************
class Complete extends WebState {
  // Sender/Receiver
  final String deviceStatus;
  final File file;

  const Complete(this.deviceStatus,
      {this.file, status: WebBlocStatus.Complete});
}
