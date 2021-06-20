import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/data/core/routing.dart';
import 'package:sonr_app/data/services/client/node.dart';
import 'package:sonr_app/data/services/user/contact.dart';
import 'package:sonr_app/data/services/user/device.dart';

enum Permissions {
  /// Phone Camera Access
  Camera,

  /// Phone Media Gallery Access. `(iOS)` Photos, `(Android)` Storage
  Gallery,

  /// iOS Only: Local Network Communication Permissions
  LocalNetwork,

  /// User Location
  Location,

  /// Microphone for Ultrasonic Sound
  Microphone,

  /// App Notifications Permission
  Notifications,
}

extension PermissionsUtil on Permissions {
  /// Request dialog Title
  String get _dialogTitle => "Needs $name";

  /// Request dialog Description
  String get _dialogDescription {
    switch (this) {
      case Permissions.Camera:
        return 'Sonr Needs to Access your Camera in Order to send Pictures through the app.';
      case Permissions.Gallery:
        return 'Sonr needs your Permission to access your phones Gallery.';
      case Permissions.LocalNetwork:
        return 'Sonr requires local network permissions in order to maximize transfer speed.';
      case Permissions.Location:
        return 'Sonr requires location in order to find devices in your area.';
      case Permissions.Microphone:
        return 'Sonr uses your microphone in order to communicate with other devices.';
      case Permissions.Notifications:
        return 'Sonr would like to send you Notifications for Transfer Invites.';
    }
  }

  /// If the user granted this permission.
  Future<bool> get isGranted async {
    switch (this) {
      case Permissions.Camera:
        return await Permission.camera.isGranted;

      case Permissions.LocalNetwork:
        return await Permission.notification.isGranted;

      case Permissions.Location:
        return await Permission.location.isGranted;

      case Permissions.Microphone:
        return await Permission.microphone.isGranted;

      case Permissions.Notifications:
        return await Permission.notification.isGranted;

      case Permissions.Gallery:
        if (DeviceService.isIOS) {
          return await Permission.photos.isGranted;
        } else {
          return await Permission.storage.isGranted;
        }
    }
  }

  // Permissions Connection Requirements for Sonr Node
  static Future<bool> get isReadyToConnect async {
    final hasUser = ContactService.hasUser.value;
    if (DeviceService.isMobile) {
      final hasLocation = await Permissions.Location.isGranted;
      return hasUser && hasLocation;
    } else {
      return hasUser;
    }
  }

  /// Returns Permissions Enum as Name
  String get name => this.toString().substring(this.toString().indexOf('.') + 1);

  /// Request the user for access to this `Permissions`,
  /// if access hasn't already been grant access before.
  ///
  /// Returns the new [PermissionStatus].
  Future<bool> request() async {
    if (DeviceService.isMobile) {
      switch (this) {
        case Permissions.Camera:
          return await Permission.camera.request().isGranted;

        case Permissions.Location:
          return await Permission.location.request().isGranted;

        case Permissions.Microphone:
          return await Permission.microphone.request().isGranted;

        case Permissions.Notifications:
          return await Permission.notification.request().isGranted;

        case Permissions.LocalNetwork:
          NodeService.to.node.requestLocalNetwork();
          return true;

        case Permissions.Gallery:
          if (DeviceService.isIOS) {
            return await Permission.photos.request().isGranted;
          } else {
            return await Permission.storage.request().isGranted;
          }
      }
    }
    return false;
  }

  /// Request User `Permission` with Dialog View
  Future<bool> requestDialog() async {
    if (await AppRoute.question(
      title: this._dialogTitle,
      description: this._dialogDescription,
      acceptTitle: "Allow",
      declineTitle: "Decline",
    )) {
      return await this.request();
    }
    return false;
  }
}
