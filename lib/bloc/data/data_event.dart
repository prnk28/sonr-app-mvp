part of 'data_bloc.dart';

// ** Enum for Traffic Management ** //
enum TrafficDirection { Incoming, Outgoing }

abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object> get props => [];
}

// Complete File Received
class UserReceivedFile extends DataEvent {
  final Metadata metadata;
  const UserReceivedFile(this.metadata);
}

// User added file to queue
class UserQueuedFile extends DataEvent {
  final Metadata metadata;
  final File rawFile;
  final Node sender;
  final TrafficDirection direction;

  UserQueuedFile(this.direction, {this.sender, this.metadata, this.rawFile});
}

// Queue has been completed
class FileQueuedComplete extends DataEvent {
  final Role role;
  final Metadata metadata;
  const FileQueuedComplete(this.role, this.metadata);
}

// User Cleared Queue
class FileQueueCleared extends DataEvent {
  final String matchId;
  final TrafficDirection direction;
  FileQueueCleared(this.direction, {this.matchId});
}

// Search for a file
class UserSearchedFile extends DataEvent {
  final String query;
  const UserSearchedFile(this.query);
}

// Retreives all files
class UserGetAllFiles extends DataEvent {
  const UserGetAllFiles();
}

// Opens a file in appropriate viewer
class UserGetFile extends DataEvent {
  final Metadata meta;
  final int fileId;
  const UserGetFile({this.meta, this.fileId});
}

// Opens a file in appropriate viewer
class UserLoadFile extends DataEvent {
  final Metadata metadata;
  final File file;
  const UserLoadFile(this.file, this.metadata);
}

// Opens a file in appropriate viewer
class UserDeleteFile extends DataEvent {
  final Metadata meta;
  const UserDeleteFile(this.meta);
}
