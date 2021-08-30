import 'dart:async';
import 'package:firebase_analytics/observer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:sonr_app/style/style.dart';
import 'package:logger/logger.dart' as util;

const List<String> K_TEST_NAMES = ['sundarp', 'timc', 'pradn'];

class Logger extends GetxService {
  // Accessor Properties
  static bool isTestDevice = false;
  static bool get isRegistered => Get.isRegistered<Logger>();
  static Logger get to => Get.find<Logger>();

  /// Users First Time App Open
  static int get appOpenCount => to._appOpenCount.val;

  /// Users App Open Count
  static bool get appOpenFirst => to._appOpenCount.val == 0 || to._appOpenCount.val == 1;

  /// Wether User SName has been Migrated
  static ReadWriteValue<bool> get hasMigratedSName => to._hasMigratedSName;

  /// Wether User has done a Transfer
  static ReadWriteValue<bool> get hasMigratedKeyPair => to._hasMigratedKeyPair;

  /// Wether User has done a Transfer
  static ReadWriteValue<bool> get hasTransferred => to._hasTransferred;

  /// Wether User has Opened Intercom
  static bool get intercomOpened => to._intercomOpened.val;

  /// Intercome Unread Messages
  static RxInt get intercomUnreadCount => to._intercomUnreadCount;

  // References
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver get Observer => FirebaseAnalyticsObserver(analytics: analytics);

  // Properties
  final _appOpenCount = 0.val('userAppOpenCount', getBox: () => GetStorage('Configuration'));
  final _intercomEnabled = false.obs;
  final _intercomUnreadCount = 0.obs;
  final _intercomOpened = false.val('hasOpenedIntercom', getBox: () => GetStorage('Configuration'));
  final _hasTransferred = false.val('hasHadTransfer', getBox: () => GetStorage('Configuration'));
  final _hasMigratedKeyPair = false.val('userHasUpdatedKeyPair', getBox: () => GetStorage('Configuration'));
  final _hasMigratedSName = false.val('userHasUpdatedSName', getBox: () => GetStorage('Configuration'));

  // References
  static final BuildMode buildMode = BuildModeUtil.mode();
  final util.Logger _log = util.Logger(
    printer: util.PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  Logger() {
    Timer.periodic(2.minutes, (timer) async {
      if (isClosed) {
        timer.cancel();
      }

      if (_intercomEnabled.value) {
        _intercomUnreadCount(await Intercom.unreadConversationCount());
      }
    });
  }

  // * Initializes Logger * //
  Future<Logger> init() async {
    if (DeviceService.isMobile) {
      // Open Configuration Box
      await GetStorage.init('Configuration');
      await GetStorage.init('Onboarding');

      // Update App Open Count
      _appOpenCount.val = _appOpenCount.val + 1;

      // Configure Firebase Scope
      FirebaseAnalytics().setUserId(DeviceService.device.id);
      FirebaseAnalytics().setUserProperty(name: "platform", value: DeviceService.device.platform.toString());

      // Configure Intercom
      await Intercom.initialize(
        AppServices.intercomKeys.item1,
        iosApiKey: AppServices.intercomKeys.item2,
        androidApiKey: AppServices.intercomKeys.item3,
      );
    }
    return this;
  }

  /// #### Initializes Profile for Analytics
  static Future<void> initProfile(Contact contact) async {
    // Check for Test Device
    if (K_TEST_NAMES.any((n) => n.toLowerCase() == contact.sName)) {
      isTestDevice = true;
    }

    // Setup Analytics
    if (isRegistered && DeviceService.isMobile && DeviceService.hasInternet) {
      // Set Firebase User Properties
      FirebaseAnalytics().setUserProperty(name: "firstName", value: contact.firstName);
      FirebaseAnalytics().setUserProperty(name: "lastName", value: contact.lastName);

      // Set Intercom User Properties
      Intercom.registerIdentifiedUser(userId: contact.sName);
      Intercom.updateUser(
        name: contact.fullName,
        //email: contact.emailPrimary.value,
        // phone: contact.phonePrimary,
        customAttributes: {
          "platform": contact.platform.toString(),
          "firstName": contact.firstName,
          "lastName": contact.lastName,
        },
      );

      // Update Status's
      to._intercomEnabled(true);
      to._hasMigratedSName.val = await Namebase.hasSNameRecord();
    }
  }

  /// #### Logs a Firebase Analytics Event
  /// Adds Properties: `createdAt`, `platform`, `controller`
  static void event({
    required AppEvent event,
  }) async {
    if (isRegistered && DeviceService.isMobile && DeviceService.hasInternet) {
      // Log Intercom Event
      await Intercom.logEvent(event.name, event.parameters);

      // Log Firebase Event
      await FirebaseAnalytics().logEvent(
        name: event.name,
        parameters: event.parameters,
      );
    }
  }

  /// #### Prints Debug Log
  static void debug(dynamic m) {
    if (buildMode.isDebug && isRegistered) {
      to._log.d(m);
    }
  }

  /// #### Prints Info Log
  static void info(dynamic m) {
    if (buildMode.isDebug && isRegistered) {
      to._log.i(m);
    }
  }

  /// #### Prints Warn Log
  static void warn(dynamic m) {
    if (buildMode.isDebug && isRegistered) {
      to._log.w(m);
    }
  }

  /// #### Prints Error Log
  static void error(dynamic m) {
    if (buildMode.isDebug && isRegistered) {
      to._log.e(m);
    }
  }

  /// #### Opens Intercom Messenger
  static Future<void> openIntercom() async {
    if (isRegistered && to._intercomEnabled.value && DeviceService.isMobile) {
      if (!to._intercomOpened.val) {
        to._intercomOpened.val = true;
      }
      await Intercom.displayMessenger();
    }
  }

  /// #### Sets Migration as True
  static Future<void> setMigration(DNSRecord record) async {
    if (isRegistered) {
      // Set Result
      to._hasMigratedSName.val = await Namebase.addRecords([record]);

      // Log Event
      Logger.event(
          event: AppEvent.user(UserEvent.MigratedSName, parameters: {
        "status": to._hasMigratedSName.val,
        "sName": record.name,
      }));
    }
  }
}
