part of 'data_bloc.dart';

abstract class DataState extends Equatable {
  const DataState();
  @override
  List<Object> get props => [];
}

// Ready to Perform Action
class Standby extends DataState {
  Standby();
}

// File ready to transfer or receive
class Queued extends DataState {
  final SonrFile file;
  Queued(this.file);
}

// Sending to peer w/ Progress and Chunks
class Sending extends DataState {
  Sending();
}

// Receiving Data from Peer
class Receiving extends DataState {
  Receiving();
}

// Post Sending, Receiving
class Done extends DataState {
  final SonrFile file;
  Done({this.file});
}

// Viewing Saved File
class Viewing extends DataState {
  final SonrFile file;
  Viewing(this.file);
}
