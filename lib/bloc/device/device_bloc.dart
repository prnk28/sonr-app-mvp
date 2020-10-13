import 'dart:async';

import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/core/core.dart';
import 'package:equatable/equatable.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  // Initialize
  final UserBloc user;
  double currentDirection = 0;

  // Constructer
  DeviceBloc(this.user) : super(null) {
    // ** Directional Events **
    Compass()
        .compassUpdates(interval: Duration(milliseconds: 100))
        .listen((newDegrees) {
      // Check if User Active
      if (user.node != null && user.node.status != PeerStatus.Busy) {
        // Update Degrees Var
        add(Refresh(direction: newDegrees));
        currentDirection = newDegrees;
      }
    });
  }
  @override
  Stream<DeviceState> mapEventToState(
    DeviceEvent event,
  ) async* {
    if (event is Refresh) {
      yield* _mapRefreshState(event);
    } else if (event is ChangeStatus) {
      yield* _mapChangeStatusState(event);
    } else if (event is GetLocation) {
      yield* _mapGetLocationState(event);
    }
  }

// *******************
// ** Refresh Event **
// *******************
  Stream<DeviceState> _mapRefreshState(Refresh event) async* {
    // Check if Direction Provided
    if (event.direction != null && user.node != null) {
      user.node.direction = event.direction;
    }
    add(ChangeStatus());
    // Update State
    yield Refreshing();
  }

// ************************
// ** ChangeStatus Event **
// ************************
  Stream<DeviceState> _mapChangeStatusState(ChangeStatus event) async* {
    switch (user.node.status) {
      case PeerStatus.Inactive:
        yield Inactive();
        break;
      case PeerStatus.Active:
        yield Ready();
        break;
      case PeerStatus.Searching:
        yield Sending();
        break;
      case PeerStatus.Busy:
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
