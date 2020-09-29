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

// File ready to transfer
class Selected extends DataState {
  Selected();
}

// Sending to peer w/ Progress and Chunks
class Transmitting extends DataState {
  // Progress Variables
  final FileTransfer file;
  final int chunksTotal;
  final int currentChunkNum;
  final int remainingChunks;
  final double lastProgress;
  final double progress;

  // State Class
  Transmitting(
      {this.chunksTotal,
      this.currentChunkNum,
      this.remainingChunks,
      this.lastProgress,
      this.file,
      this.progress});
}

// Saving to disk w/ Progress and Chunks
class Saving extends DataState {
  // Progress Variables
  final FileTransfer file;
  final int chunksTotal;
  final int currentChunkNum;
  final int remainingChunks;
  final double lastProgress;
  final double progress;

  // State Class
  Saving(
      {this.chunksTotal,
      this.currentChunkNum,
      this.remainingChunks,
      this.lastProgress,
      this.file,
      this.progress});
}

// Saving Between Chunks
class Updating extends DataState {
  Updating();
}

// Searching for a file
class FindingFile extends DataState {
  FindingFile();
}

// Post saving, updating, or finding
class Done extends DataState {
  final File rawFile;
  final Metadata metadata;
  Done({this.rawFile, this.metadata});
}

// *************************** //
// ** Viewing File by Type **
// *************************** //
class ViewingImage extends DataState {
  ViewingImage();
}

class ViewingVideo extends DataState {
  ViewingVideo();
}

class ViewingAudio extends DataState {
  ViewingAudio();
}

class ViewingContact extends DataState {
  ViewingContact();
}
