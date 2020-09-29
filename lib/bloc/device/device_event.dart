part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object> get props => [];
}

// Refresh while updating sensors
class Refresh extends DeviceEvent {
  final double direction;
  final AccelerometerEvent motion;
  const Refresh({this.direction, this.motion});
}

// Get Current Peer Location
class GetLocation extends DeviceEvent {
  const GetLocation();
}

// Updates to State based on Refreshed Data
class Update extends DeviceEvent {
  const Update();
}
