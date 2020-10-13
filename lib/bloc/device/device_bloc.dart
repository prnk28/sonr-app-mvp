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
  DirectionCubit directionCubit = new DirectionCubit();

  // Constructer
  DeviceBloc(this.user) : super(null) {
    // ** Directional Events **
    Compass()
        .compassUpdates(interval: Duration(milliseconds: 100))
        .listen((newDegrees) {
      // Update Degrees Var
      directionCubit.update(newDegrees);
    });
  }
  @override
  Stream<DeviceState> mapEventToState(
    DeviceEvent event,
  ) async* {
    if (event is GetLocation) {
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
}
