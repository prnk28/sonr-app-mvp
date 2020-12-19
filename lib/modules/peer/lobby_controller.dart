import 'package:get/get.dart';
import 'package:sonar_app/modules/peer/peer_widget.dart';
import 'package:sonar_app/service/sonr_service.dart';

class LobbyController extends GetxController {
  // Properties
  final items = <PeerBubble>[].obs;
  LobbyController() {
    // Start Periodic timer to fetch Peers
    Get.find<SonrService>().lobby.listen((lob) {
      // Add Bubbles
      lob.peers.forEach((id, peer) {
        // Check if Item Exists
        if (!items.any((pb) => pb.peer.id == peer.id)) {
          items.add(PeerBubble(items.length - 1, peer));
          print("Added Bubble");
        }

        // Refresh Items
        items.refresh();
      });
    });
  }
}
