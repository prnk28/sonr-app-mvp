part of 'device_bloc.dart';

abstract class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object> get props => [];
}

// ** Prior to Load or on Standby **
class Inactive extends DeviceState {}

// ** Can Record Data **
class Ready extends DeviceState {
  final Peer user;
  const Ready({this.user});
}

// ** Device is Tilted **
class Sending extends DeviceState {
  final Peer user;
  const Sending({this.user});
}

// ** Device is Landscape **
class Receiving extends DeviceState {
  final Peer user;
  const Receiving({this.user});
}

// ** Interacting with another Peer**
class Busy extends DeviceState {
  final Peer user;
  const Busy({this.user});
}

// ** Device Refreshing Sensors **
class Refreshing extends DeviceState {
  final Peer user;
  const Refreshing({this.user});
}
