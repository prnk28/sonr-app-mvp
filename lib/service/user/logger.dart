import 'dart:async';
import 'package:get/get.dart';
import 'package:sonr_app/style.dart';
import 'package:logger/logger.dart' as util;

class Logger extends GetxService {
  // Service Accessors
  static bool get isRegistered => Get.isRegistered<Logger>();
  static Logger get to => Get.find<Logger>();

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
    return this;
  }

  /// @ Prints Debug Log
  static void debug(dynamic m) {
    if (buildMode.isDebug) {
      to._log.d(m);
    }
  }

  /// @ Prints Info Log
  static void info(dynamic m) {
    if (buildMode.isDebug) {
      to._log.i(m);
    }
  }

  /// @ Prints Warn Log
  static void warn(dynamic m) {
    if (buildMode.isDebug) {
      to._log.w(m);
    }
  }

  /// @ Prints Error Log
  static void error(dynamic m) {
    if (buildMode.isDebug) {
      to._log.e(m);
    }
  }

  /// @ Prints Sonr ErrorMessage Log
  static void sError(ErrorMessage m) {
    if (buildMode.isDebug) {
      to._log.wtf("Node(Callback) Error: " + m.message);
    }
  }

}
