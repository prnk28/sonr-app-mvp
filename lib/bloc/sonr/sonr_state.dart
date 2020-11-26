part of 'sonr_bloc.dart';

// *******************************
// ** BLoC States of Sonr Core ***
// *******************************
abstract class SonrState extends Equatable {
  const SonrState();

  @override
  List<Object> get props => [];
}

// ^ Node is Offline ^ //
class NodeOffline extends SonrState {}

// ^ Node is Available ^ //
class NodeAvailableN extends SonrState {
  final Lobby lobby;
  const NodeAvailableN(this.lobby);
}

// ^ Node is Searching ^ //
class NodeSearching extends SonrState {
  final Lobby lobby;
  const NodeSearching(this.lobby);
}

// ^ Node is Transferring File ^ //
class NodeTransferring extends SonrState {
  final Peer receiver;
  const NodeTransferring(this.receiver);
}

// ^ Node is Receiving File ^ //
class NodeReceiving extends SonrState {
  final Peer sender;
  const NodeReceiving(this.sender);
}

// ^ Cubit Tracks File Transfer Progress ^ //
class TransferProgress extends Cubit<double> {
  // Default Value
  TransferProgress() : super(0);

  // Update Progress
  update(double newProgress) {
    emit(newProgress);
  }
}
