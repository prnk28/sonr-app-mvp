part of 'data_bloc.dart';

enum DataBlocStatus {
  Standby,
  Transmitting,
  Updating,
  Saving,
  Selected,
  Searching,
  Done,
  ViewingImage,
  ViewingVideo,
  ViewingAudio,
  ViewingContact
}

abstract class DataState extends Equatable {
  const DataState({this.status});
  final DataBlocStatus status;
  @override
  List<Object> get props => [];
}

// Ready to Perform Action
class Standby extends DataState {
  Standby({status: DataBlocStatus.Standby});
}

// File ready to transfer
class Selected extends DataState {
  Selected({status: DataBlocStatus.Selected});
}

// Sending to peer w/ Progress and Chunks
class Transmitting extends DataState {
  // Progress Variables
  final FileTransfer file;
  final double progress;

  // State Class
  Transmitting({this.file, this.progress, status: DataBlocStatus.Transmitting});
}

// Saving to disk w/ Progress and Chunks
class Saving extends DataState {
  // Progress Variables
  final FileTransfer file;
  final double progress;

  // State Class
  Saving({this.file, this.progress, status: DataBlocStatus.Saving});
}

// Saving Between Chunks
class Updating extends DataState {
  Updating({status: DataBlocStatus.Updating});
}

// Searching for a file
class FindingFile extends DataState {
  FindingFile({status: DataBlocStatus.Searching});
}

// Post saving, updating, or finding
class Done extends DataState {
  final File rawFile;
  final Metadata metadata;
  Done({this.rawFile, this.metadata, status: DataBlocStatus.Done});
}

// *************************** //
// ** Viewing File by Type **
// *************************** //
class ViewingImage extends DataState {
  ViewingImage({status: DataBlocStatus.ViewingImage});
}

class ViewingVideo extends DataState {
  ViewingVideo({status: DataBlocStatus.ViewingVideo});
}

class ViewingAudio extends DataState {
  ViewingAudio({status: DataBlocStatus.ViewingAudio});
}

class ViewingContact extends DataState {
  ViewingContact({status: DataBlocStatus.ViewingContact});
}
