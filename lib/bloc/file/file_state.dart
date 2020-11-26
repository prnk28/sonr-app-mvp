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
  final List<Metadata> metadata;
  const AllFilesSuccess(this.metadata);
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
