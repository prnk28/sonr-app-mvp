part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object> get props => [];
}

// Get Current Peer Location
class Initialize extends DeviceEvent {
  const Initialize();
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
