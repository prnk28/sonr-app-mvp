part of 'web_bloc.dart';

enum EndType {
  Cancel,
  Complete,
  Exit,
  Fail,
}

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
  final General event;
  const Load({this.event});
}

// Invite Peer
class Invite extends WebEvent {
  final Peer to;

  const Invite(this.to);
}

// Authorize Offer
class Authorize extends WebEvent {
  final Offer offer;
  final bool decision;

  const Authorize(this.decision, this.offer);
}

// Send Node Data
class Update extends WebEvent {
  // References
  final Status newStatus;
  final Peer match;

  // Messages
  final Answer answer;
  final Offer offer;

  const Update(
    this.newStatus, {
    this.match,
    this.answer,
    this.offer,
  });
}

// Sequence Finished
class End extends WebEvent {
  final EndType type;
  final Peer match;
  const End(this.type, {this.match});
}
