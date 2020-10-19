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
  final Tuple2<Metadata, File> file;
  Queued(this.file);
}

// Sending to peer w/ Progress and Chunks
class Sending extends DataState {
  Sending();
}

// Receiving Data from Peer
class Receiving extends DataState {
  // State Class
  Receiving();
}

// Post Sending, Receiving
class Done extends DataState {
  final Role role;
  final Tuple2<Metadata, File> file;
  Done(this.role, {this.file});
}

// Viewing Saved File
class Viewing extends DataState {
  final Metadata metadata;
  Viewing(this.metadata);
}
