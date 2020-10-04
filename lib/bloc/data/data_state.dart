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
class Transmitting extends DataState {
  // Progress Variables
  final Tuple2<Metadata, File> file;
  final double progress;

  // State Class
  Transmitting({this.file, this.progress});
}

// Saving to disk w/ Progress and Chunks
class Saving extends DataState {
  // Progress Variables
  final Tuple2<Metadata, File> file;
  final double progress;

  // State Class
  Saving({this.file, this.progress});
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
  final Tuple2<Metadata, File> file;
  Done({this.file});
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
