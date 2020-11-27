part of 'sonr_bloc.dart';

abstract class SonrState extends Equatable {
  const SonrState();

  @override
  List<Object> get props => [];
}

// ********************
// ** Default States **
// ********************
// ^ Node is Offline ^ //
class NodeOffline extends SonrState {}

// ^ Node is Available ^ //
class NodeAvailable extends SonrState {}

// ^ Node is Queueing File ^ //
class NodeQueueing extends SonrState {}

// ^ Node is Searching for Peers ^ //
class NodeSearching extends SonrState {}

// ^ Node is Searching for Peers ^ //
class NodeError extends SonrState {
  final ErrorMessage error;
  final SonrState errorState;
  const NodeError(this.error, this.errorState);
}

// **********************************
// ** Authentication based States ***
// **********************************
// ^ Node has been Invited ^ //
class NodeInvited extends SonrState {
  final Peer from;
  final Metadata metadata;
  const NodeInvited(this.from, this.metadata);
}

// ^ User has sent offer to [Peer] ^
class PeerInvited extends SonrState {
  final Peer peer;
  PeerInvited(this.peer);
}

// ^ [Peer] has accepted offer ^
class PeerInviteAccepted extends SonrState {
  final Peer match;
  PeerInviteAccepted(this.match);
}

// ^ [Peer] has rejected offer ^
class PeerInviteDeclined extends SonrState {
  final Peer peer;
  PeerInviteDeclined(this.peer);
}

// ****************************
// ** Exchange based States ***
// ****************************
// ^ Node is Transferring File ^ //
class NodeTransferInProgress extends SonrState {
  final Peer receiver;
  const NodeTransferInProgress(this.receiver);
}

// ^ User has completed transfer ^
class NodeTransferSuccess extends SonrState {
  final Peer receiver;
  NodeTransferSuccess(this.receiver);
}

// ^ User has failed to transfer ^
class NodeTransferFailure extends SonrState {
  final Peer receiver;
  NodeTransferFailure(this.receiver);
}

// ^ Node is Receiving File ^ //
class NodeReceiveInProgress extends SonrState {
  final Peer sender;
  final Metadata metadata;
  const NodeReceiveInProgress(this.sender, this.metadata);
}

// ^ Node succesfully received file ^ //
class NodeReceiveSuccess extends SonrState {
  final File file;
  final Peer sender;
  final Metadata metadata;
  NodeReceiveSuccess(this.file, this.sender, this.metadata);
}

// ^ Node failed to receive file ^ //
class NodeReceiveFailure extends SonrState {
  final Peer sender;
  NodeReceiveFailure(this.sender);
}

// *********************************************
// ** Cubit States for Non-Responsive Events ***
// *********************************************
// ^ Cubit to Track Available Peers ^ //
class LobbyCubit extends Cubit<Lobby> {
  // Default Value
  LobbyCubit() : super(null);

  // Update Progress
  update(Lobby updatedPeers) {
    emit(updatedPeers);
  }
}

// ^ Cubit to Tracks File Transfer Progress ^ //
class ProgressCubit extends Cubit<double> {
  // Default Value
  ProgressCubit() : super(0);

  // Update Progress
  update(double newProgress) {
    emit(newProgress);
  }
}
