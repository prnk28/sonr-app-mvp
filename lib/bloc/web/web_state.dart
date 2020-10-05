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

// ***************************
// ** Between Server Reads ***
// ***************************
class Loading extends WebState {
  const Loading();
}

// *****************************************
// ** Searching for Peer Sender/Receiver ***
// *****************************************
class Searching extends WebState {
  final PathFinder pathfinder;
  final bool isReceiver;
  const Searching(this.isReceiver, {this.pathfinder});
}

// **********************************************
// ** After Request Pending Receiver Decision ***
// **********************************************
class Pending extends WebState {
  final Peer match;
  final Metadata fileMeta;
  final dynamic offer;
  final bool isReceiver;

  const Pending(
    this.isReceiver, {
    this.offer,
    this.match,
    this.fileMeta,
  });
}

// *********************************************
// ** In WebRTC Transfer or Contact Transfer ***
// *********************************************
class Transferring extends WebState {
  const Transferring();
}

// *************************
// ** Transfer Succesful ***
// *************************
class Completed extends WebState {
  // Sender/Receiver
  final String deviceStatus;
  final File file;

  const Completed(
    this.deviceStatus, {
    this.file,
  });
}

// *******************************************
// ** Post Authorization Receiver Declined ***
// *******************************************
class Failed extends WebState {
  const Failed();
}
