part of 'device_bloc.dart';

abstract class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object> get props => [];
}

// ** Prior to Load or on Standby **
class Inactive extends DeviceState {}

// ** Can Record Data **
class Ready extends DeviceState {}

// ** Looking for Peers in General **
class Searching extends DeviceState {}

// ** Device is Tilted **
class SendingPosition extends DeviceState {}

// ** Device is Landscape **
class ReceivingPosition extends DeviceState {}

// ** Device Refreshing Sensors **
class Refreshing extends DeviceState {}
