part of 'signal_bloc.dart';

abstract class SignalState extends Equatable {
  const SignalState();
  @override
  List<Object> get props => [];
}

// ********************
// ** Preload State ***
// ********************
class SocketInitial extends SignalState {
  const SocketInitial();
}

// ***************************
// ** Between Server Reads ***
// ***************************
class SocketLoadInProgress extends SignalState {
  const SocketLoadInProgress();
}

// ***************************
// ** After Handling Event ***
// ***************************
class SocketLoadSuccess extends SignalState {
  const SocketLoadSuccess();
}

// ***************************
// ** Active for Receiving ***
// ***************************
class Available extends SignalState {
  final Peer userNode;
  const Available(this.userNode);
}

// *****************************************
// ** Searching for Peer Sender/Receiver ***
// *****************************************
class Searching extends SignalState {
  final Peer userNode;
  const Searching(this.userNode);
}

// ********************************
// ** Pending Receiver Decision ***
// ********************************
class Pending extends SignalState {
  final Peer match;

  const Pending({
    this.match,
  });
}

// *******************************
// ** Received Offer from Peer ***
// *******************************
class Requested extends SignalState {
  final dynamic offer;
  final Metadata metadata;
  final Peer from;

  const Requested(this.from, this.offer, this.metadata);
}

// *********************************************
// ** In WebRTC Transfer or Contact Transfer ***
// *********************************************
class Transferring extends SignalState {
  final Peer match;

  const Transferring(this.match);
}

// *************************
// ** Transfer Succesful ***
// *************************
class Completed extends SignalState {
  final Peer userNode;
  final SonrFile file;

  const Completed(
    this.userNode, {
    this.file,
  });
}

// *******************************************
// ** Post Authorization Receiver Declined ***
// *******************************************
class Failed extends SignalState {
  const Failed();
}
