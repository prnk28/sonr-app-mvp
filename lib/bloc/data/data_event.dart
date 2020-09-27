part of 'data_bloc.dart';

abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object> get props => [];
}

// Update Profile/Contact Info
class UpdateProfile extends DataEvent {
  final Profile data;
  const UpdateProfile(this.data);
}

// Update Account Settings
class UpdateAccount extends DataEvent {
  const UpdateAccount();
}

// Check Status of local account
class CheckLocalStatus extends DataEvent {
  const CheckLocalStatus();
}

// Post Transfer from Peer
class SaveFile extends DataEvent {
  const SaveFile();
}

// Pick file to transfer to peer
class SelectFile extends DataEvent {
  const SelectFile();
}

// Search for a file
class FindFile extends DataEvent {
  const FindFile();
}

// Opens a file in appropriate viewer
class OpenFile extends DataEvent {
  const OpenFile();
}
