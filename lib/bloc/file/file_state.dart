part of 'file_bloc.dart';

abstract class FileState extends Equatable {
  const FileState();

  @override
  List<Object> get props => [];
}

// *******************************
// ** Viewing All Files States ***
// *******************************
class AllFilesLoading extends FileState {}

class AllFilesSuccess extends FileState {
  final List<Metadata> metadataList;
  const AllFilesSuccess(this.metadataList);
}

class AllFilesNone extends FileState {}

class AllFilesError extends FileState {}

// ******************************
// ** Viewing One File States ***
// ******************************
class OneFileLoading extends FileState {}

class OneFileSuccess extends FileState {
  final File file;
  final Metadata metadata;
  const OneFileSuccess(this.file, this.metadata);
}

class OneFileError extends FileState {}

// ****************************
// ** Exchange based States ***
// ****************************
// ^ Node is Transferring File ^ //
class FileTransferInProgress extends FileState {
  final Peer receiver;
  const FileTransferInProgress(this.receiver);
}

// ^ User has completed transfer ^
class FileTransferSuccess extends FileState {
  final Peer receiver;
  FileTransferSuccess(this.receiver);
}

// ^ User has failed to transfer ^
class FileTransferFailure extends FileState {
  final Peer receiver;
  FileTransferFailure(this.receiver);
}

// ^ Node is Receiving File ^ //
class FileReceiveInProgress extends FileState {
  final Peer sender;
  final Metadata metadata;
  const FileReceiveInProgress(this.sender, this.metadata);
}

// ^ Node succesfully received file ^ //
class FileReceiveSuccess extends FileState {
  final File file;
  final Peer sender;
  final Metadata metadata;
  FileReceiveSuccess(this.file, this.sender, this.metadata);
}

// ^ Node failed to receive file ^ //
class FileReceiveFailure extends FileState {
  final Peer sender;
  FileReceiveFailure(this.sender);
}
