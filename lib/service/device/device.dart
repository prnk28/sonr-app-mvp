import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';
import 'desktop.dart';
import 'mobile.dart';

class DeviceService extends GetxService {
  // Initializers
  bool _isDesktop;
  bool _isMobile;

  // Accessors
  static bool get isRegistered => Get.isRegistered<DeviceService>();
  static DeviceService get to => Get.find<DeviceService>();
  final _platform = Rx<Platform>(null);

  // Platform Checkers
  static bool get isDesktop => Get.find<DeviceService>()._isDesktop;
  static bool get isMobile => Get.find<DeviceService>()._isMobile;
  static bool get isAndroid => Get.find<DeviceService>()._platform.value == Platform.Android;
  static bool get isIOS => Get.find<DeviceService>()._platform.value == Platform.IOS;
  static bool get isLinux => Get.find<DeviceService>()._platform.value == Platform.Linux;
  static bool get isMacOS => Get.find<DeviceService>()._platform.value == Platform.MacOS;
  static bool get isWindows => Get.find<DeviceService>()._platform.value == Platform.Windows;

  // Connection Requirements
  static bool get isReadyToConnect {
    if (isMobile) {
      return MobileService.hasLocation.value && MobileService.hasLocalNetwork.value && UserService.hasUser.value;
    } else {
      return UserService.hasUser.value;
    }
  }

  // * Device Service Initialization * //
  Future<DeviceService> init(bool isDesktop) async {
    // Set Initializers
    _isDesktop = isDesktop;
    _isMobile = !isDesktop;

    // Set Platform
    _platform(PlatformUtils.find());

    // Audio Player
    return this;
  }

  // ^ Builds Connection Request based on Platform ^
  static Future<ConnectionRequest> buildConnectionRequest() async {
    // Initialize Variables
    var device = await newDevice(platform: to._platform.value);

    // @ Mobile - Passes Location
    if (isMobile) {
      var pos = await MobileService.currentLocation();
      return newConnectionRequest(location: Location(latitude: pos.latitude, longitude: pos.longitude));
    }

    // @ Desktop - Calculates Location
    else {
      return ConnectionRequest(
        contact: UserService.contact.value,
        device: device,
      );
    }
  }

  // ^ Provide Device Feedback ^ //
  static void feedback() async {
    if (DeviceService.isMobile) {
      await HapticFeedback.heavyImpact();
    } else {
      DesktopService.openWindow();
    }
  }

  // ^ Method Plays a UI Sound ^
  static void playSound({@required UISoundType type}) async {
    if (isMobile) {
      await MobileService.playSound(type);
    } else {
      await DesktopService.playSound(type);
    }
  }

  // ^ Saves Received Media to Gallery by Platform ^ //
  static void saveTransfer(SonrFile file) async {
    if (isMobile) {
      await MobileService.saveTransfer(file);
    } else {
      OpenFile.open(file.singleFile.path);
    }
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
