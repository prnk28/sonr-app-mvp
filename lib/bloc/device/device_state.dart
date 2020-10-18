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
  const Located();
}

// ** Device Received Location **
class Denied extends DeviceState {
  const Denied();
}
