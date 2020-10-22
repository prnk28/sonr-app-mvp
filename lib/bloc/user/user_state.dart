part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

// ***************************
// ** Profile Initial Load ***
// ***************************
// No Profile Found
class ProfileLoadFailure extends UserState {
  ProfileLoadFailure();
}

// Profile has been found
class ProfileLoadSuccess extends UserState {
  final Peer user;

  ProfileLoadSuccess(this.user);
}

// ********************************
// ** Available to be requested ***
// ********************************
// Ready to Transfer
class NodeAvailableInProgress extends UserState {
  final Peer userNode;

  NodeAvailableInProgress(this.userNode);
}

// **************************************
// ** Searching for Available Devices ***
// **************************************
// Updating Graph
class NodeSearchInProgress extends UserState {
  final Peer userNode;

  NodeSearchInProgress(this.userNode);
}

// Found Neighbors
class NodeSearchSuccess extends UserState {
  final Peer userNode;
  final List<Peer> activePeers;

  NodeSearchSuccess(this.userNode, this.activePeers);
}

// No Neighbors
class NodeSearchFailure extends UserState {
  final Peer userNode;
  NodeSearchFailure(this.userNode);
}

// *********************************
// ** Sending/Receiving an Offer ***
// *********************************
// User has been offered
class NodeRequestInitial extends UserState {
  final Peer from;
  final dynamic offer;
  final Metadata metadata;

  NodeRequestInitial(this.from, this.offer, this.metadata);
}

// User has sent offer to [Peer]
class NodeRequestInProgress extends UserState {
  final Peer match;
  NodeRequestInProgress(this.match);
}

// [Peer] has accepted offer
class NodeRequestSuccess extends UserState {
  final Peer match;
  NodeRequestSuccess(this.match);
}

// [Peer] has rejected offer
class NodeRequestFailure extends UserState {}

// **************************
// ** Transferring a File ***
// **************************
// User waiting for first chunk
class NodeTransferInitial extends UserState {
  final Metadata metadata;
  final Peer match;

  NodeTransferInitial(this.metadata, this.match);
}

// User/[Peer] sending/receving chunks
class NodeTransferInProgress extends UserState {
  final Peer match;

  NodeTransferInProgress(this.match);
}

// User/[Peer] have completed transfer
class NodeTransferSuccess extends UserState {
  final Peer match;
  final SonrFile file;

  NodeTransferSuccess(this.match, {this.file});
}

// User/[Peer] have failed to transfer
class NodeTransferFailure extends UserState {
  final Peer match;

  NodeTransferFailure(this.match);
}
