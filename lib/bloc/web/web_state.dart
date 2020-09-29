part of 'web_bloc.dart';

abstract class WebState extends Equatable {
  const WebState();
  @override
  List<Object> get props => [];
}

// ********************
// ** Preload State ***
// ********************
class Disconnected extends WebState {
  const Disconnected();
}

// ****************************
// ** Connected to Lobby/WS ***
// ****************************
class Connected extends WebState {
  const Connected();
}

// ********************************
// ** Between Reads from Server ***
// ********************************
class Loading extends WebState {
  const Loading();
}

// **********************************
// ** On Socket Event from Server ***
// **********************************
class HandleSocketEvent extends WebState {
  const HandleSocketEvent();
}

// *****************************************
// ** Searching for Peer Sender/Receiver ***
// *****************************************
class Searching extends WebState {
  const Searching();
}

// **********************************************
// ** After Request Pending Receiver Decision ***
// **********************************************
class Pending extends WebState {
  final dynamic match;
  final FileTransfer file;
  final dynamic offer;

  const Pending({
    this.match,
    this.file,
    this.offer,
  });
}

// *******************************************
// ** Post Authorization Receiver Accepted ***
// *******************************************
class PreTransfer extends WebState {
  final dynamic profile;
  final String matchId;
  const PreTransfer({
    this.profile,
    this.matchId,
  });
}

// *******************************************
// ** Post Authorization Receiver Declined ***
// *******************************************
class Failed extends WebState {
  final dynamic profile;
  final String matchId;
  const Failed({
    this.profile,
    this.matchId,
  });
}

// *********************************************
// ** In WebRTC Transfer or Contact Transfer ***
// *********************************************
class InProgress extends WebState {
  final double progress;
  const InProgress({
    this.progress,
  });
}

// *************************
// ** Transfer Succesful ***
// *************************
class Complete extends WebState {
  // Sender/Receiver
  final String deviceStatus;
  final File file;

  const Complete(
    this.deviceStatus, {
    this.file,
  });
}
