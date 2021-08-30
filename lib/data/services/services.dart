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

// Packages
export 'package:firebase_analytics/firebase_analytics.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_messaging/firebase_messaging.dart';
export 'package:intercom_flutter/intercom_flutter.dart';

// Imports
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/data/data.dart';

/// #### SonrServices
/// Initialize and Check Services
class AppServices {
  /// #### Application Services
  static Future<void> init() async {
    // Initialize Services
    await dotenv.load(fileName: ".env");
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

  /// #### Method Validates Required Services Registered
  static bool get isReadyToCommunicate {
    return DeviceService.isRegistered && ContactService.isRegistered && LobbyService.isRegistered && NodeService.isRegistered;
  }

  /// #### Returns Excluded Sentry Modules
  static List<String> get excludedModules => [
        'open_file',
        'animated_widgets',
        'get',
        'path_provider',
        'camerawesome_plugin',
        'file_picker',
      ];

  /// #### Returns APIKeys from `Env.dart`
  static APIKeys get apiKeys => APIKeys(
        ipApiKey: dotenv.env['IP_KEY'],
        rapidApiKey: dotenv.env['RAPID_KEY'],
        handshakeKey: dotenv.env['HS_KEY'],
        handshakeSecret: dotenv.env['HS_SECRET'],
        textileKey: dotenv.env['HUB_KEY'],
        textileSecret: dotenv.env['HUB_SECRET'],
        pushKeyPath: DeviceService.pushKeyPath,
      );

  /// #### Returns Handshake API Key/Secret
  static Tuple<String, String> get handshakeKeys => Tuple(
        dotenv.env['HS_KEY'] ?? '',
        dotenv.env['HS_SECRET'] ?? '',
      );

  /// #### Returns Intercom App ID/iOS Key/Android Key
  static Triple<String, String, String> get intercomKeys => Triple(
        dotenv.env['INTERCOM_APP_ID'] ?? '',
        dotenv.env['INTERCOM_IOS_KEY'] ?? '',
        dotenv.env['INTERCOM_ANDROID_KEY'] ?? '',
      );
}
