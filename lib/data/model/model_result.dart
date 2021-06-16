import 'dart:async';

import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/style.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';

class SaveTransferEntry {
  // Properties
  final bool success;
  final String path;
  final String id;
  SaveTransferEntry(this.success, this.path, this.id);

  static Future<SaveTransferEntry> fromAssetEntity(SonrFile_Item meta, AssetEntity entity) async {
    bool success = await entity.exists;
    return SaveTransferEntry(success, meta.path, entity.id);
  }

  /// Constructer for Default Success Result
  factory SaveTransferEntry.success() {
    return SaveTransferEntry(true, "", "");
  }

  /// Constructer for Default Success Result
  factory SaveTransferEntry.fail() {
    return SaveTransferEntry(false, "", "");
  }
}

class SaveTransferResult {
  /// Reference to List of Save Results
  final List<SaveTransferEntry> results;
  SaveTransferResult(this.results);

  /// Constructer for Default Success Result
  factory SaveTransferResult.success() {
    return SaveTransferResult([SaveTransferEntry.success()]);
  }

  /// Constructer for Default Failed Result
  factory SaveTransferResult.fail() {
    return SaveTransferResult([SaveTransferEntry.fail()]);
  }

  /// Method checks if all Items were saved
  bool get isValid {
    bool valid = true;
    this.results.forEach((r) {
      if (!r.success) {
        valid = false;
      }
    });
    return valid;
  }

  /// Method Copys Asset ID's from Results to Sonr File
  SonrFile copyAssetIds(SonrFile file) {
    var idx = 0;
    for (SonrFile_Item i in file.items) {
      if (i.mime.isMedia && this.results[idx].path == i.path) {
        i.id = this.results[idx].id;
        idx += 1;
      }
    }
    return file;
  }
}

class InternetController {
  // Properties
  final Platform platform;
  final type = Rx<ConnectivityResult>(ConnectivityResult.none);
  final isConnected = false.obs;

  // Create New Internet Connection Result
  InternetController(this.platform, {Stream<ConnectivityResult>? connStream, required bool initialConnectedValue}) {
    // Bind Conn Type for Mobile
    if (connStream != null && platform.isMobile) {
      this.type.bindStream(connStream);
    }

    // Kickstart Periodic Timer
    Timer.periodic(1.minutes, (timer) async {
      isConnected(await hasConnection());
    });
  }

  /// ### Initialize Internet Status
  static Future<InternetController> init(Platform platform) async {
    // Bind Connectivity for Mobile
    if (platform.isMobile) {
      final conn = Connectivity();
      return InternetController(
        platform,
        initialConnectedValue: await hasConnection(),
        connStream: conn.onConnectivityChanged,
      );
    }
    // Handle Desktop
    return InternetController(
      platform,
      initialConnectedValue: await hasConnection(),
    );
  }

  /// @ Method Checks Current connection
  static Future<bool> hasConnection() async {
    return await DataConnectionChecker().hasConnection;
  }

  Stream<InternetStatus> status() async* {
    while (true) {
      // Periodically Update Status
      Timer.periodic(1.minutes, (timer) async* {
        yield InternetStatusUtils.fromHandler(await hasConnection(), type.value);
      });

      // Listen to Type Changes
      type.listen((val) async* {
        yield InternetStatusUtils.fromHandler(await hasConnection(), val);
      });
    }
  }
}

enum InternetStatus { NONE, WIFI, MOBILE }

extension InternetStatusUtils on InternetStatus {
  /// Checks if InternetStatus is `InternetStatus.MOBILE`
  bool get isMobile => this == InternetStatus.MOBILE;

  /// Checks if InternetStatus is `InternetStatus.NONE`
  bool get isNone => this == InternetStatus.NONE;

  /// Checks if InternetStatus is `InternetStatus.WIFI`
  bool get isWifi => this == InternetStatus.WIFI;

  static InternetStatus fromHandler(bool connectionState, ConnectivityResult type) {
    switch (type) {
      case ConnectivityResult.wifi:
        return connectionState ? InternetStatus.WIFI : InternetStatus.NONE;
      case ConnectivityResult.mobile:
        return connectionState ? InternetStatus.MOBILE : InternetStatus.NONE;
      case ConnectivityResult.none:
        return InternetStatus.NONE;
    }
  }
}
