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
  const Connect();
}

// Between Server Reads
class Load extends WebEvent {
  const Load();
}

// Find Active Nodes
class Search extends WebEvent {
  const Search();
}

// Send Active Node Data
class Active extends WebEvent {
  const Active();
}

// Handle Offer/Answer/Decline
class Handle extends WebEvent {
  final dynamic message;
  const Handle(this.message);
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
  final dynamic message;
  const Authorize(this.decision, this.message);
}

// Create Offer/Answer/Decline
class Create extends WebEvent {
  final OutgoingMessage type;
  final RTCPeerConnection pc;
  final Peer match;
  final Metadata metadata;

  const Create(this.type, {this.match, this.metadata, this.pc});
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
