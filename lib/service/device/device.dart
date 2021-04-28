import 'dart:io' as io;
import 'package:sonr_app/theme/theme.dart';
import 'mobile.dart';
import 'desktop.dart';

class Device extends GetxService {
  // Initializers
  bool _isDesktop;
  bool _isMobile;

  // Accessors
  static bool get isRegistered => Get.isRegistered<Device>();
  static Device get to => Get.find<Device>();
  final _platform = Rx<Platform>(null);

  // Platform Checkers
  static bool get isDesktop => Get.find<Device>()._isDesktop;
  static bool get isMobile => Get.find<Device>()._isMobile;
  static bool get isAndroid => Get.find<Device>()._platform.value == Platform.Android;
  static bool get isIOS => Get.find<Device>()._platform.value == Platform.IOS;
  static bool get isLinux => Get.find<Device>()._platform.value == Platform.Linux;
  static bool get isMacOS => Get.find<Device>()._platform.value == Platform.MacOS;
  static bool get isWindows => Get.find<Device>()._platform.value == Platform.Windows;
  static bool get isNotApple => Get.find<Device>()._platform.value != Platform.IOS && Get.find<Device>()._platform.value != Platform.MacOS;

  // * Device Service Initialization * //
  Future<Device> init({bool isDesktop = false}) async {
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

    // Initialize Correct Device Service
    if (isDesktop) {
      await Get.putAsync(() => DesktopService().init(), permanent: true);
    } else {
      await Get.putAsync(() => MobileService().init(), permanent: true);
    }
    return this;
  }
}
