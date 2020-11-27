part of 'file_bloc.dart';

abstract class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object> get props => [];
}

// ^ Retreive ALL files from SQLite ^ //
// @ Args() //
class GetAllFiles extends FileEvent {
  const GetAllFiles();
}

// ^ Retreive ONE file from SQLite ^ //
// @ Args() //
class GetFile extends FileEvent {
  final Metadata metadata;
  const GetFile(this.metadata);
}
