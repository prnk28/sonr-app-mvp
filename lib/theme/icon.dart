import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ Get Icon from Peer Data ^ //
NeumorphicIcon iconFromPeer(Peer peer,
    {double size = 30, Color color: Colors.white}) {
  if (peer.device.platform == "Android") {
    return NeumorphicIcon((Icons.android),
        size: size, style: NeumorphicStyle(color: color));
  } else if (peer.device.platform == "iOS") {
    return NeumorphicIcon((Icons.phone_iphone),
        size: size, style: NeumorphicStyle(color: color));
  } else {
    return NeumorphicIcon((Icons.device_unknown), size: size);
  }
}

// ^ Get Icon from Payload Data^ //
IconData iconDataFromPayload(Payload payload) {
  var kind = payload.file.mime.type;
  switch (kind) {
    case MIME_Type.audio:
      return Icons.audiotrack;
      break;
    case MIME_Type.image:
      return Icons.image;
      break;
    case MIME_Type.video:
      return Icons.video_collection;
      break;
    case MIME_Type.text:
      return Icons.sort_by_alpha;
      break;
    default:
      return Icons.device_unknown;
      break;
  }
}
