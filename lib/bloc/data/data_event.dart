part of 'data_bloc.dart';

abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object> get props => [];
}

// Add File Chunk from Transfer
class AddChunk extends DataEvent {
  final Uint8List chunk;
  const AddChunk(this.chunk);
}

// Update Progress
class Progress extends DataEvent {
  const Progress();
}

// Add File Chunk from Transfer
class SendChunks extends DataEvent {
  const SendChunks();
}

// Write Completed File to Disk
class WriteFile extends DataEvent {
  final File file;
  const WriteFile({this.file});
}

// Pick file to transfer to peer
class QueueFile extends DataEvent {
  final bool receiving;
  final dynamic info;
  final File file;
  const QueueFile({this.receiving, this.info, this.file});
}

// Search for a file
class FindFile extends DataEvent {
  const FindFile();
}

// Opens a file in appropriate viewer
class OpenFile extends DataEvent {
  const OpenFile();
}
