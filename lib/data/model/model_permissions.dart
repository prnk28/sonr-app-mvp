import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/theme/theme.dart';

enum UserPermissionType {
  Camera,
  Location,
  LocalNetwork,
  Gallery, // Photos + Storage (Android), Photos(iOS)
  Microphone,
  Notifications,
}

class UserPermissions {
  // Camera
  bool get hasCamera => _hasCamera;
  bool _hasCamera = false;

  // Location
  bool get hasLocation => _hasLocation;
  bool _hasLocation = false;

  bool get hasGallery {
    if (SensorService.isIOS) {
      return _hasPhotos;
    } else {
      return _hasStorage;
    }
  }

  // Local Network
  bool get hasLocalNetwork => _hasLocalNetwork;
  bool _hasLocalNetwork = false;

  // Microphone
  bool get hasMicrophone => _hasMicrophone;
  bool _hasMicrophone = false;

  // Notifications
  bool get hasNotifications => _hasNotifications;
  bool _hasNotifications = false;

  // Photos
  bool get hasPhotos => _hasPhotos;
  bool _hasPhotos = false;

  // Storage
  bool get hasStorage => _hasStorage;
  bool _hasStorage = false;

  UserPermissions() {
    update();
  }

  // ^ Update Method ^ //
  void update() async {
    _hasCamera = await Permission.camera.isGranted;
    _hasLocation = await Permission.locationWhenInUse.isGranted;
    _hasMicrophone = await Permission.microphone.isGranted;
    _hasNotifications = await Permission.notification.isGranted;
    _hasPhotos = await Permission.photos.isGranted;
    _hasStorage = await Permission.storage.isGranted;
  }

  // ^ Request Method ^ //
  Future<bool> request(UserPermissionType type) {
    switch (type) {
      case UserPermissionType.Camera:
        return _requestCamera();
        break;
      case UserPermissionType.Location:
        return _requestLocation();
        break;
      case UserPermissionType.LocalNetwork:
        return _triggerNetwork();
        break;
      case UserPermissionType.Gallery:
        return _requestGallery();
        break;
      case UserPermissionType.Microphone:
        return _requestMicrophone();
        break;
      case UserPermissionType.Notifications:
        return _requestNotifications();
        break;
      default:
        return Future.value(false);
    }
  }

  // ^ Request Camera optional overlay ^ //
  Future<bool> _requestCamera() async {
    if (SensorService.isMobile) {
      // Present Overlay
      if (await SonrOverlay.question(
          title: 'Requires Permission',
          description: 'Sonr Needs to Access your Camera in Order to send Pictures through the app.',
          acceptTitle: "Allow",
          declineTitle: "Decline")) {
        if (await Permission.camera.request().isGranted) {
          this.update();
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

  // ^ Request Gallery optional overlay ^ //
  Future<bool> _requestGallery({String description = 'Sonr needs your Permission to access your phones Gallery.'}) async {
    if (SensorService.isMobile) {
      // Present Overlay
      if (await SonrOverlay.question(title: 'Photos', description: description, acceptTitle: "Allow", declineTitle: "Decline")) {
        if (SensorService.isAndroid) {
          if (await Permission.storage.request().isGranted) {
            this.update();
            return true;
          } else {
            this.update();
            return false;
          }
        } else {
          if (await Permission.photos.request().isGranted) {
            this.update();
            return true;
          } else {
            this.update();
            return false;
          }
        }
      } else {
        this.update();
        return false;
      }
    } else {
      this.update();
      return false;
    }
  }

  // ^ Request Location optional overlay ^ //
  Future<bool> _requestLocation() async {
    if (SensorService.isMobile) {
      // Present Overlay
      if (await SonrOverlay.question(
          title: 'Location',
          description: 'Sonr requires location in order to find devices in your area.',
          acceptTitle: "Allow",
          declineTitle: "Decline")) {
        if (await Permission.locationWhenInUse.request().isGranted) {
          this.update();
          return true;
        } else {
          this.update();
          return false;
        }
      } else {
        this.update();
        return false;
      }
    } else {
      this.update();
      return false;
    }
  }

  // ^ Request Microphone optional overlay ^ //
  Future<bool> _requestMicrophone() async {
    if (SensorService.isMobile) {
      // Present Overlay
      if (await SonrOverlay.question(
          title: 'Microphone',
          description: 'Sonr uses your microphone in order to communicate with other devices.',
          acceptTitle: "Allow",
          declineTitle: "Decline")) {
        if (await Permission.microphone.request().isGranted) {
          this.update();
          return true;
        } else {
          this.update();
          return false;
        }
      } else {
        this.update();
        return false;
      }
    } else {
      this.update();
      return false;
    }
  }

  // ^ Request Notifications optional overlay ^ //
  Future<bool> _requestNotifications() async {
    // Present Overlay
    if (SensorService.isMobile) {
      if (await SonrOverlay.question(
          title: 'Requires Permission',
          description: 'Sonr would like to send you Notifications for Transfer Invites.',
          acceptTitle: "Allow",
          declineTitle: "Decline")) {
        if (await Permission.notification.request().isGranted) {
          this.update();
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
  Future _triggerNetwork() async {
    if (!hasLocalNetwork && SensorService.isIOS) {
      await SonrOverlay.alert(
          title: 'Requires Permission',
          description: 'Sonr requires local network permissions in order to maximize transfer speed.',
          buttonText: "Continue",
          barrierDismissible: false);

      await SonrCore.requestLocalNetwork();
      this.update();
    }
    return true;
  }
}
