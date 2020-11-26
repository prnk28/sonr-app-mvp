import 'package:flutter/widgets.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_core/sonr_core.dart';

part 'device_event.dart';
part 'device_state.dart';

Size screenSize;

// ^ DeviceBloc handles profile, permissions, and Compass ^
class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  // Initialize
  final SonrBloc sonr;
  DirectionCubit directionCubit = new DirectionCubit();

  // Constructer
  DeviceBloc(this.sonr) : super(null) {
    // ** Directional Events **
    FlutterCompass.events.listen((newDegrees) {
      // Check if User Node Exists
      if (sonr.state is NodeAvailable || sonr.state is NodeSearching) {
        // Get Current Direction
        double direction = newDegrees.headingForCameraMode;

        // Update Direction Cubit
        directionCubit.update(direction);

        // Update Node State
        sonr.add(NodeUpdate(direction));
      }
    });
  }
  @override
  Stream<DeviceState> mapEventToState(
    DeviceEvent event,
  ) async* {
    if (event is StartApp) {
      yield* _mapStartAppState(event);
    } else if (event is CreateProfile) {
      yield* _mapCreateProfileState(event);
    } else if (event is RequestPermission) {
      yield* _mapRequestPermissionState(event);
    }
  }

// ^ StartApp Event ^
  Stream<DeviceState> _mapStartAppState(StartApp event) async* {
    // @ 1. Check for Location
    if (await Permission.locationWhenInUse.request().isGranted) {
      // @ 2. Check for Profile
      Profile profile = await Profile.get();
      if (profile != null) {
        // Get Current Position
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        // Set Screen Size
        screenSize = Size(profile.screenWidth, profile.screenHeight);

        // Initialize Sonr Node
        sonr.add(NodeInitialize(profile.contact, position));
        yield DeviceActive();
      }
      // ! Profile wasnt found
      yield ProfileError();
    }
    // ! Location Permission Denied
    yield RequiredPermissionError();
  }

  // ^ CreateProfile Event ^
  Stream<DeviceState> _mapCreateProfileState(CreateProfile event) async* {
    // @ 1. Check for Location
    if (await Permission.locationWhenInUse.request().isGranted) {
      // Get Data
      var profile = await Profile.create(event.contact, event.context);

      // Set Screen Size
      screenSize = Size(profile.screenWidth, profile.screenHeight);

      // Get Current Position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Initialize Sonr Node
      sonr.add(NodeInitialize(profile.contact, position));
      yield DeviceActive();
    }
    // ! Location Permission Denied
    yield RequiredPermissionError();
  }

// ^ RequestPermission Event ^
  Stream<DeviceState> _mapRequestPermissionState(
      RequestPermission event) async* {
    switch (event.type) {
      case PermissionType.Location:
        if (await Permission.locationWhenInUse.request().isGranted) {
          yield PermissionSuccess(event.type);
        }
        yield PermissionFailure(event.type);
        break;

      case PermissionType.Camera:
        if (await Permission.camera.request().isGranted) {
          yield PermissionSuccess(event.type);
        }
        yield PermissionFailure(event.type);
        break;

      case PermissionType.Photos:
        if (await Permission.mediaLibrary.request().isGranted) {
          yield PermissionSuccess(event.type);
        }
        yield PermissionFailure(event.type);
        break;

      case PermissionType.Notifications:
        if (await Permission.notification.request().isGranted) {
          yield PermissionSuccess(event.type);
        }
        yield PermissionFailure(event.type);
        break;
    }
  }
}
