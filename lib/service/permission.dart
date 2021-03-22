import 'dart:async';
import 'dart:io' as io;
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart' hide Position;

class PermissionService extends GetxService {
  // Permissions Values
  final cameraPermitted = false.val('cameraPermitted', getBox: () => GetStorage('Permissions'));
  final galleryPermitted = false.val('galleryPermitted', getBox: () => GetStorage('Permissions'));
  final locationPermitted = false.val('locationPermitted', getBox: () => GetStorage('Permissions'));
  final microphonePermitted = false.val('microphonePermitted', getBox: () => GetStorage('Permissions'));
  final networkTriggered = false.val('networkTriggered', getBox: () => GetStorage('Permissions'));
  final notificationPermitted = false.val('notificationPermitted', getBox: () => GetStorage('Permissions'));

  // ^ Open GetStorage on Init ^ //
  Future<PermissionService> init() async {
    // Initialize Storage
    await GetStorage.init('Permissions');
    return this;
  }

  // ^ Request Camera optional overlay ^ //
  Future<bool> requestCamera() async {
    // Present Overlay
    if (await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr Needs to Access your Camera in Order to send Pictures through the app.',
        acceptTitle: "Allow",
        declineTitle: "Decline")) {
      if (await Permission.camera.request().isGranted) {
        cameraPermitted.val = true;
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // ^ Request Gallery optional overlay ^ //
  Future<bool> requestGallery({String description = 'Sonr needs your Permission to access your phones Gallery.'}) async {
    // Present Overlay
    if (await SonrOverlay.question(title: 'Photos', description: description, acceptTitle: "Allow", declineTitle: "Decline")) {
      if (io.Platform.isAndroid) {
        if (await Permission.storage.request().isGranted && await Permission.photos.request().isGranted) {
          galleryPermitted.val = true;
          return true;
        } else {
          return false;
        }
      } else {
        if (await Permission.photos.request().isGranted) {
          galleryPermitted.val = true;
          return true;
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }

  // ^ Request Location optional overlay ^ //
  Future<bool> requestLocation() async {
    // Present Overlay
    if (await SonrOverlay.question(
        title: 'Location',
        description: 'Sonr requires location in order to find devices in your area.',
        acceptTitle: "Allow",
        declineTitle: "Decline")) {
      if (await Permission.locationWhenInUse.request().isGranted) {
        locationPermitted.val = true;
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // ^ Request Microphone optional overlay ^ //
  Future<bool> requestMicrophone() async {
    // Present Overlay
    if (await SonrOverlay.question(
        title: 'Microphone',
        description: 'Sonr uses your microphone in order to communicate with other devices.',
        acceptTitle: "Allow",
        declineTitle: "Decline")) {
      if (await Permission.microphone.request().isGranted) {
        microphonePermitted.val = true;
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // ^ Request Notifications optional overlay ^ //
  Future<bool> requestNotifications() async {
    // Present Overlay
    if (await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr would like to send you Notifications for Transfer Invites.',
        acceptTitle: "Allow",
        declineTitle: "Decline")) {
      if (await Permission.notification.request().isGranted) {
        notificationPermitted.val = true;
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // ^ Trigger iOS Local Network with Alert ^ //
  Future triggerNetwork() async {
    if (!networkTriggered.val && io.Platform.isIOS) {
      await SonrOverlay.alert(
          title: 'Requires Permission',
          description: 'Sonr requires local network permissions in order to maximize transfer speed.',
          buttonText: "Continue",
          barrierDismissible: false);

      await SonrCore.requestLocalNetwork();
      networkTriggered.val = true;
    }
    return true;
  }
}
