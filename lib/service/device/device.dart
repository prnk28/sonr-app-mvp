import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/style/style.dart';
import '../../env.dart';
import 'desktop.dart';
import 'mobile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:platform_device_id/platform_device_id.dart';

class DeviceService extends GetxService {
  // Initializers
  late final bool _isDesktop;
  late bool _isMobile;

  // Accessors
  static bool get isRegistered => Get.isRegistered<DeviceService>();
  static DeviceService get to => Get.find<DeviceService>();

  // Properties
  final _device = Device().obs;
  final _location = Location().obs;

  // Platform Checkers
  static bool get isDesktop => to._isDesktop;
  static bool get isMobile => to._isMobile;
  static bool get isAndroid => to._device.value.platform.isAndroid;
  static bool get isIOS => to._device.value.platform.isIOS;
  static bool get isLinux => to._device.value.platform.isLinux;
  static bool get isMacOS => to._device.value.platform.isMacOS;
  static bool get isWindows => to._device.value.platform.isWindows;

  // Property Accessors
  static Platform get platform => to._device.value.platform;
  static Device get device => to._device.value;
  static Location get location => to._location.value;

  // Connection Requirements
  static bool get isReadyToConnect {
    if (isMobile) {
      return MobileService.hasLocation.value && MobileService.hasLocalNetwork.value && UserService.hasUser.value;
    } else {
      return UserService.hasUser.value;
    }
  }

  // * Device Service Initialization * //
  Future<DeviceService> init(isDesktop) async {
    // Set Initializers
    _isDesktop = isDesktop;
    _isMobile = !isDesktop;

    // Get Info
    var platform = PlatformUtils.find();

    var directories = await Request.getDirectories(platform);

    // Initialize Device
    _device.update((val) async {
      if (val != null) {
        // Set Platform
        val.platform = platform;
        val.fileSystem = directories;

        // Set ID
        if (!isDesktop) {
          var deviceId = await PlatformDeviceId.getDeviceId;
          if (deviceId != null) {
            val.id = deviceId;
          }
        }
      }
    });

    // Set Location
    _location.update((val) async {
      if (val != null) {
        val.ip = await findIPLocation();
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
  static Future<Location_IP> findIPLocation() async {
    var url = Uri.parse("https://find-any-ip-address-or-domain-location-world-wide.p.rapidapi.com/iplocation?apikey=${Env.ip_key}");

    final response = await http.get(url, headers: {'x-rapidapi-key': Env.rapid_key, 'x-rapidapi-host': Env.rapid_host});

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return Location_IP(
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

  /// @ Method Determines LaunchPage and Changes Screen
  static void initialPage({required Duration delay}) async {
    Future.delayed(delay, () {
      // @ Mobile Page
      if (isMobile) {
        // Check for User
        if (!UserService.hasUser.value) {
          Get.offNamed("/register");
        } else {
          // All Valid
          if (MobileService.hasLocation.value) {
            Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
          }

          // No Location
          else {
            Get.find<MobileService>().requestLocation().then((value) {
              if (value) {
                Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
              }
            });
          }
        }
      }
      // @ Desktop Page
      else {
        Get.offNamed("/desktop");
      }
    });
  }

  /// @ Method Plays a UI Sound
  static void playSound({required UISoundType type}) async {
    if (isMobile) {
      MobileService.playSound(type);
    } else {
      DesktopService.playSound(type);
    }
  }

  /// @ Saves Received Media to Gallery by Platform
  static Future<void> saveTransfer(SonrFile file) async {
    // Save to Gallery for Mobile
    if (isMobile) {
      // Save All Files
      bool result = true;
      int mediaCount = 0;
      file.items.forEach((meta) async {
        if (meta.mime.isPhotoVideo) {
          mediaCount += 1;
          result = await MobileService.saveTransfer(meta);
        }
      });

      // Get Title
      var title = mediaCount == file.count ? "Media" : "Transfer";
      if (file.isSingle) {
        title = file.single.mime.isImage ? "Photo" : "Video";
      }

      // Check Result
      if (result) {
        SonrSnack.success("Succesfully Received $title!");
      } else {
        SonrSnack.error("Unable to save $title to your Gallery");
      }
    }

    // Open First File for Desktop
    else {
      await OpenFile.open(file.single.path);
    }
  }

  /// Sets Geolocation for Device
  static void setGeoLocation(Location_Geo geo) {
    to._location.update((val) {
      if (val != null) {
        val.geo = geo;
      }
    });
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
