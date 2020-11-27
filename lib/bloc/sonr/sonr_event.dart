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

// ^ Queue a File ^ //
// @ Args(string) //
class NodeQueueFile extends SonrEvent {
  final File file;
  const NodeQueueFile(this.file);
}

// ^ Change State to Searching ^ //
// @ Args() //
class NodeSearch extends SonrEvent {
  const NodeSearch();
}

// ^ Cancel current action and revert to Available ^ //
// @ Args() //
class NodeCancel extends SonrEvent {
  final SonrState oldState;
  const NodeCancel({this.oldState});
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
  final Peer peer;
  final Metadata metadata;
  const NodeRespondPeer(this.decision, this.peer, this.metadata);
}

// ^ Start the Transfer Process ^ //
// @ Args() //
class NodeStartTransfer extends SonrEvent {
  final Peer peer;
  const NodeStartTransfer(this.peer);
}
