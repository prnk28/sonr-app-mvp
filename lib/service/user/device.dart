import 'dart:async';
import 'dart:io' as io;
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

// @ Enum defines Type of Permission
enum PermissionType { Camera, Gallery, Location, Notifications, Sound }
const K_SENSOR_INTERVAL = Duration.microsecondsPerSecond ~/ 30;

class DeviceService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<DeviceService>();
  static DeviceService get to => Get.find<DeviceService>();

  // Device/Location Properties
  final _keyboardVisible = false.obs;
  final _location = Rx<geo.Position>(null);
  final _platform = Rx<Platform>(null);
  final _position = Rx<Position>(Position());

  // Getters for Device/Location References
  static RxBool get keyboardVisible => to._keyboardVisible;
  static Rx<Platform> get platform => to._platform;
  static Rx<Position> get position => to._position;

  // Platform Checkers
  static bool get isDesktop =>
      Get.find<DeviceService>()._platform.value == Platform.Linux ||
      Get.find<DeviceService>()._platform.value == Platform.MacOS ||
      Get.find<DeviceService>()._platform.value == Platform.Windows;
  static bool get isMobile =>
      Get.find<DeviceService>()._platform.value == Platform.IOS || Get.find<DeviceService>()._platform.value == Platform.Android;
  static bool get isAndroid => Get.find<DeviceService>()._platform.value == Platform.Android;
  static bool get isIOS => Get.find<DeviceService>()._platform.value == Platform.IOS;
  static bool get isLinux => Get.find<DeviceService>()._platform.value == Platform.Linux;
  static bool get isMacOS => Get.find<DeviceService>()._platform.value == Platform.MacOS;
  static bool get isWindows => Get.find<DeviceService>()._platform.value == Platform.Windows;
  static bool get isNotApple =>
      Get.find<DeviceService>()._platform.value != Platform.IOS && Get.find<DeviceService>()._platform.value != Platform.MacOS;

  // Controllers
  final _audioPlayer = AudioCache(prefix: 'assets/sounds/', respectSilence: true);
  final _keyboardVisibleController = KeyboardVisibilityController();

  // References
  StreamSubscription<AccelerometerEvent> _accelStream;
  StreamSubscription<CompassEvent> _compassStream;
  StreamSubscription<GyroscopeEvent> _gyroStream;
  StreamSubscription<MagnetometerEvent> _magnoStream;
  StreamSubscription<OrientationEvent> _orienStream;

  // * Device Service Initialization * //
  Future<DeviceService> init() async {
    // @ 1. Set Platform
    if (io.Platform.isAndroid) {
      _platform(Platform.Android);
    } else if (io.Platform.isIOS) {
      _platform(Platform.IOS);
    } else if (io.Platform.isLinux) {
      _platform(Platform.Linux);
    } else if (io.Platform.isMacOS) {
      _platform(Platform.MacOS);
    } else if (io.Platform.isWindows) {
      _platform(Platform.Windows);
    }

    // @ 2. Initialize References
    // Audio Player
    _audioPlayer.disableLog();
    await _audioPlayer.loadAll(List<String>.generate(UISoundType.values.length, (index) => UISoundType.values[index].file));

    // Handle Keyboard Visibility
    _keyboardVisible.bindStream(_keyboardVisibleController.onChange);

    // @ 3. Bind Sensors for Mobile
    if (_platform.value == Platform.IOS || _platform.value == Platform.Android) {
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
    }
    return this;
  }

  // * Close Streams * //
  @override
  void onClose() {
    _audioPlayer.clearCache();
    _accelStream.cancel();
    _compassStream.cancel();
    _gyroStream.cancel();
    _magnoStream.cancel();
    _orienStream.cancel();
    super.onClose();
  }

  // ^ Method Plays a UI Sound ^
  static void playSound({@required UISoundType type}) async {
    await to._audioPlayer.play(type.file);
  }

  // ^ Method Determines LaunchPage and Changes Screen ^
  static void shiftPage({@required Duration delay}) async {
    Future.delayed(delay, () {
      // Check for User
      if (!UserService.hasUser.value) {
        Get.offNamed("/register");
      } else {
        if (isMobile) {
          // All Valid
          if (UserService.permissions.value.hasLocation) {
            Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
          }

          // No Location
          else {
            Get.find<UserService>().requestLocation().then((value) {
              if (value) {
                Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
              }
            });
          }
        } else {
          Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
        }
      }
    });
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

// ^ Asset Sound Types ^ //
enum UISoundType { Confirmed, Connected, Critical, Deleted, Fatal, Joined, Linked, Received, Swipe, Transmitted, Warning }

// ^ Asset Sound Type Utility ^ //
extension UISoundTypeUtil on UISoundType {
  String get file {
    return '${this.value.toLowerCase()}.wav';
  }

  // @ Returns Value Name of Enum Type //
  String get value {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}
