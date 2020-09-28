part of 'device_bloc.dart';

abstract class DeviceState extends Equatable {
  const DeviceState();
  
  @override
  List<Object> get props => [];
}

class DeviceInitial extends DeviceState {}
