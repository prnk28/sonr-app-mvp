part of 'sonr_bloc.dart';

abstract class SonrEvent extends Equatable {
  const SonrEvent();

  @override
  List<Object> get props => [];
}

// ^ Initialize a new Sonr Node ^ //
// @ Args(Contact Protobuf, GeoLocator Position) //
class NodeInitialize extends SonrEvent {
  final Contact contact;
  final Position position;
  const NodeInitialize(this.contact, this.position);
}

// ^ Send a Updated Direction ^ //
// @ Args(float64) //
class NodeUpdate extends SonrEvent {
  final double newDirection;
  const NodeUpdate(this.newDirection);
}

// ^ Queue a File ^ //
// @ Args(string) //
class NodeQueueFile extends SonrEvent {
  final File file;
  const NodeQueueFile(this.file);
}

// ^ Send an Invite ^ //
// @ Args(string) //
class NodeInvitePeer extends SonrEvent {
  final Peer peer;
  const NodeInvitePeer(this.peer);
}

// ^ Respond to an Invite ^ //
// @ Args(bool) //
class NodeRespondPeer extends SonrEvent {
  final bool decision;
  const NodeRespondPeer(this.decision);
}

// ^ Transfer to an Accepted Response ^ //
class NodeTransfer extends SonrEvent {
  const NodeTransfer();
}
