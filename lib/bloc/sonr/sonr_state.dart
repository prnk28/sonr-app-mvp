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
class NodeAvailableN extends SonrState {}

// ^ Node is Queueing File ^ //
class NodeQueueing extends SonrState {}

// ^ Node is Searching for Peers ^ //
class NodeSearchingN extends SonrState {}

// ^ Node is Searching for Peers ^ //
class NodeError extends SonrState {}

// **********************************
// ** Authentication based States ***
// **********************************
// ^ Node has been Invited ^ //
class NodeInvited extends SonrState {
  final Peer peer;
  const NodeInvited(this.peer);
}

// ^ User has sent offer to [Peer] ^
class NodeRequestInProgressN extends SonrState {
  final Peer peer;
  NodeRequestInProgressN(this.peer);
}

// ^ [Peer] has accepted offer ^
class NodeRequestSuccessN extends SonrState {
  final Peer match;
  NodeRequestSuccessN(this.match);
}

// ^ [Peer] has rejected offer ^
class NodeRequestFailureN extends SonrState {
  final Peer peer;
  NodeRequestFailureN(this.peer);
}

// ****************************
// ** Exchange based States ***
// ****************************
// ^ Node is Transferring File ^ //
class NodeTransferInProgressN extends SonrState {
  final Peer receiver;
  const NodeTransferInProgressN(this.receiver);
}

// ^ User has completed transfer ^
class NodeTransferSuccessN extends SonrState {
  final Peer receiver;
  NodeTransferSuccessN(this.receiver);
}

// ^ User has failed to transfer ^
class NodeTransferFailureN extends SonrState {
  final Peer receiver;
  NodeTransferFailureN(this.receiver);
}

// ^ Node is Receiving File ^ //
class NodeReceiveInProgressN extends SonrState {
  final Peer sender;
  const NodeReceiveInProgressN(this.sender);
}

// User has completed transfer
class NodeReceiveSuccessN extends SonrState {
  final File file;
  final Peer sender;
  final Metadata metadata;
  NodeReceiveSuccessN(this.file, this.sender, this.metadata);
}

// User has failed to transfer
class NodeReceiveFailureN extends SonrState {
  final Peer sender;
  NodeReceiveFailureN(this.sender);
}

// *********************************************
// ** Cubit States for Non-Responsive Events ***
// *********************************************
// ^ Cubit to Tracks File Transfer Progress ^ //
class ExchangeProgress extends Cubit<double> {
  // Default Value
  ExchangeProgress() : super(0);

  // Update Progress
  update(double newProgress) {
    emit(newProgress);
  }
}

// ^ Cubit to Track Available Peers ^ //
class AvailablePeers extends Cubit<List<Peer>> {
  // Default Value
  AvailablePeers() : super(null);

  // Update Progress
  update(List<Peer> updatedPeers) {
    emit(updatedPeers);
  }
}

// ^ Cubit to Track File Queue ^ //
class FileQueue extends Cubit<Metadata> {
  // Default Value
  FileQueue() : super(null);

  // Update Progress
  update(Metadata queuedFile) {
    emit(queuedFile);
  }
}
