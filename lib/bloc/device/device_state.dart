part of 'device_bloc.dart';

abstract class DeviceState extends Equatable {
  final Peer user;
  const DeviceState({this.user});

  @override
  List<Object> get props => [user];
}

// ** Prior to Load or on Standby **
class Inactive extends DeviceState {}

// ** Device Received Location **
class Located extends DeviceState {
  final Location location;
  const Located(this.location);
}

// ** Device Received Location **
class Denied extends DeviceState {
  const Denied();
}
