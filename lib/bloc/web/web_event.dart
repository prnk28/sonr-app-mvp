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
class UpdateGraph extends WebEvent {
  final Peer peer;
  const UpdateGraph({this.peer});
}

// Sender Offfers Invite for Authorization
class SendOffer extends WebEvent {
  final String id;
  const SendOffer(this.id);
}

// Populate Connections with Peers
class HandlePeerUpdate extends WebEvent {
  final List<dynamic> peers;
  const HandlePeerUpdate(this.peers);
}

// Receiver Gets Authorization Request
class HandleOffer extends WebEvent {
  final bool decision;
  final String matchId;
  final dynamic offer;
  final dynamic profile;
  const HandleOffer(this.decision, {this.matchId, this.offer, this.profile});
}

// Receiver has Accepted
class HandleAnswer extends WebEvent {
  final dynamic profile;
  final dynamic answer;
  final String matchId;
  const HandleAnswer(this.profile, this.matchId, this.answer);
}

// Add Ice Candidates
class HandleCandidate extends WebEvent {
  final dynamic data;
  const HandleCandidate(this.data);
}

// Peer Connection has Left RTC Session
class HandleLeave extends WebEvent {
  final dynamic data;
  const HandleLeave(this.data);
}

// Peer Connection has Closed RTC Session
class HandleClose extends WebEvent {
  final dynamic data;
  const HandleClose(this.data);
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

// On Transfer Complete
class HandleComplete extends WebEvent {
  final String matchId;
  final dynamic profile;
  const HandleComplete(this.profile, this.matchId);
}

// Complete: Reset Connection - With Options
class Complete extends WebEvent {
  final bool resetSession;
  final bool resetConnection;
  final bool exit;
  const Complete({this.resetConnection, this.resetSession, this.exit});
}
