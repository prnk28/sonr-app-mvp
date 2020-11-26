part of 'file_bloc.dart';

abstract class FileState extends Equatable {
  const FileState();
  
  @override
  List<Object> get props => [];
}

class FileInitial extends FileState {}
