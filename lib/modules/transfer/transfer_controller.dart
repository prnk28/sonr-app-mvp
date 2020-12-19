import 'dart:async';

import 'package:get/get.dart';
import 'package:sonar_app/modules/peer/peer_widget.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

enum LobbyState {
  Empty,
  Active,
}

class Lobby {
  List<PeerBubble> items = <PeerBubble>[];
  int size = 0;
  LobbyState state = LobbyState.Empty;
}

class TransferController extends GetxController {
  // Properties
  final gradient = FlutterGradientNames.angelCare.obs;
  final lobby = Lobby().obs;

  // Inferred Properties
  RxDouble direction = Get.find<SonrService>().direction;

  // References
  Timer _timer;

  TransferController() {
    // Start Periodic timer to fetch Peers
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      // @ Check Length
      if (Get.find<SonrService>().peers.length > 0) {
        // Update State
        lobby.value.size = Get.find<SonrService>().peers.length;
        lobby.value.state = LobbyState.Active;

        // Add Bubbles
        Get.find<SonrService>().peers.forEach((id, peer) {
          // Add Bubbles
          _addBubble(peer);
        });
      }
      // @ Empty
      else {
        lobby.value.size = Get.find<SonrService>().peers.length;
        lobby.value.state = LobbyState.Empty;
      }
    });
  }

  // ^ Add/Update Stack Item ^ //
  _addBubble(Peer peer) {
    // Check if Item Exists
    if (!lobby.value.items.any((pb) => pb.peer.id == peer.id)) {
      lobby.value.items.add(PeerBubble(lobby.value.items.length - 1, peer));
      print("Added Bubble");
    } else {}
    lobby.value.size = lobby.value.items.length;
    lobby.refresh();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
