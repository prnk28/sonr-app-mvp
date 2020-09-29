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
    // Yield State by Peer Status
    if (user.node.status == PeerStatus.Ready) {
      yield Ready();
    } else if (user.node.status == PeerStatus.Sending) {
      yield Sending();
    } else if (user.node.status == PeerStatus.Receiving) {
      yield Receiving();
    } else if (user.node.status == PeerStatus.Busy) {
      yield Busy();
    }
    yield Inactive();
  }
}
