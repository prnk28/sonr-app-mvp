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

// Sending to peer w/ Progress and Chunks
class PeerSendInProgress extends DataState {
  PeerSendInProgress();
}

// Receiving Data from Peer
class PeerReceiveInProgress extends DataState {
  PeerReceiveInProgress();
}

// ***************** //
// ** File Access ** //
// ***************** //
// Currently Viewing Saved File
class UserViewingFileInProgress extends DataState {
  final SonrFile file;
  UserViewingFileInProgress(this.file);
}

// Finished Viewing Saved File
class UserViewingFileComplete extends DataState {
  UserViewingFileComplete();
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
