import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonr_app/env.dart';
import 'package:sonr_app/modules/activity/activity_controller.dart';
import 'package:sonr_app/modules/peer/peer_controller.dart';
import 'package:sonr_app/modules/share/share_controller.dart';
import 'package:sonr_app/pages/detail/items/contact/tile/tile_controller.dart';
import 'package:sonr_app/pages/home/views/contact/editor/editor_controller.dart';
import 'package:sonr_app/pages/home/views/dashboard/dashboard_controller.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/pages/home/views/contact/profile_controller.dart';
import 'package:sonr_app/pages/explorer/explorer_controller.dart';
import 'package:sonr_app/pages/register/register_controller.dart';
import 'package:sonr_app/pages/transfer/transfer_controller.dart';
import 'package:sonr_app/service/client/session.dart';
import 'package:sonr_app/service/device/auth.dart';
import 'package:sonr_app/style.dart';

/// @ Initial Controller Bindings
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.create<PeerController>(() => PeerController(_getRiveDataFile()));
  }

  // Get Rive File for Peer Bubble
  Future<RiveFile> _getRiveDataFile() async {
    var data = await rootBundle.load('assets/animations/peer_border.riv');
    return RiveFile.import(data);
  }
}

/// @ Home Controller Bindings
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
    // Subsidary Controllers
    Get.put(ShareController(), permanent: true);
    Get.put(ActivityController(), permanent: true);
    Get.put<DashboardController>(DashboardController(), permanent: true);
    Get.put<ProfileController>(ProfileController(), permanent: true);
    Get.put<EditorController>(EditorController(), permanent: true);
    Get.create<TileController>(() => TileController());
  }
}

class ExplorerBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ExplorerController>(ExplorerController(), permanent: true);
  }
}

/// @ Register Page Bindings
class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RegisterController>(RegisterController());
  }
}

/// @ Transfer Screen Bindings
class TransferBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<TransferController>(TransferController(), permanent: true);
  }
}

/// #### SonrServices
/// Initialize and Check Services
class AppServices {
  /// @ Application Services
  static Future<void> init({bool isDesktop = false}) async {
    // First: Device Services
    await Get.putAsync(() => DeviceService().init(), permanent: true);

    // System Service
    await Get.putAsync(() => Logger().init(), permanent: true);

    // Device Services
    if (isDesktop) {
      await Get.putAsync(() => DesktopService().init(), permanent: true);
    } else {
      await Get.putAsync(() => AuthService().init(), permanent: true);
      await Get.putAsync(() => MobileService().init(), permanent: true);
    }

    // Second: User Services
    await Get.putAsync(() => UserService().init(), permanent: true);

    // Third: Initialize Data/Networking Services
    await Get.putAsync(() => TransferService().init());
    await Get.putAsync(() => CardService().init(), permanent: true);
    await Get.putAsync(() => LobbyService().init());
    await Get.putAsync(() => SessionService().init());
    await Get.putAsync(() => SonrService().init(), permanent: true);

    // Fourth: UI Services
    await Get.putAsync(() => SonrOverlay().init(), permanent: true);
    await Get.putAsync(() => SonrPositionedOverlay().init(), permanent: true);
  }

  /// @ Method Validates Required Services Registered
  static bool get areServicesRegistered {
    return DeviceService.isRegistered && UserService.isRegistered && LobbyService.isRegistered;
  }

  /// @ Returns Excluded Sentry Modules
  static List<String> get excludedModules => [
        'open_file',
        'animated_widgets',
        'get',
        'path_provider',
        'camerawesome_plugin',
        'file_picker',
      ];

  /// @ Returns APIKeys from `Env.dart`
  static APIKeys get apiKeys => APIKeys(
        handshakeKey: Env.hs_key,
        handshakeSecret: Env.hs_secret,
        textileKey: Env.hub_key,
        textileSecret: Env.hub_secret,
        ipApiKey: Env.ip_key,
        rapidApiHost: Env.rapid_host,
        rapidApiKey: Env.rapid_key,
      );
}
