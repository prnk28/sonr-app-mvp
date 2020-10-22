import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:permission_handler/permission_handler.dart';

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
    if (event is LocationPermissionCheck) {
      yield* _mapLocationPermissionCheckState(event);
    } else if (event is LocationPermissionRequested) {
      yield* _mapLocationPermissionRequestedState(event);
    }
  }

// ***********************************
// ** LocationPermissionCheck Event **
// ***********************************
  Stream<DeviceState> _mapLocationPermissionCheckState(
      LocationPermissionCheck event) async* {
    // Intialize FileType
    await initFileType();

    // Check Permissions
    LocationPermission permission = await checkPermission();

    // Permission by Case
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // Begin User Setup
      user.add(UserStarted());
      yield LocationPermissionSuccess();
    } else {
      // Permission Denied
      add(LocationPermissionRequested());
      yield LocationPermissionFailure();
    }
  }

// ***************************************
// ** LocationPermissionRequested Event **
// ***************************************
  Stream<DeviceState> _mapLocationPermissionRequestedState(
      LocationPermissionRequested event) async* {
    // Ask for Locations Permission
    if (await Permission.locationWhenInUse.request().isGranted) {
      yield LocationPermissionSuccess();
    } else {
      // Permission Denied
      yield LocationPermissionFailure();
    }
  }
}
