import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

// @ Enum defines Type of Permission
enum PermissionType { Camera, Gallery, Location, Notifications, Sound }
const K_SENSOR_INTERVAL = Duration.microsecondsPerSecond ~/ 30;

class MobileService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<MobileService>();
  static MobileService get to => Get.find<MobileService>();

  // Device/Location Properties
  final _keyboardVisible = false.obs;
  final _location = Rx<geo.Position>(null);
  final _position = Rx<Position>(Position());

  // Getters for Device/Location References
  static RxBool get keyboardVisible => to._keyboardVisible;
  static Rx<Position> get position => to._position;

  // Controllers
  final _keyboardVisibleController = KeyboardVisibilityController();

  // References
  StreamSubscription<AccelerometerEvent> _accelStream;
  StreamSubscription<CompassEvent> _compassStream;
  StreamSubscription<GyroscopeEvent> _gyroStream;
  StreamSubscription<MagnetometerEvent> _magnoStream;
  StreamSubscription<OrientationEvent> _orienStream;

  // * Device Service Initialization * //
  Future<MobileService> init() async {
    // Handle Keyboard Visibility
    _keyboardVisible.bindStream(_keyboardVisibleController.onChange);

    // @ 3. Bind Sensors for Mobile
    // Bind Direction and Set Intervals
    motionSensors.accelerometerUpdateInterval = K_SENSOR_INTERVAL;
    motionSensors.magnetometerUpdateInterval = K_SENSOR_INTERVAL;
    motionSensors.orientationUpdateInterval = K_SENSOR_INTERVAL;
    motionSensors.gyroscopeUpdateInterval = K_SENSOR_INTERVAL;
    motionSensors.userAccelerometerUpdateInterval = K_SENSOR_INTERVAL;

    // Bind Sensor Streams
    _accelStream = motionSensors.accelerometer.listen(_handleAccelerometer);
    _compassStream = FlutterCompass.events.listen(_handleCompass);
    _gyroStream = motionSensors.gyroscope.listen(_handleGyroscope);
    _magnoStream = motionSensors.magnetometer.listen(_handleMagnometer);
    _orienStream = motionSensors.orientation.listen(_handleOrientation);
    return this;
  }

  // * Close Streams * //
  @override
  void onClose() {
    _accelStream.cancel();
    _compassStream.cancel();
    _gyroStream.cancel();
    _magnoStream.cancel();
    _orienStream.cancel();
    super.onClose();
  }

  // ^ Method Closes Keyboard if Active ^ //
  static void closeKeyboard({BuildContext context}) async {
    if (to._keyboardVisible.value) {
      FocusScope.of(context ?? Get.context).unfocus();
    }
  }

  // ^ Refresh User Location Position ^ //
  static Future<geo.Position> currentLocation() async {
    if (UserService.permissions.value.hasLocation) {
      to._location(await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high));
      return to._location.value;
    } else {
      print("No Location Permissions");
      return null;
    }
  }

  // # Handle Accelerometer
  void _handleAccelerometer(AccelerometerEvent event) {
    _position.update((val) {
      val.accelerometer = Position_Accelerometer(x: event.x, y: event.y, z: event.z);
    });
  }

  // # Handle Compass
  void _handleCompass(CompassEvent event) {
    _position.update((val) {
      val.heading = event.heading;
      val.facing = event.headingForCameraMode;
    });
  }

  // # Handle Gyroscope
  void _handleGyroscope(GyroscopeEvent event) {
    _position.update((val) {
      val.gyroscope = Position_Gyroscope(x: event.x, y: event.y, z: event.z);
    });
  }

  // # Handle Magnometer
  void _handleMagnometer(MagnetometerEvent event) {
    _position.update((val) {
      val.magnometer = Position_Magnometer(x: event.x, y: event.y, z: event.z);
    });
  }

  // # Handle Orientation
  void _handleOrientation(OrientationEvent event) {
    _position.update((val) {
      val.orientation = Position_Orientation(pitch: event.pitch, roll: event.roll, yaw: event.yaw);
    });
  }
}
