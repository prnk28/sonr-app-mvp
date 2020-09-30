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

// *****************************************
// ** Searching for Peer Sender/Receiver ***
// *****************************************
class Searching extends WebState {
  final Peer closest;
  const Searching({this.closest});
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

// ***************************************
// ** Receiver has been offered a file ***
// ***************************************
class Offered extends WebState {
  final dynamic matchId;
  final Profile matchProfile;
  final dynamic offer;

  const Offered({
    this.matchId,
    this.matchProfile,
    this.offer,
  });
}

// *******************************************
// ** Post Authorization Receiver Declined ***
// *******************************************
class Failed extends WebState {
  const Failed();
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
