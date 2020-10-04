part of 'web_bloc.dart';

enum GraphUpdate { ENTER, UPDATE, EXIT }
enum MessageKind { OFFER, ANSWER, DECLINED, COMPLETE, LEAVE, CLOSE }

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
class SendNode extends WebEvent {
  const SendNode();
}

// Update Graph with Peer Values
class UpdateGraph extends WebEvent {
  final GraphUpdate updateType;
  final Peer peer;

  const UpdateGraph(this.updateType, this.peer);
}

// Sender Offers Invite for Authorization
class Invite extends WebEvent {
  final Peer match;
  final Metadata metadata;
  const Invite(this.match, this.metadata);
}

// Receiver is Presented with Authorization
class Authorize extends WebEvent {
  final bool decision;
  final Peer match;
  final dynamic message;
  const Authorize(this.decision, this.match, this.message);
}

// Create Offer/Answer/Decline
class Create extends WebEvent {
  final MessageKind type;
  final RTCPeerConnection pc;
  final Peer match;
  final Metadata metadata;

  const Create(this.type, {this.match, this.metadata, this.pc});
}

// Handle Offer/Answer/Decline
class Handle extends WebEvent {
  final MessageKind type;
  final Peer match;
  final dynamic message;
  const Handle(this.type, {this.match, this.message});
}

// Complete: Reset Connection - With Options
class Complete extends WebEvent {
  final Peer match;
  final bool resetSession;
  final bool resetConnection;
  final bool exit;
  const Complete(
      {this.match, this.resetConnection, this.resetSession, this.exit});
}

// Failed: Internal or Cancelled
class Fail extends WebEvent {
  final bool resetSession;
  final bool resetConnection;
  final bool exit;
  const Fail({this.resetConnection, this.resetSession, this.exit});
}
