export 'views/card_view.dart';
export 'views/bubble_view.dart';
export 'views/item_view.dart';
export 'views/linker_view.dart';
export 'data/peer_controller.dart';
export 'data/profile_utils.dart';
export 'data/session_utils.dart';

import 'views/linker_view.dart';
import 'views/card_view.dart';
import 'views/item_view.dart';
import 'views/bubble_view.dart';

import 'package:sonr_app/style/style.dart';

class PeerItem {
  static Widget bubble(Member member) {
    return PeerBubbleView(member);
  }

  static Widget card(Member member) {
    return PeerCardView(member);
  }

  static Widget list({required Member member, required int index}) {
    return PeerListItem(member: member, index: index);
  }

  static Widget linker(Peer peer, {required Function onPressed}) {
    return PeerLinkerItem(peer: peer, onPressed: onPressed);
  }
}
