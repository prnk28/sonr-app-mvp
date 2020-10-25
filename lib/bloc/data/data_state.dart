part of 'data_bloc.dart';

abstract class DataState extends Equatable {
  const DataState();
  @override
  List<Object> get props => [];
}

// Ready to Perform Action
class PeerInitial extends DataState {
  PeerInitial();
}

// Sending to peer w/ Progress and Chunks
class PeerSendInProgress extends DataState {
  PeerSendInProgress();
}

// Receiving Data from Peer
class PeerReceiveInProgress extends DataState {
  PeerReceiveInProgress();
}

// Default State
class PeerReady extends DataState {}

// Viewing Saved File
class Viewing extends DataState {
  final SonrFile file;
  Viewing(this.file);
}
