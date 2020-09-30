part of 'web_bloc.dart';

enum GraphUpdate { ENTER, UPDATE, EXIT }

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
class UpdateNode extends WebEvent {
  const UpdateNode();
}

// Update Graph with Peer Values
class UpdateGraph extends WebEvent {
  final GraphUpdate updateType;
  final Peer peer;

  const UpdateGraph(this.updateType, this.peer);
}

// Sender Offers Invite for Authorization
class SendOffer extends WebEvent {
  final Peer match;
  const SendOffer(this.match);
}

// Receiver is Presented with Authorization
class Authorize extends WebEvent {
  final bool decision;
  const Authorize(this.decision);
}

// Receiver Gets Authorization Request
class HandleOffer extends WebEvent {
  final bool decision;
  final Peer match;
  final dynamic offer;
  const HandleOffer(this.decision, {this.match, this.offer});
}

// Receiver has Accepted
class HandleAnswer extends WebEvent {
  final Peer match;
  final dynamic answer;
  const HandleAnswer(this.match, this.answer);
}

// Receiver has Declined
class HandleDecline extends WebEvent {
  final Peer match;
  const HandleDecline(this.match);
}

// Sender Begins Transfer
class BeginTransfer extends WebEvent {
  const BeginTransfer();
}

// On Transfer Complete
class HandleComplete extends WebEvent {
  final Peer match;
  const HandleComplete(this.match);
}

// Complete: Reset Connection - With Options
class Complete extends WebEvent {
  final Peer match;
  final bool resetSession;
  final bool resetConnection;
  final bool exit;
  const Complete({this.match, this.resetConnection, this.resetSession, this.exit});
}

// Failed: Internal or Cancelled
class Fail extends WebEvent {
  final bool resetSession;
  final bool resetConnection;
  final bool exit;
  const Fail({this.resetConnection, this.resetSession, this.exit});
}
