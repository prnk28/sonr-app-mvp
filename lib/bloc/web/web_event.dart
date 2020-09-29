part of 'web_bloc.dart';

abstract class WebEvent extends Equatable {
  const WebEvent();

  @override
  List<Object> get props => [];
}

// *********************
// ** Single Events ****
// *********************
// Connect to WS, Join/Create Lobby
class Connect extends WebEvent {
  final Profile userProfile;
  const Connect({this.userProfile});
}

// Send Realtime Peer Data to Server
class RequestSearch extends WebEvent {
  final Peer userNode;
  const RequestSearch({this.userNode});
}

// Update Graph with Peer Values
class HandlePeers extends WebEvent {
  final Peer peer;
  const HandlePeers({this.peer});
}

// Sender Invites Authorization
class SendInvite extends WebEvent {
  final String id;
  const SendInvite(this.id);
}

// Receiver Gets Authorization Request
class HandleOffer extends WebEvent {
  final dynamic offer;
  final dynamic profile;
  const HandleOffer({this.offer, this.profile});
}

// Receiver Gets Authorization Request
class SendAuthorization extends WebEvent {
  final bool decision;
  final String matchId;
  final dynamic offer;
  const SendAuthorization(this.decision, this.matchId, this.offer);
}

// Receiver has Accepted
class HandleAnswer extends WebEvent {
  final dynamic profile;
  final dynamic answer;
  final String matchId;
  const HandleAnswer(this.profile, this.matchId, this.answer);
}

// Receiver has Declined
class HandleDecline extends WebEvent {
  final String matchId;
  final dynamic profile;
  const HandleDecline(this.profile, this.matchId);
}

// Sender Begins Transfer
class BeginTransfer extends WebEvent {
  const BeginTransfer();
}

// Sender Sent Transfer
class HandleReceived extends WebEvent {
  final File data;
  const HandleReceived(this.data);
}

// On Transfer Complete
class HandleComplete extends WebEvent {
  final String matchId;
  final dynamic profile;
  const HandleComplete(this.profile, this.matchId);
}

// Reset UI
class Reset extends WebEvent {
  const Reset();
}
