part of 'signal_bloc.dart';

enum EndType {
  Cancel,
  Complete,
  Exit,
  Fail,
}

abstract class SignalEvent extends Equatable {
  const SignalEvent();

  @override
  List<Object> get props => [];
}

// *********************
// ** Single Events ****
// *********************
// Connect to Socket
class SocketStarted extends SignalEvent {
  const SocketStarted();
}

// Socket received event
class SocketEmission extends SignalEvent {
  final Incoming event;
  final dynamic data;
  const SocketEmission(this.event, this.data);
}

// Socket sending message
class SocketEmit extends SignalEvent {
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
class PeerInvited extends SignalEvent {
  final Peer to;
  final SonrFile file;

  const PeerInvited(this.to, {this.file});
}

// Peer Authorized Offer
class PeerAuthorized extends SignalEvent {
  final dynamic offer;
  final Metadata metadata;
  final Peer match;

  const PeerAuthorized(this.match, this.offer, this.metadata);
}

// Peer Rejected Offer
class PeerDeclined extends SignalEvent {
  final Peer match;

  const PeerDeclined(this.match);
}

// Send Node Data
class PeerUpdated extends SignalEvent {
  // References
  final Status newStatus;
  final Peer from;

  const PeerUpdated(
    this.newStatus, {
    this.from,
  });
}

// Sequence Finished
class End extends SignalEvent {
  final EndType type;
  final Peer match;
  final SonrFile file;
  const End(this.type, {this.match, this.file});
}
