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

// Add File Chunk from Transfer
class UpdateProgress extends DataEvent {
  const UpdateProgress();
}

// Write Completed File to Disk
class WriteFile extends DataEvent {
  const WriteFile();
}

// Pick file to transfer to peer
class SelectFile extends DataEvent {
  const SelectFile();
}

// Search for a file
class FindFile extends DataEvent {
  const FindFile();
}

// Opens a file in appropriate viewer
class OpenFile extends DataEvent {
  const OpenFile();
}
