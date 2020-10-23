part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

// ** === Profile Management === ** //
// Get User Ready on Device
class UserStarted extends UserEvent {
  const UserStarted();
}

// Update Profile/Contact Info
class ProfileUpdated extends UserEvent {
  final Profile newProfile;
  const ProfileUpdated(this.newProfile);
}

// ** === Graph Management === ** //
// [Peer] has updated Information
class GraphUpdated extends UserEvent {
  final Node from;
  GraphUpdated(this.from);
}

// [Peer] exited Pool of Neighbors
class GraphExited extends UserEvent {
  final Node from;
  GraphExited(this.from);
}

// Retrieve All Peers by Zone
class GraphZonedPeers extends UserEvent {}

// ** === Node Management === ** //
// [User] Status has Changed
class NodeSearch extends UserEvent {
  NodeSearch();
}

// [User] is Available
class NodeAvailable extends UserEvent {
  NodeAvailable();
}

// [User] is Busy
class NodeBusy extends UserEvent {
  NodeBusy();
}

class NodeCancel extends UserEvent {
  final Node match;
  NodeCancel(this.match);
}

// [User] is Reset
class NodeReset extends UserEvent {
  final Node match;
  NodeReset({this.match});
}

// [User] Send Offer to another peer
class NodeOffered extends UserEvent {
  final Node to;
  final SonrFile file;

  const NodeOffered(this.to, {this.file});
}

// [Peer] A Request Has Been Given
class NodeRequested extends UserEvent {
  final Node from;
  final dynamic offer;
  final Metadata metadata;

  const NodeRequested(this.from, this.offer, this.metadata);
}

// [User] Accepted Offer
class NodeAccepted extends UserEvent {
  final Node match;
  final dynamic offer;
  final Metadata metadata;

  const NodeAccepted(this.match, this.offer, this.metadata);
}

// [Peer] Authorized Offer Request
class NodeAuthorized extends UserEvent {
  final Node match;
  final dynamic answer;

  const NodeAuthorized(this.match, this.answer);
}

// [Peer] has sent a candidate
class NodeCandidate extends UserEvent {
  final Node match;
  final dynamic candidate;

  const NodeCandidate(this.match, this.candidate);
}

// User/Peer have completed transfer
class NodeCompleted extends UserEvent {
  final Node match;
  final SonrFile file;

  const NodeCompleted(this.match, this.file);
}

// [User] Rejected Offer
class NodeDeclined extends UserEvent {
  final Node to;
  const NodeDeclined(this.to);
}

// [Peer] Rejected the Offer
class NodeRejected extends UserEvent {
  const NodeRejected();
}
