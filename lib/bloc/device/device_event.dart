part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object> get props => [];
}

// Check Location Permission
class LocationPermissionCheck extends DeviceEvent {
  const LocationPermissionCheck();
}

// Request Location Permission
class LocationPermissionRequested extends DeviceEvent {
  const LocationPermissionRequested();
}

// *********************
// ** Direction Cubit **
// *********************
class DirectionCubit extends Cubit<double> {
  DirectionCubit() : super(0);

  void update(double newValue) {
    emit(newValue);
  }
}
