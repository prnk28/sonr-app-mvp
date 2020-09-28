part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object> get props => [];
}

// Setup Peer Node
class Initialize extends DeviceEvent {
  const Initialize();
}

// Update Node Direction
class UpdateDirection extends DeviceEvent {
  final double data;
  const UpdateDirection(this.data);
}

// Update Node Direction
class UpdateMotion extends DeviceEvent {
  final AccelerometerEvent data;
  const UpdateMotion(this.data);
}

// Refresh while updating sensors
class Refresh extends DeviceEvent {
  const Refresh();
}
