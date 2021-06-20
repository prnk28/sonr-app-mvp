import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sonr_app/env.dart';
import 'package:sonr_app/style.dart';
import 'mobile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:sonr_app/data/services/services.dart';

class DeviceService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<DeviceService>();
  static DeviceService get to => Get.find<DeviceService>();

  // Properties
  final _device = Device().obs;
  final _location = Location().obs;
  final _connectivity = ConnectivityResult.none.obs;

  // Platform Checkers
  static bool get hasInternet => to._connectivity.value != ConnectivityResult.none;
  static bool get isDesktop => to._device.value.platform.isDesktop;
  static bool get isMobile => to._device.value.platform.isMobile;
  static bool get isAndroid => to._device.value.platform.isAndroid;
  static bool get isIOS => to._device.value.platform.isIOS;
  static bool get isLinux => to._device.value.platform.isLinux;
  static bool get isMacOS => to._device.value.platform.isMacOS;
  static bool get isWindows => to._device.value.platform.isWindows;

  // Property Accessors
  static Platform get platform => to._device.value.platform;
  static Device get device => to._device.value;
  static Location get location => to._location.value;
  static Rx<ConnectivityResult> get connectivity => to._connectivity;

  // Connection Requirements
  static bool get isReadyToConnect {
    if (isMobile) {
      return MobileService.hasLocation.value && MobileService.hasLocalNetwork.value && ContactService.hasUser.value;
    } else {
      return ContactService.hasUser.value;
    }
  }

  // * Device Service Initialization * //
  Future<DeviceService> init() async {
    // Set Properties
    var platform = PlatformUtils.find();
    var directories = await Request.getDirectories(platform);
    _connectivity.bindStream(Connectivity().onConnectivityChanged);

    // Initialize Device
    _device.update((val) async {
      if (val != null) {
        // Set Platform
        val.platform = platform;
        val.fileSystem = directories;

        // Set ID
        if (platform.isDesktop) {
          var deviceId = await PlatformDeviceId.getDeviceId;
          if (deviceId != null) {
            val.id = deviceId;
          }
        }
      }
    });
    return this;
  }

  /// @ Provide Device Feedback
  static void feedback() async {
    if (DeviceService.isMobile) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// @ Retreive Location by IP Address
  static Future<Location> findLocation(Platform platform) async {
    // # Check Platform
    if (platform.isMobile) {
      // Check for Mobile Data
      if (to._connectivity.value == ConnectivityResult.mobile) {
        // Geolocater Position
        var pos = await Geolocator.getCurrentPosition();

        // Analytics
        Logger.event(
          name: 'findLocation',
          controller: 'DeviceService',
          parameters: {
            'createdAt': DateTime.now().toString(),
            'platform': platform.toString(),
            'isMobile': platform.isMobile,
            'type': 'GPS-Location',
          },
        );

        // Return Location
        return Location(longitude: pos.longitude, latitude: pos.latitude);
      }
    }

    // # IP Based Location for ALL Devices
    var url = Uri.parse("https://find-any-ip-address-or-domain-location-world-wide.p.rapidapi.com/iplocation?apikey=${Env.ip_key}");

    final response = await http.get(url, headers: {'x-rapidapi-key': Env.rapid_key, 'x-rapidapi-host': Env.rapid_host});

    if (response.statusCode == 200) {
      // Analytics
      Logger.event(
        controller: 'DeviceService',
        name: '[DeviceService]: Find-Location',
        parameters: {
          'createdAt': DateTime.now().toString(),
          'platform': platform.toString(),
          'isMobile': platform.isMobile,
          'type': 'IP-Location',
        },
      );

      // Decode Json
      var json = jsonDecode(response.body);
      return Location(
        state: json["state"],
        continent: json["continent"],
        country: json["country"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );
    } else {
      throw Exception('Failed to Fetch Geolocation IP');
    }
  }

  /// @ Method Hides Keyboard
  static void hideKeyboard() => isMobile ? SystemChannels.textInput.invokeMethod('TextInput.hide') : print("");

  /// @ Method Plays a UI Sound
  static void playSound({required UISoundType type}) async {
    if (isMobile) {
      MobileService.playSound(type);
    }
  }

  /// @ Saves Received Media to Gallery by Platform
  static Future<SaveTransferResult> saveTransfer(SonrFile file) async {
    // Save to Gallery for Mobile
    if (isMobile) {
      // Save All Files
      List<SaveTransferEntry> results = [];
      int mediaCount = 0;
      file.items.forEach((meta) async {
        if (meta.mime.isPhotoVideo) {
          mediaCount += 1;
          final data = await MobileService.saveTransfer(meta);
          results.add(data);
        }
      });

      // Create Transfer Result
      final result = SaveTransferResult(results);

      // Get Title
      var title = mediaCount == file.count ? "Media" : "Transfer";
      if (file.isSingle) {
        title = file.single.mime.isImage ? "Photo" : "Video";
      }

      // Check Result
      if (result.isValid) {
        AppRoute.snack(SnackArgs.success("Succesfully Received $title!"));
      } else {
        AppRoute.snack(SnackArgs.error("Unable to save $title to your Gallery"));
      }

      return result;
    }

    // Open First File for Desktop
    else {
      await OpenFile.open(file.single.path);
      return SaveTransferResult.success();
    }
  }
}

/// @ Asset Sound Types
enum UISoundType { Confirmed, Connected, Critical, Deleted, Fatal, Joined, Linked, Received, Swipe, Transmitted, Warning }

// @ Asset Sound Type Utility
extension UISoundTypeUtil on UISoundType {
  String get file {
    return '${this.value.toLowerCase()}.wav';
  }

  // @ Returns Value Name of Enum Type //
  String get value {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}
