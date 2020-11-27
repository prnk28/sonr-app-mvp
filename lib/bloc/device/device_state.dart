part of 'device_bloc.dart';

abstract class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object> get props => [];
}

// ** Enum defines Type of Permission **
// ^ Prior to Load or on Standby ^
class DeviceLoading extends DeviceState {}

// ^ Profile and Required Permissions found ^
class DeviceActive extends DeviceState {}

// ^ Profile not found ^
class ProfileError extends DeviceState {
  ProfileError();
}

// ^ Required Permission not found ^
class RequiredPermissionError extends DeviceState {
  RequiredPermissionError();
}

// ^ Device was granted a permission ^
class PermissionSuccess extends DeviceState {
  final PermissionType type;
  const PermissionSuccess(this.type);
}

// ^ Device wasnt granted permission ^
class PermissionFailure extends DeviceState {
  final PermissionType type;
  const PermissionFailure(this.type);
}
