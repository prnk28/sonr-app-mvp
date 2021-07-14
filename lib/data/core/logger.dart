import 'dart:async';
import 'package:firebase_analytics/observer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:sonr_app/env.dart';
import 'package:sonr_app/style/style.dart';
import 'package:logger/logger.dart' as util;
import 'package:firebase_analytics/firebase_analytics.dart';

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
  static ReadWriteValue<bool> get hasTransferred => to._hasTransferred;

  /// Wether User has Opened Intercom
  static bool get intercomOpened => to._intercomOpened.val;

  /// Intercome Unread Messages
  static RxInt get intercomUnreadCount => to._intercomUnreadCount;

  // References
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver get Observer => FirebaseAnalyticsObserver(analytics: analytics);

  // Properties
  final _hasIntercom = false.obs;
  final _intercomUnreadCount = 0.obs;
  final _intercomOpened = false.val('hasOpenedIntercom', getBox: () => GetStorage('Configuration'));
  final _hasTransferred = false.val('hasHadTransfer', getBox: () => GetStorage('Configuration'));
  final _appOpenCount = 0.val('userAppOpenCount', getBox: () => GetStorage('Configuration'));
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
      if (_hasIntercom.value) {
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
        Env.icom_appID,
        iosApiKey: Env.icom_iosKey,
        androidApiKey: Env.icom_androidKey,
      );
    }
    return this;
  }

  /// #### Initializes Profile for Analytics
  static void initProfile(Profile profile) {
    if (isRegistered && DeviceService.isMobile && DeviceService.hasInternet) {
      // Set User Properties
      FirebaseAnalytics().setUserProperty(name: "firstname", value: profile.firstName);
      FirebaseAnalytics().setUserProperty(name: "lastName", value: profile.lastName);
      Intercom.registerIdentifiedUser(userId: profile.sName);
      to._hasIntercom(true);

      // Check for Test Device
      if (K_TEST_NAMES.any((n) => n.toLowerCase() == ContactService.sName)) {
        to._hasMigratedSName.val = false;
        isTestDevice = true;
      }
    }
  }

  /// #### Logs a Firebase Analytics Event
  /// Adds Properties: `createdAt`, `platform`, `controller`
  static void event({
    required AnalyticsEvent event,
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
    if (isRegistered && to._hasIntercom.value && DeviceService.isMobile) {
      if (!to._intercomOpened.val) {
        to._intercomOpened.val = true;
      }
      await Intercom.displayMessenger();
    }
  }

  /// #### Sets Migration as True
  static Future<void> setMigration(HSRecord record) async {
    if (isRegistered) {
      // Set Result
      to._hasMigratedSName.val = await NamebaseClient.addRecords([record]);

      // Log Event
      Logger.event(
          event: AnalyticsEvent.user(AnalyticsUserEvent.MigratedSName, parameters: {
        "status": to._hasMigratedSName.val,
        "sName": record.name,
      }));
    }
  }
}
