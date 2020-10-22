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
// ** After Handling Event ***
// ***************************
class SocketSuccess extends SignalState {
  const SocketSuccess();
}

class SocketFailure extends SignalState {
  const SocketFailure();
}

// ***************************
// ** Active for Receiving ***
// ***************************
class Available extends SignalState {
  final Node userNode;
  const Available(this.userNode);
}

// *****************************************
// ** Searching for Peer Sender/Receiver ***
// *****************************************
class Searching extends SignalState {
  final Node userNode;
  const Searching(this.userNode);
}

// ********************************
// ** Pending Receiver Decision ***
// ********************************
class Pending extends SignalState {
  final Node match;

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
  final Node from;

  const Requested(this.from, this.offer, this.metadata);
}

// *********************************************
// ** In WebRTC Transfer or Contact Transfer ***
// *********************************************
class Transferring extends SignalState {
  final Node match;

  const Transferring(this.match);
}

// *************************
// ** Transfer Succesful ***
// *************************
class Completed extends SignalState {
  final Node userNode;
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
