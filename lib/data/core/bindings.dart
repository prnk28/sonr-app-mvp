import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonr_app/data/services/user/preference.dart';
import 'package:sonr_app/env.dart';
import 'package:sonr_app/modules/activity/activity.dart';
import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/pages/personal/controllers/personal_controller.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/pages/register/register_controller.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/pages/personal/personal.dart';
import 'package:sonr_app/style/style.dart';

/// @ Initial Controller Bindings
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.create<PeerController>(() => PeerController(_getRiveDataFile()));
  }

  // Get Rive File for Peer Bubble
  Future<RiveFile> _getRiveDataFile() async {
    var data = await RiveBoard.Bubble.load();
    return RiveFile.import(data);
  }
}

/// @ Home Controller Bindings
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
    // Subsidary Controllers
    Get.put(ActivityController());

    // Place Device Specific Controllers
    if (DeviceService.isMobile) {
      Get.put(ShareController(), permanent: true);
      Get.put<PersonalController>(PersonalController(), permanent: true);
      Get.put<EditorController>(EditorController(), permanent: true);
      Get.create<TileController>(() => TileController());
    }
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
    Get.create<ItemController>(() => ItemController());
  }
}

/// #### SonrServices
/// Initialize and Check Services
class AppServices {
  /// @ Application Services
  static Future<void> init({bool isDesktop = false}) async {
    // Firebase Reference
    if (!isDesktop) {
      // Initialize Firebase
      await Firebase.initializeApp();
    }
    await Get.putAsync(() => DeviceService().init(), permanent: true);
    // await Get.putAsync(() => HelperService().init());
    await Get.putAsync(() => Logger().init(), permanent: true);
    await Get.putAsync(() => ContactService().init(), permanent: true);
    await Get.putAsync(() => Preferences().init(), permanent: true);
    await Get.putAsync(() => SenderService().init());
    await Get.putAsync(() => ReceiverService().init());
    await Get.putAsync(() => CardService().init(), permanent: true);
    await Get.putAsync(() => LobbyService().init(), permanent: true);
    await Get.putAsync(() => NodeService().init(), permanent: true);
  }

  /// @ Method Validates Required Services Registered
  static bool get areServicesRegistered {
    return DeviceService.isRegistered && ContactService.isRegistered && LobbyService.isRegistered;
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
