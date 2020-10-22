part of 'web_bloc.dart';

enum LoadType {
  Updated,
  Exited,
  Declined,
  Error,
}

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
  final LoadType type;
  final Peer from;
  final dynamic error;
  const Load(this.type, {this.from, this.error});
}

// Invite Peer
class PeerInvited extends WebEvent {
  final Peer to;
  final SonrFile file;

  const PeerInvited(this.to, {this.file});
}

// Authorize Offer
class Authorize extends WebEvent {
  final dynamic offer;
  final Metadata metadata;
  final Peer match;
  final bool decision;

  const Authorize(this.decision, this.match, this.offer, this.metadata);
}

// Receive Data
class Handle extends WebEvent {
  // Messages
  final dynamic answerData;
  final dynamic offerData;

  const Handle({
    this.answerData,
    this.offerData,
  });
}

// Send Node Data
class Update extends WebEvent {
  // References
  final Status newStatus;
  final Peer from;
  final Peer to;

  const Update(
    this.newStatus, {
    this.from,
    this.to,
  });
}

// Sequence Finished
class End extends WebEvent {
  final EndType type;
  final Peer match;
  final SonrFile file;
  const End(this.type, {this.match, this.file});
}
