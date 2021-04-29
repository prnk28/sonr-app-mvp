import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/service/device/device.dart';

// @ Enum defines Type of Permission
const K_SENSOR_INTERVAL = Duration.microsecondsPerSecond ~/ 30;

class MobileService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<MobileService>();
  static MobileService get to => Get.find<MobileService>();

  // Permissions
  final _hasCamera = false.obs;
  final _hasLocation = false.obs;
  final _hasLocalNetwork = false.obs;
  final _hasMicrophone = false.obs;
  final _hasNotifications = false.obs;
  final _hasPhotos = false.obs;
  final _hasStorage = false.obs;

  // Device/Location Properties
  final _keyboardVisible = false.obs;
  final _location = Rx<geo.Position>(null);
  final _position = Rx<Position>(Position());

  // Getters for Device/Location References
  static RxBool get keyboardVisible => to._keyboardVisible;
  static Rx<Position> get position => to._position;
  static RxBool get hasCamera => to._hasCamera;
  static RxBool get hasLocation => to._hasLocation;
  static RxBool get hasLocalNetwork => to._hasLocalNetwork;
  static RxBool get hasMicrophone => to._hasMicrophone;
  static RxBool get hasNotifications => to._hasNotifications;
  static RxBool get hasPhotos => to._hasPhotos;
  static RxBool get hasStorage => to._hasStorage;
  static RxBool get hasGallery {
    if (DeviceService.isIOS) {
      return to._hasPhotos;
    } else {
      return to._hasStorage;
    }
  }

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

    // Set Permissions Status
    updatePermissionsStatus();
    SonrOverlay.back();
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
    if (to._hasLocation.value) {
      to._location(await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high));
      return to._location.value;
    } else {
      print("No Location Permissions");
      return null;
    }
  }

  // ^ Update Method ^ //
  void updatePermissionsStatus() async {
    _hasCamera(await Permission.camera.isGranted);
    _hasLocation(await Permission.locationWhenInUse.isGranted);
    _hasMicrophone(await Permission.microphone.isGranted);
    _hasNotifications(await Permission.notification.isGranted);
    _hasPhotos(await Permission.photos.isGranted);
    _hasStorage(await Permission.storage.isGranted);
  }

  // ^ Request Camera optional overlay ^ //
  Future<bool> requestCamera() async {
    if (DeviceService.isMobile) {
      // Present Overlay
      if (await SonrOverlay.question(
          title: 'Requires Permission',
          description: 'Sonr Needs to Access your Camera in Order to send Pictures through the app.',
          acceptTitle: "Allow",
          declineTitle: "Decline")) {
        if (await Permission.camera.request().isGranted) {
          updatePermissionsStatus();
          SonrOverlay.back();
          SonrOverlay.back();
          return true;
        } else {
          updatePermissionsStatus();
          SonrOverlay.back();
          SonrOverlay.back();
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // ^ Request Gallery optional overlay ^ //
  Future<bool> requestGallery({String description = 'Sonr needs your Permission to access your phones Gallery.'}) async {
    if (DeviceService.isMobile) {
      // Present Overlay
      if (await SonrOverlay.question(title: 'Photos', description: description, acceptTitle: "Allow", declineTitle: "Decline")) {
        if (DeviceService.isAndroid) {
          if (await Permission.storage.request().isGranted) {
            updatePermissionsStatus();
            SonrOverlay.back();
            return true;
          } else {
            updatePermissionsStatus();
            SonrOverlay.back();
            return false;
          }
        } else {
          if (await Permission.photos.request().isGranted) {
            updatePermissionsStatus();
            SonrOverlay.back();
            return true;
          } else {
            updatePermissionsStatus();
            SonrOverlay.back();
            return false;
          }
        }
      } else {
        updatePermissionsStatus();
        SonrOverlay.back();
        SonrOverlay.back();
        return false;
      }
    } else {
      updatePermissionsStatus();
      SonrOverlay.back();
      SonrOverlay.back();
      return false;
    }
  }

  // ^ Request Location optional overlay ^ //
  Future<bool> requestLocation() async {
    if (DeviceService.isMobile) {
      // Present Overlay
      if (await SonrOverlay.question(
          title: 'Location',
          description: 'Sonr requires location in order to find devices in your area.',
          acceptTitle: "Allow",
          declineTitle: "Decline")) {
        if (await Permission.locationWhenInUse.request().isGranted) {
          updatePermissionsStatus();
          SonrOverlay.back();
          return true;
        } else {
          updatePermissionsStatus();
          SonrOverlay.back();
          return false;
        }
      } else {
        updatePermissionsStatus();
        SonrOverlay.back();
        return false;
      }
    } else {
      updatePermissionsStatus();
      SonrOverlay.back();
      return false;
    }
  }

  // ^ Request Microphone optional overlay ^ //
  Future<bool> requestMicrophone() async {
    if (DeviceService.isMobile) {
      // Present Overlay
      if (await SonrOverlay.question(
          title: 'Microphone',
          description: 'Sonr uses your microphone in order to communicate with other devices.',
          acceptTitle: "Allow",
          declineTitle: "Decline")) {
        if (await Permission.microphone.request().isGranted) {
          updatePermissionsStatus();
          SonrOverlay.back();
          return true;
        } else {
          updatePermissionsStatus();
          SonrOverlay.back();
          return false;
        }
      } else {
        updatePermissionsStatus();
        SonrOverlay.back();
        return false;
      }
    } else {
      updatePermissionsStatus();
      SonrOverlay.back();
      return false;
    }
  }

  // ^ Request Notifications optional overlay ^ //
  Future<bool> requestNotifications() async {
    // Present Overlay
    if (DeviceService.isMobile) {
      if (await SonrOverlay.question(
          title: 'Requires Permission',
          description: 'Sonr would like to send you Notifications for Transfer Invites.',
          acceptTitle: "Allow",
          declineTitle: "Decline")) {
        if (await Permission.notification.request().isGranted) {
          updatePermissionsStatus();
          SonrOverlay.back();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // ^ Trigger iOS Local Network with Alert ^ //
  Future triggerNetwork() async {
    if (!_hasLocalNetwork.value && DeviceService.isIOS) {
      await SonrOverlay.alert(
          title: 'Requires Permission',
          description: 'Sonr requires local network permissions in order to maximize transfer speed.',
          buttonText: "Continue",
          barrierDismissible: false);

      await SonrService.requestLocalNetwork();
      updatePermissionsStatus();
      SonrOverlay.back();
    }
    return true;
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
