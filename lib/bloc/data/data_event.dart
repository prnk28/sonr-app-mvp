part of 'data_bloc.dart';

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
class PeerSentChunk extends DataEvent {
  final Node match;
  const PeerSentChunk(this.match);
}

// Add File Chunk from Transfer
class PeerAddedChunk extends DataEvent {
  final Uint8List chunk;
  const PeerAddedChunk(this.chunk);
}

// Write Completed File to Disk
class PeerReceiveCompleted extends DataEvent {
  final File file;
  const PeerReceiveCompleted({this.file});
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
