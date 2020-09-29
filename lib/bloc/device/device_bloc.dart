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
  final UserBloc user;

  // Constructer
  DeviceBloc(this.user) : super(null) {
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
    if (event is Refresh) {
      yield* _mapRefreshState(event);
    } else if (event is Update) {
      yield* _mapUpdateState(event);
    } else if (event is GetLocation) {
      yield* _mapGetLocationState(event);
    }
  }

// *******************
// ** Refresh Event **
// *******************
  Stream<DeviceState> _mapRefreshState(Refresh event) async* {
    // Check if User Active
    if (user.node != null && user.node.status != PeerStatus.Busy) {
      // Check if Direction Provided
      if (event.direction != null && user.node != null) {
        user.node.direction = event.direction;
      }

      // Check if Motion Provided
      if (event.motion != null) {
        user.node.motion = event.motion;
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
    // Yield State by Orientation Status
    switch (user.node.orientation) {
      case OrientationType.Portrait:
        yield Ready();
        break;
      case OrientationType.Tilted:
        yield Sending();
        break;
      case OrientationType.LandscapeLeft:
        yield Receiving();
        break;
      case OrientationType.LandscapeRight:
        yield Receiving();
        break;
      case OrientationType.Suspended:
        yield Busy();
        break;
    }
  }

// ***********************
// ** GetLocation Event **
// ***********************
  Stream<DeviceState> _mapGetLocationState(GetLocation event) async* {
    // Location Available
    yield Ready();
  }
}
