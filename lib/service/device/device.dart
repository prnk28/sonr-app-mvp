import 'dart:io' as io;
import 'package:audioplayers/audio_cache.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'mobile.dart';
import 'package:sonr_plugin/src/core/node/provider.dart' as provider;

class DeviceService extends GetxService {
  // Initializers
  bool _isDesktop;
  bool _isMobile;

  // Accessors
  static bool get isRegistered => Get.isRegistered<DeviceService>();
  static DeviceService get to => Get.find<DeviceService>();
  final _platform = Rx<Platform>(null);
  final _audioPlayer = AudioCache(prefix: 'assets/sounds/', respectSilence: true);

  // Platform Checkers
  static bool get isDesktop => Get.find<DeviceService>()._isDesktop;
  static bool get isMobile => Get.find<DeviceService>()._isMobile;
  static bool get isAndroid => Get.find<DeviceService>()._platform.value == Platform.Android;
  static bool get isIOS => Get.find<DeviceService>()._platform.value == Platform.IOS;
  static bool get isLinux => Get.find<DeviceService>()._platform.value == Platform.Linux;
  static bool get isMacOS => Get.find<DeviceService>()._platform.value == Platform.MacOS;
  static bool get isWindows => Get.find<DeviceService>()._platform.value == Platform.Windows;

  // * Device Service Initialization * //
  Future<DeviceService> init(bool isDesktop) async {
    // Set Initializers
    _isDesktop = isDesktop;
    _isMobile = !isDesktop;

    // Set Platform
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

    // Audio Player
    _audioPlayer.disableLog();
    await _audioPlayer.loadAll(List<String>.generate(UISoundType.values.length, (index) => UISoundType.values[index].file));
    return this;
  }

  // * Close Streams * //
  @override
  void onClose() {
    _audioPlayer.clearCache();
    super.onClose();
  }

  // ^ Builds Connection Request based on Platform ^
  static Future<ConnectionRequest> buildConnectionRequest() async {
    // Initialize Variables
    String deviceId = await PlatformDeviceId.getDeviceId;
    var device = await provider.buildDevice(platform: to._platform.value, id: deviceId);

    // @ Mobile - Passes Location
    if (isMobile) {
      var pos = await MobileService.currentLocation();
      return ConnectionRequest(
        latitude: pos.latitude,
        longitude: pos.longitude,
        username: UserService.username,
        contact: UserService.contact.value,
        device: device,
      );
    }

    // @ Desktop - Calculates Location
    else {
      return ConnectionRequest(
        username: UserService.username,
        contact: UserService.contact.value,
        device: device,
      );
    }
  }

  // ^ Method Plays a UI Sound ^
  static void playSound({@required UISoundType type}) async {
    await to._audioPlayer.play(type.file);
  }

  // ^ Method Determines LaunchPage and Changes Screen ^
  static void shiftPage({@required Duration delay}) async {
    Future.delayed(delay, () {
      // @ Mobile Page
      if (isMobile) {
        // Check for User
        if (!UserService.hasUser.value) {
          Get.offNamed("/register");
        } else {
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
        }
      }
      // @ Desktop Page
      else {
        Get.offNamed("/desktop");
      }
    });
  }
}

// ^ Asset Sound Types ^ //
enum UISoundType { Confirmed, Connected, Critical, Deleted, Fatal, Joined, Linked, Received, Swipe, Transmitted, Warning }

// @ Asset Sound Type Utility ^ //
extension UISoundTypeUtil on UISoundType {
  String get file {
    return '${this.value.toLowerCase()}.wav';
  }

  // @ Returns Value Name of Enum Type //
  String get value {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}
