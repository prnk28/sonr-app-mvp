import 'dart:async';

import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/core/core.dart';
import 'package:equatable/equatable.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  // Initialize
  Peer user;

  // Constructer
  final WebBloc webBloc;
  DeviceBloc(this.webBloc) : super(Inactive()) {
    // ** Accelerometer Events **
    accelerometerEvents.listen((AccelerometerEvent newData) {
      // Update Motion Var
      add(UpdateMotion(newData));
    });

    // ** Directional Events **
    Compass()
        .compassUpdates(interval: Duration(milliseconds: 400))
        .listen((double newData) {
      // Update Direction Var
      add(UpdateDirection(newData));
    });
  }

  @override
  Stream<DeviceState> mapEventToState(
    DeviceEvent event,
  ) async* {
    if (event is Initialize) {
      yield* _mapInitializeState(event);
    } else if (event is UpdateDirection) {
      yield* _mapUpdateDirectionState(event);
    } else if (event is UpdateMotion) {
      yield* _mapUpdateMotionState(event);
    }
  }

// **********************
// ** Initialize Event **
// **********************
  Stream<DeviceState> _mapInitializeState(Initialize event) async* {
    // Get Profile from Box
    user = new Peer(await localData.getProfile());

    // Profile Ready
    yield Ready();
  }

// ***************************
// ** UpdateDirection Event **
// ***************************
  Stream<DeviceState> _mapUpdateDirectionState(UpdateDirection event) async* {
    // Update Peer Direction
    user.updateDirection(event.data);

    // Profile Ready
    yield Ready();
  }

// ************************
// ** UpdateMotion Event **
// ************************
  Stream<DeviceState> _mapUpdateMotionState(UpdateMotion event) async* {
    // Update Peer Motion
    user.updateMotion(event.data.x, event.data.y, event.data.z);

    // Profile Ready
    yield Ready();
  }
}
