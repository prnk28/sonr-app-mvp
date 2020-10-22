part of 'device_bloc.dart';

abstract class DeviceState extends Equatable {
  final Peer user;
  const DeviceState({this.user});

  @override
  List<Object> get props => [user];
}

// ** Prior to Load or on Standby **
class LocationPermissionInitial extends DeviceState {}

// ** Device Received Location **
class LocationPermissionSuccess extends DeviceState {
  const LocationPermissionSuccess();
}

// ** Device Received Location **
class LocationPermissionFailure extends DeviceState {
  const LocationPermissionFailure();
}
