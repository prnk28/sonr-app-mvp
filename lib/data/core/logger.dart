import 'dart:async';
import 'package:firebase_analytics/observer.dart';
import 'package:get/get.dart';
import 'package:sonr_app/style.dart';
import 'package:logger/logger.dart' as util;
import 'package:firebase_analytics/firebase_analytics.dart';

class Logger extends GetxService {
  // Service Accessors
  static bool get isRegistered => Get.isRegistered<Logger>();
  static Logger get to => Get.find<Logger>();

  // References
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver get Observer => FirebaseAnalyticsObserver(analytics: analytics);

  // Properties
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

  // References
  static final BuildMode buildMode = BuildModeUtil.current();

  // * Initializes Logger * //
  Future<Logger> init() async {
    // Configure Firebase Scope
    FirebaseAnalytics().setUserId(DeviceService.device.id);
    FirebaseAnalytics().setUserProperty(name: "platform", value: DeviceService.device.platform.toString());
    return this;
  }

  /// @ Initializes Profile for Analytics
  static void initProfile(Profile profile) {
    if (isRegistered && DeviceService.isMobile) {
      // Set User Properties
      FirebaseAnalytics().setUserProperty(name: "firstname", value: profile.firstName);
      FirebaseAnalytics().setUserProperty(name: "lastName", value: profile.lastName);
    }
  }

  /// @ Logs a Firebase Analytics Event
  /// Adds Properties: `createdAt`, `platform`, `controller`
  static void event({
    required String name,
    required String controller,
    Map<String, Object?>? parameters,
  }) async {
    if (isRegistered && DeviceService.isMobile) {
      // Check Paramaters
      var map = <String, Object?>{};
      if (parameters != null) {
        map.addAll(parameters);
      }

      // Add Essential Parameters
      map["controller"] = controller;
      map["createdAt"] = DateTime.now().toString();
      map["platform"] = DeviceService.device.platform.toString();

      // Log Event
      FirebaseAnalytics().logEvent(
        name: name,
        parameters: map,
      );
    }
  }

  /// @ Prints Debug Log
  static void debug(dynamic m) {
    if (buildMode.isDebug && isRegistered) {
      to._log.d(m);
    }
  }

  /// @ Prints Info Log
  static void info(dynamic m) {
    if (buildMode.isDebug && isRegistered) {
      to._log.i(m);
    }
  }

  /// @ Prints Warn Log
  static void warn(dynamic m) {
    if (buildMode.isDebug && isRegistered) {
      to._log.w(m);
    }
  }

  /// @ Prints Error Log
  static void error(dynamic m) {
    if (buildMode.isDebug && isRegistered) {
      to._log.e(m);
    }
  }

  /// @ Prints Sonr ErrorMessage Log
  static void sError(ErrorMessage m) {
    if (buildMode.isDebug && isRegistered) {
      to._log.wtf("Node(Callback) Error: " + m.message);
    }
  }
}
