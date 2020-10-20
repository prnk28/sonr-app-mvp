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
  const Load();
}

// Invite Peer
class Invite extends WebEvent {
  final Peer to;

  const Invite(this.to);
}

// Authorize Offer
class Authorize extends WebEvent {
  final Peer to;
  final bool decision;
  final dynamic offer;

  const Authorize(this.to, this.decision, this.offer);
}

// Send Node Data
class Update extends WebEvent {
  // Status Variables
  final Status newStatus;
  final double newDirection;

  // User Variables
  final Peer from;
  final Metadata metadata;

  // RTC Variables
  final dynamic answer;
  final dynamic offer;

  const Update(
    this.newStatus, {
    this.newDirection,
    this.from,
    this.metadata,
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
