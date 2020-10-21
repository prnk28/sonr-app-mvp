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

// ***************************
// ** Between Server Reads ***
// ***************************
class Loading extends WebState {
  const Loading();
}

// ***************************
// ** Active for Receiving ***
// ***************************
class Available extends WebState {
  final Peer userNode;
  const Available(this.userNode);
}

// *****************************************
// ** Searching for Peer Sender/Receiver ***
// *****************************************
class Searching extends WebState {
  final Peer userNode;
  const Searching(this.userNode);
}

// ********************************
// ** Pending Receiver Decision ***
// ********************************
class Pending extends WebState {
  final Peer match;

  const Pending({
    this.match,
  });
}

// *******************************
// ** Received Offer from Peer ***
// *******************************
class Requested extends WebState {
  final dynamic offer;
  final Metadata metadata;
  final Peer from;

  const Requested(this.from, this.offer, this.metadata);
}

// *********************************************
// ** In WebRTC Transfer or Contact Transfer ***
// *********************************************
class Transferring extends WebState {
  final Peer match;

  const Transferring(this.match);
}

// *************************
// ** Transfer Succesful ***
// *************************
class Completed extends WebState {
  final Peer userNode;
  final File file;

  const Completed(
    this.userNode, {
    this.file,
  });
}

// *******************************************
// ** Post Authorization Receiver Declined ***
// *******************************************
class Failed extends WebState {
  const Failed();
}
