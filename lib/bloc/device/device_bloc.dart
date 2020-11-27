import 'package:flutter/widgets.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/bloc/sonrN/sonr_service.dart';
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
  DeviceBloc(this.sonr) : super(DeviceLoading()) {
    // ** Directional Events **
    FlutterCompass.events.listen((newDegrees) {
      // @ Check if Correct State
      if (sonr.state is NodeAvailable || sonr.state is NodeSearching) {
        // Get Current Direction and Update Cubit
        double direction = newDegrees.headingForCameraMode;
        directionCubit.update(direction);

        // Update Node Direction
        sonr.node.update(direction);
      }
    });
  }
  @override
  Stream<DeviceState> mapEventToState(
    DeviceEvent event,
  ) async* {
    if (event is StartApp) {
      yield* _mapStartAppState(event);
    } else if (event is CreateUser) {
      yield* _mapCreateUserState(event);
    } else if (event is RequestPermission) {
      yield* _mapRequestPermissionState(event);
    }
  }

// ^ StartApp Event ^
  Stream<DeviceState> _mapStartAppState(StartApp event) async* {
    // @ 1. Check for Location
    if (await Permission.locationWhenInUse.request().isGranted) {
      // @ 2. Check for Profile
      User user = await User.get();
      if (user != null) {
        // Get Current Position
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        // Initialize Sonr Node
        sonr.add(NodeInitialize(user.contact, position));

        // Initialize Node
        sonrService.setState((s) => {s.initialize(position, user.contact)});

        yield DeviceActive();
      } else {
        // ! Profile wasnt found
        yield ProfileError();
      }
    } else {
      // ! Location Permission Denied
      yield RequiredPermissionError();
    }
  }

  // ^ CreateUser Event ^
  Stream<DeviceState> _mapCreateUserState(CreateUser event) async* {
    // @ 1. Check for Location
    if (await Permission.locationWhenInUse.request().isGranted) {
      // Get Data
      var user = await User.create(event.contact, event.context);

      // Get Current Position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Initialize Sonr Node
      sonr.add(NodeInitialize(user.contact, position));
      yield DeviceActive();
    } else {
      // ! Location Permission Denied
      yield RequiredPermissionError();
    }
  }

// ^ RequestPermission Event ^
  Stream<DeviceState> _mapRequestPermissionState(
      RequestPermission event) async* {
    switch (event.type) {
      case PermissionType.Location:
        if (await Permission.locationWhenInUse.request().isGranted) {
          yield PermissionSuccess(event.type);
        } else {
          yield PermissionFailure(event.type);
        }
        break;

      case PermissionType.Camera:
        if (await Permission.camera.request().isGranted) {
          yield PermissionSuccess(event.type);
        } else {
          yield PermissionFailure(event.type);
        }
        break;

      case PermissionType.Photos:
        if (await Permission.mediaLibrary.request().isGranted) {
          yield PermissionSuccess(event.type);
        } else {
          yield PermissionFailure(event.type);
        }
        break;

      case PermissionType.Notifications:
        if (await Permission.notification.request().isGranted) {
          yield PermissionSuccess(event.type);
        } else {
          yield PermissionFailure(event.type);
        }
        break;
    }
  }
}
