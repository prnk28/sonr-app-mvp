import 'dart:ui';

import 'package:sonr_core/sonr_core.dart';
import '../../screens.dart';

part 'builder.dart';
part 'pending.dart';

class Bubble extends StatelessWidget {
  final double value;
  final Peer data;
  final AuthMessage currentMessage;
  const Bubble(this.value, this.data, this.currentMessage) : super();
  @override
  Widget build(BuildContext context) {
    if (currentMessage != null) {
      if (currentMessage.from.id == data.id) {
        return PeerBubble(data, value, currentMessage);
      }
    }
    return activeBubble(value, data);
  }
}

class PeerBubble extends StatelessWidget {
  final Peer data;
  final double value;
  final AuthMessage currentMessage;
  const PeerBubble(this.data, this.value, this.currentMessage) : super();
  @override
  Widget build(BuildContext context) {
    if (currentMessage.event == AuthMessage_Event.ACCEPT) {
      return acceptedBubble(value, data);
    } else if (currentMessage.event == AuthMessage_Event.DECLINE) {
      return deniedBubble(value);
    }
    return PendingBubble(value, data);
  }
}
