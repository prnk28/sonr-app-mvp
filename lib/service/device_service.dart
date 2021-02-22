import 'dart:async';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:sonr_app/service/sonr_service.dart' hide Position;
import 'package:sonr_app/service/user_service.dart';
import 'package:sonr_app/widgets/overlay.dart';
import 'package:url_launcher/url_launcher.dart';

// @ Enum defines Type of Permission
enum PermissionType { Camera, Gallery, Location, Notifications, Sound }
enum DeviceStatus { Success, NoUser, NoLocation }

class DeviceService extends GetxService {
  // Status/Sensor Properties
  final _direction = Rx<CompassEvent>();
  final _position = Rx<Position>();
  final _status = Rx<DeviceStatus>();

  static Rx<CompassEvent> get direction => Get.find<DeviceService>()._direction;
  static Rx<Position> get position => Get.find<DeviceService>()._position;
  static Rx<DeviceStatus> get status => Get.find<DeviceService>()._status;

  // Permission Properties
  final cameraPermitted = false.obs;
  final galleryPermitted = false.obs;
  final locationPermitted = false.obs;
  final microphonePermitted = false.obs;
  final notificationPermitted = false.obs;

  // ^ Open SharedPreferences on Init ^ //
  Future<DeviceService> init() async {
    await setPermissionStatus();
    await refreshLocation();

    // @ 1. Check for Location
    if (UserService.exists.value) {
      if (locationPermitted.value) {
        _status(DeviceStatus.Success);
        _direction.bindStream(FlutterCompass.events);
      } else {
        _status(DeviceStatus.NoLocation);
      }
    } else {
      _status(DeviceStatus.NoUser);
    }

    return this;
  }

  // ^ CreateUser Event ^
  void createUser(Contact contact, String username) async {
    // Set Sonr Controller
    locationPermitted(await Permission.locationWhenInUse.request().isGranted);
    // @ 1. Check for Location
    if (locationPermitted.value) {
      // Save Current Contact
      await UserService.saveChanges(providedContact: contact);
      SonrService.connect();
      Get.offNamed("/home");
    } else {
      print("Location Permission Denied");
    }
  }

  // ^ Launch a URL Event ^ //
  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // ^ Refresh User Location Position ^ //
  Future<Position> refreshLocation() async {
    if (locationPermitted.value) {
      _position(await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high));
      return _position.value;
    }
    return null;
  }

  // ^ Sets Permission Status from Service ^ //
  Future setPermissionStatus() async {
    cameraPermitted(await Permission.camera.isGranted);
    galleryPermitted(await Permission.mediaLibrary.isGranted);
    locationPermitted(await Permission.locationWhenInUse.isGranted);
    microphonePermitted(await Permission.microphone.isGranted);
    notificationPermitted(await Permission.notification.isGranted);
  }

  // ************************* //
  // ** Permission Requests ** //
  // ************************* //
  static Future<bool> requestCamera() async {
    var decision = await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr Needs to Access your Camera in Order to send Pictures through the app.',
        acceptTitle: "Allow",
        declineTitle: "Decline");

    if (decision) {
      var result = await Permission.camera.request();
      Get.find<DeviceService>().cameraPermitted(result == PermissionStatus.granted);
      return result == PermissionStatus.granted;
    } else {
      return false;
    }
  }

  static Future<bool> requestGallery() async {
    var decision = await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr needs your Permission to access your phones Gallery.',
        acceptTitle: "Allow",
        declineTitle: "Decline");

    if (decision) {
    } else {
      return false;
    }

    var result = await Permission.mediaLibrary.request();
    Get.find<DeviceService>().galleryPermitted(result == PermissionStatus.granted);
    return result == PermissionStatus.granted;
  }

  static Future<bool> requestLocation() async {
    var decision = await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr requires location in order to find devices in your area.',
        acceptTitle: "Allow",
        declineTitle: "Decline");

    if (decision) {
      // Request
      var result = await Permission.locationWhenInUse.request();
      Get.find<DeviceService>().locationPermitted(result == PermissionStatus.granted);

      // Bind Direction Stream
      if (result == PermissionStatus.granted) {
        Get.find<DeviceService>()._direction.bindStream(FlutterCompass.events);
      }
      return result == PermissionStatus.granted;
    } else {
      return false;
    }
  }

  static Future<bool> requestMicrophone() async {
    var decision = await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr uses your microphone in order to communicate with other devices.',
        acceptTitle: "Allow",
        declineTitle: "Decline");

    if (decision) {
      var result = await Permission.microphone.request();
      Get.find<DeviceService>().microphonePermitted(result == PermissionStatus.granted);
      return result == PermissionStatus.granted;
    } else {
      return false;
    }
  }

  static Future<bool> requestNotifications() async {
    var decision = await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr would like to send you Notifications for Transfer Invites.',
        acceptTitle: "Allow",
        declineTitle: "Decline");

    if (decision) {
      var result = await Permission.notification.request();
      Get.find<DeviceService>().notificationPermitted(result == PermissionStatus.granted);
      return result == PermissionStatus.granted;
    } else {
      return false;
    }
  }
}
