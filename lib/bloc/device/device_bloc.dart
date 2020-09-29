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
  DeviceBloc() : super(null) {
    // ** Accelerometer Events **
    accelerometerEvents.listen((AccelerometerEvent newMotion) {
      // Update Motion Var
      add(Refresh(motion: newMotion));
    });

    // ** Directional Events **
    Compass()
        .compassUpdates(interval: Duration(milliseconds: 400))
        .listen((newDegrees) {
      // Update Degrees Var
      add(Refresh(direction: newDegrees));
    });
  }

  @override
  Stream<DeviceState> mapEventToState(
    DeviceEvent event,
  ) async* {
    if (event is Initialize) {
      yield* _mapInitializeState(event);
    } else if (event is Refresh) {
      yield* _mapRefreshState(event);
    } else if (event is Update) {
      yield* _mapUpdateState(event);
    } else if (event is GetLocation) {
      yield* _mapGetLocationState(event);
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

// ***********************
// ** GetLocation Event **
// ***********************
  Stream<DeviceState> _mapGetLocationState(GetLocation event) async* {

    // Location Available
    yield Ready();
  }

// *******************
// ** Refresh Event **
// *******************
  Stream<DeviceState> _mapRefreshState(Refresh event) async* {
    // Check if User Active
    if (user != null && !user.isBusy) {
      // Check if Direction Provided
      if (event.direction != null && user != null) {
        user.direction = event.direction;
      }

      // Check if Motion Provided
      if (event.motion != null) {
        user.motion = event.motion;
      }

      // Update State
      add(Update());
      yield Refreshing();
    }
    yield Inactive();
  }

// *******************
// ** Update Event **
// *******************
  Stream<DeviceState> _mapUpdateState(Update event) async* {
    // Yield State by Peer Status
    if (user.status == PeerStatus.Ready) {
      yield Ready();
    } else if (user.status == PeerStatus.Sending) {
      yield Sending();
    } else if (user.status == PeerStatus.Receiving) {
      yield Receiving();
    } else if (user.status == PeerStatus.Busy) {
      yield Busy();
    }
    yield Inactive();
  }
}
