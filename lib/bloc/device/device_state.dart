part of 'device_bloc.dart';

abstract class DeviceState extends Equatable {
  final Peer user;
  const DeviceState({this.user});

  @override
  List<Object> get props => [user];
}

// ** Prior to Load or on Standby **
class Inactive extends DeviceState {}

// ** Device can Record Data/ Portrait **
class Ready extends DeviceState {
  final Peer user;
  const Ready({this.user});
}

class Sending extends DeviceState {
  const Sending();
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
