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

// Refresh while updating sensors
class Refresh extends DeviceEvent {
  final double direction;
  final AccelerometerEvent motion;
  const Refresh({this.direction, this.motion});
}

// Updates to State based on Refreshed Data
class Update extends DeviceEvent {
  const Update();
}
