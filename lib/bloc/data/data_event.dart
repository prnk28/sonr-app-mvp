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

// User added file to queue
class PeerQueuedFile extends DataEvent {
  final Metadata metadata;
  final File rawFile;
  final Node sender;
  final TrafficDirection direction;

  PeerQueuedFile(this.direction, {this.sender, this.metadata, this.rawFile});
}

// Queue has been completed
class FileQueuedComplete extends DataEvent {
  final Role role;
  const FileQueuedComplete(this.role);
}

// User Cleared Queue
class PeerClearedQueue extends DataEvent {
  final String matchId;
  final TrafficDirection direction;
  PeerClearedQueue(this.direction, {this.matchId});
}

// Search for a file
class UserSearchedFile extends DataEvent {
  final String query;
  const UserSearchedFile(this.query);
}

// Retreives all files
class UserGetAllFiles extends DataEvent {
  const UserGetAllFiles();
}

// Opens a file in appropriate viewer
class UserGetFile extends DataEvent {
  final Metadata meta;
  final int fileId;
  const UserGetFile({this.meta, this.fileId});
}

// Opens a file in appropriate viewer
class UserLoadFile extends DataEvent {
  final SonrFile file;
  const UserLoadFile(this.file);
}

// Opens a file in appropriate viewer
class UserDeleteFile extends DataEvent {
  final Metadata meta;
  const UserDeleteFile(this.meta);
}
