import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ Get Initials from Peer Data ^ //
Text initialsFromPeer(Peer peer, {Color color: Colors.white}) {
  // Get Initials
  return Text(peer.firstName[0].toUpperCase(),
      style: TextStyle(
          fontFamily: "Raleway",
          fontWeight: FontWeight.bold,
          fontSize: 32,
          color: color ?? Colors.black54));
}

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

// ^ Find Icons color based on Theme - Light/Dark ^
Color findIconsColor(BuildContext context) {
  final theme = NeumorphicTheme.of(context);
  if (theme.isUsingDark) {
    return theme.current.accentColor;
  } else {
    return null;
  }
}

// ^ Find Text color based on Theme - Light/Dark ^
Color findTextColor(BuildContext context) {
  final theme = NeumorphicTheme.of(context);
  if (theme.isUsingDark) {
    return Colors.white;
  } else {
    return Colors.black;
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
