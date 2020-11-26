import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  // Initialize
  final SonrBloc sonr;
  DirectionCubit directionCubit = new DirectionCubit();

  // Constructer
  DeviceBloc(this.sonr) : super(null) {
    // ** Directional Events **
    FlutterCompass.events.listen((newDegrees) {
      // Update Direction Cubit
      directionCubit.update(newDegrees.headingForCameraMode);

      // Check if User Node Exists
      if (sonr.node != null) {
        // Update Node State
        sonr.add(NodeUpdate(newDegrees.headingForCameraMode));
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

// ^ LocationPermissionCheck Event ^
  Stream<DeviceState> _mapLocationPermissionCheckState(
      LocationPermissionCheck event) async* {
    // Check Permissions
    LocationPermission permission = await Geolocator.checkPermission();

    // Permission by Case
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // Begin User Setup
      yield LocationPermissionSuccess();
    } else {
      // Permission Denied
      add(LocationPermissionRequested());
      yield LocationPermissionFailure();
    }
  }

// ^ LocationPermissionRequested Event ^
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
