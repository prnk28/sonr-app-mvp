part of 'data_bloc.dart';

enum DataBlocStatus {
  Unavailable,
  Standby,
  Saving,
  Updating,
  Selected,
  Finding,
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

// No Local Account
class Unavailable extends DataState {
  Unavailable({status: DataBlocStatus.Unavailable});
}

// On Standby Essentially
class Standby extends DataState {
  Standby({status: DataBlocStatus.Standby});
}

// Saving to disk
class Saving extends DataState {
  Saving({status: DataBlocStatus.Saving});
}

// Saving Preferances/Settings
class Updating extends DataState {
  Updating({status: DataBlocStatus.Updating});
}

// File ready to transfer
class Selected extends DataState {
  Selected({status: DataBlocStatus.Selected});
}

// Searching for a file
class Finding extends DataState {
  Finding({status: DataBlocStatus.Finding});
}

// Post saving, updating, or finding
class Done extends DataState {
  Done({status: DataBlocStatus.Done});
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
