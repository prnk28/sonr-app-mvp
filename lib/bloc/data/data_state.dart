part of 'data_bloc.dart';

abstract class DataState extends Equatable {
  const DataState();
  @override
  List<Object> get props => [];
}

// ******************* //
// ** Data Transfer ** //
// ******************* //
// Ready to Perform Action
class PeerInitial extends DataState {
  PeerInitial();
}

// Peer began queueing file
class PeerQueueInProgress extends DataState {
  PeerQueueInProgress();
}

// Queuing has been successful
class PeerQueueSuccess extends DataState {
  PeerQueueSuccess();
}

// ***************** //
// ** File Access ** //
// ***************** //
// Currently Viewing Saved File
class UserViewingFileInProgress extends DataState {
  final Metadata metadata;
  UserViewingFileInProgress(this.metadata);
}

// Finished Viewing Saved File
class UserViewingFileSuccess extends DataState {
  final Uint8List bytes;
  final Metadata metadata;
  UserViewingFileSuccess(this.bytes, this.metadata);
}

class UserViewingFileFailure extends DataState {
  final Metadata metadata;
  UserViewingFileFailure(this.metadata);
}

// User Loaded Files
class UserLoadedFilesSuccess extends DataState {
  final List<Metadata> files;
  UserLoadedFilesSuccess(this.files);
}

// Couldnt Load Files
class UserLoadedFilesFailure extends DataState {
  UserLoadedFilesFailure();
}

// Deleted File Succesfully
class UserDeletedFileSuccess extends DataState {
  UserDeletedFileSuccess();
}

// ***************** //
// ** File Search ** //
// ***************** //
// Added query string for file search
class UserSearchingFileInitial extends DataState {
  UserSearchingFileInitial();
}

// Finding potential file matches
class UserSearchingFileInProgress extends DataState {
  UserSearchingFileInProgress();
}

// Return potential matches
class UserSearchingFilesSuccess extends DataState {
  final List<Metadata> files;
  UserSearchingFilesSuccess(this.files);
}

// Found no applicable matches
class UserSearchingFilesFailure extends DataState {
  UserSearchingFilesFailure();
}
