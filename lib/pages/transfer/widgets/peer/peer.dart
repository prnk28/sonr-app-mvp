export '../../controllers/peer_controller.dart';
import 'package:sonr_app/style.dart';

import 'card_view.dart';
import 'item_view.dart';

class PeerItem {
  static Widget card(Peer peer) {
    return PeerCard(peer);
  }

  static Widget list({required Peer peer, required int index}) {
    return PeerListItem(peer: peer, index: index);
  }
}
