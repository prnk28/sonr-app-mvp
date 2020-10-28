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
  final Node user;

  ProfileLoadSuccess(this.user);
}

// ********************************
// ** Available to be requested ***
// ********************************
// Ready to Transfer
class NodeAvailableInProgress extends UserState {
  final Node userNode;

  NodeAvailableInProgress(this.userNode);
}

// **************************************
// ** Searching for Available Devices ***
// **************************************
// Updating Graph
class NodeSearchInProgress extends UserState {
  final Node userNode;

  NodeSearchInProgress(this.userNode);
}

// *********************************
// ** Sending/Receiving an Offer ***
// *********************************
// User has been offered
class NodeRequestInitial extends UserState {
  final Node from;
  final dynamic offer;
  final Metadata metadata;

  NodeRequestInitial(this.from, this.offer, this.metadata);
}

// User has sent offer to [Peer]
class NodeRequestInProgress extends UserState {
  final Node match;
  NodeRequestInProgress(this.match);
}

// [Peer] has accepted offer
class NodeRequestSuccess extends UserState {
  final Node match;
  NodeRequestSuccess(this.match);
}

// [Peer] has rejected offer
class NodeRequestFailure extends UserState {
  final Node rejecter;
  NodeRequestFailure(this.rejecter);
}

// **************************
// ** Transferring a File ***
// **************************
// User waiting for first chunk
class NodeTransferInitial extends UserState {
  final Node match;

  NodeTransferInitial(this.match);
}

// User sending chunks
class NodeTransferInProgress extends UserState {
  final Node match;
  NodeTransferInProgress(this.match);
}

// User has completed transfer
class NodeTransferSuccess extends UserState {
  final Node match;
  NodeTransferSuccess(this.match);
}

// User has failed to transfer
class NodeTransferFailure extends UserState {
  final Node match;

  NodeTransferFailure(this.match);
}

// Begin Receiving State
class NodeReceiveInitial extends UserState {
  final Metadata metadata;
  final Node match;

  NodeReceiveInitial(this.metadata, this.match);
}

// User sending chunks
class NodeReceiveInProgress extends UserState {
  final Metadata metadata;

  NodeReceiveInProgress(this.metadata);
}

// User has completed transfer
class NodeReceiveSuccess extends UserState {
  final File file;
  final Metadata metadata;
  NodeReceiveSuccess(this.file, this.metadata);
}

// User has failed to transfer
class NodeReceiveFailure extends UserState {
  final Node match;
  NodeReceiveFailure(this.match);
}
