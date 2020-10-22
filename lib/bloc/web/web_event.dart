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
// Connect to Socket
class SocketStarted extends WebEvent {
  const SocketStarted();
}

// Socket received event
class SocketEmission extends WebEvent {
  final Incoming event;
  final dynamic data;
  const SocketEmission(this.event, this.data);
}

// Socket sending message
class SocketEmit extends WebEvent {
  // Required Fields
  final Outgoing event;
  final Peer from;

  // Optional
  final Status status; // In Status Change
  final String to; // When Transfer Handshake
  final Metadata metadata; // Attached to Offer
  final RTCIceCandidate candidate; // On Peer Connection
  final RTCSessionDescription session; // On Offer/Answer
  final String sessionId;

  const SocketEmit(this.event, this.from,
      {this.status,
      this.to,
      this.metadata,
      this.session,
      this.candidate,
      this.sessionId});
}

// Peer Sent Invite
class PeerInvited extends WebEvent {
  final Peer to;
  final SonrFile file;

  const PeerInvited(this.to, {this.file});
}

// Peer Authorized Offer
class PeerAuthorized extends WebEvent {
  final dynamic offer;
  final Metadata metadata;
  final Peer match;

  const PeerAuthorized(this.match, this.offer, this.metadata);
}

// Peer Authorized Offer
class PeerDeclined extends WebEvent {
  final Peer match;

  const PeerDeclined(this.match);
}

// Send Node Data
class PeerUpdated extends WebEvent {
  // References
  final Status newStatus;
  final Peer from;
  final Peer to;

  const PeerUpdated(
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
