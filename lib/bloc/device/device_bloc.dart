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
    if (event is Initialize) {
      yield* mapInitializeState(event);
    }
  }

// ***********************
// ** Initialize Event **
// ***********************
  Stream<DeviceState> mapInitializeState(Initialize event) async* {
    // Check Permissions
    LocationPermission permission = await checkPermission();

    // Permission by Case
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // Begin User Setup
      user.add(CheckProfile());
    } else {
      if (await Permission.locationWhenInUse.request().isGranted) {
        add(Initialize());
      } else {
        // Permission Denied
        yield Denied();
      }
    }
  }
}
