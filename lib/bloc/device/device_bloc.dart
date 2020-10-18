import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

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
      yield* mapGetLocationState(event);
    }
  }

// ***********************
// ** GetLocation Event **
// ***********************
  Stream<DeviceState> mapGetLocationState(GetLocation event) async* {
    // Check Permissions
    LocationPermission permission = await checkPermission();

    // Permission by Case
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // Get Location
      Location currentLocation = await Location.initialize();

      // Set Node Location
      user.node.location = currentLocation;
      user.node.status = Status.Standby;

      // Location Available
      yield Located(currentLocation);
    } else {
      // Permission Denied
      yield Denied();
    }
  }
}
