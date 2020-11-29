import 'dart:ui';

import 'package:sonr_core/sonr_core.dart';
import '../../screens.dart';

part 'builder.dart';
part 'pending.dart';

class Bubble extends StatelessWidget {
  final double value;
  final Peer data;

  const Bubble(this.value, this.data) : super();
  @override
  Widget build(BuildContext context) {
    // ^ Listen to Status ^ //
    return GetBuilder<SonrController>(builder: (sonr) {
      if (sonr.currentPeer() != null) {
        if (sonr.currentPeer().id == data.id) {
          return PeerBubble(data, value);
        }
      }
      return activeBubble(value, data);
    });
  }
}

class PeerBubble extends StatelessWidget {
  final Peer data;
  final double value;

  const PeerBubble(this.data, this.value, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SonrController>(builder: (sonr) {
      if (sonr.auth().event == AuthMessage_Event.ACCEPT) {
        return acceptedBubble(value, data);
      } else if (sonr.auth().event == AuthMessage_Event.DECLINE) {
        return deniedBubble(value);
      }
      return PendingBubble(value, data);
    });
  }
}
