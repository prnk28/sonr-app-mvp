part of 'file_bloc.dart';

abstract class FileState extends Equatable {
  const FileState();
  
  @override
  List<Object> get props => [];
}

class AllFilesLoading extends FileState {}
class AllFilesSuccess extends FileState {}
class AllFilesNone extends FileState {}
class AllFilesError extends FileState {}
