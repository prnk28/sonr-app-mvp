part of 'data_bloc.dart';

// ** Enum for Traffic Management ** //
enum TrafficDirection { Incoming, Outgoing }

abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object> get props => [];
}

// Progress Cubit
class ProgressCubit extends Cubit<double> {
  ProgressCubit() : super(0);

  void update(double newValue) {
    // Logging
    log.i((newValue * 100).toString() + "%");

    // Change Value
    emit(newValue);
  }
}

// Send Transfer over DataChannel to Peer
class PeerSendingChunk extends DataEvent {
  const PeerSendingChunk();
}

// Add File Chunk from Transfer
class PeerAddedChunk extends DataEvent {
  final Uint8List chunk;
  const PeerAddedChunk(this.chunk);
}

class PeerQueuedFile extends DataEvent {
  final Metadata metadata;
  final File rawFile;
  final Node sender;
  final TrafficDirection direction;

  PeerQueuedFile(this.direction, {this.sender, this.metadata, this.rawFile});
}

class PeerClearedQueue extends DataEvent {
  final String matchId;
  final TrafficDirection direction;
  PeerClearedQueue(this.direction, {this.matchId});
}

// Search for a file
class UserSearchedFile extends DataEvent {
  const UserSearchedFile();
}

// Opens a file in appropriate viewer
class UserOpenedFile extends DataEvent {
  final Metadata meta;
  const UserOpenedFile(this.meta);
}
