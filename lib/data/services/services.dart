// Client Services
export 'client/lobby.dart';
export 'client/receiver.dart';
export 'client/sender.dart';
export 'client/node.dart';

// Database Service
export 'database/converter.dart';
export 'database/database.dart';
export 'database/cards.dart';

// User Services
export 'user/device.dart';
export 'user/contact.dart';
export 'user/preference.dart';

// Imports
import 'package:sonr_app/env.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/data/data.dart';

/// #### SonrServices
/// Initialize and Check Services
class AppServices {
  /// @ Application Services
  static Future<void> init({bool isDesktop = false}) async {
    await Get.putAsync(() => DeviceService().init(), permanent: true);
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
        rapidApiKey: Env.rapid_key,
        mapQuestKey: Env.map_key,
        mapQuestSecret: Env.map_secret,
      );
}
