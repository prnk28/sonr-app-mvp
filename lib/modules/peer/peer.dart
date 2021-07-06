export 'views/card_view.dart';
export 'views/bubble_view.dart';
export 'views/item_view.dart';
export 'data/peer_controller.dart';
export 'data/profile_utils.dart';

import 'package:sonr_app/style/style.dart';
import 'views/card_view.dart';
import 'views/item_view.dart';
import 'views/bubble_view.dart';

class PeerItem {
  static Widget bubble(Peer peer) {
    return PeerBubbleView(peer);
  }

  static Widget card(Peer peer) {
    return PeerCardView(peer);
  }

  static Widget list({required Peer peer, required int index}) {
    return PeerListItem(peer: peer, index: index);
  }
}
