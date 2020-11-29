import 'dart:ui';

import 'package:sonr_core/sonr_core.dart';
import '../../screens.dart';

part 'builder.dart';
part 'pending.dart';


getPeerBubble(double value, Peer peer, AuthMessage currentMessage) {
  if (currentMessage.event == AuthMessage_Event.ACCEPT) {
    return acceptedBubble(value, peer);
  } else if (currentMessage.event == AuthMessage_Event.DECLINE) {
    return deniedBubble(value);
  }
  return PendingBubble(value, peer);
}
