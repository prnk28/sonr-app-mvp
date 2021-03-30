import 'dart:async';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/modules/home/home_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

class LobbyService extends GetxService {
  // @ Set Properties
  final _isReady = false.obs;
  final _lobbies = RxMap<String, Lobby>();
  final _local = Rx<Lobby>();
  final _localSize = 0.obs;

  // @ Static Accessors
  static RxBool get isReady => Get.find<LobbyService>()._isReady;
  static RxMap<String, Lobby> get lobbies => Get.find<LobbyService>()._lobbies;
  static Rx<Lobby> get local => Get.find<LobbyService>()._local;
  static RxInt get localSize => Get.find<LobbyService>()._localSize;

  // ^ Initialize Service Method ^ //
  Future<LobbyService> init() async {
    return this;
  }

  // ^ Handle Lobby Update ^ //
  void handleRefresh(Lobby data) {
    // @ Update Local Topics
    if (data.isLocal) {
      // Update Local
      _local(data);
      _localSize(data.size);
      _local.refresh();
    }

    // @ Update Other Topics
    else {
      _lobbies[data.name] = data;
      _lobbies.refresh();
    }
  }
}
