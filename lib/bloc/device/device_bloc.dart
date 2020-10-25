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
      // Update Direction Cubit
      directionCubit.update(newDegrees);

      // Check if User Node Exists
      if (user.node != null) {
// User is Searching
        if (user.node.status == Status.Searching) {
          // Update Direction
          user.node.direction = newDegrees;

          // Update WebBloc State
          user.add(NodeSearch());
        }
        // User with 500ms delay
        else if (user.node.status == Status.Available) {
          // Update Direction
          user.node.direction = newDegrees;

          // Update WebBloc State
          user.add(NodeAvailable());
        }
      }
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
      user.add(UserStarted(event.data, event.signal));
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
