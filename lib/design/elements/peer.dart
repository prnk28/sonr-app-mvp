part of 'elements.dart';

NeumorphicIcon iconFromPeer(Peer peer, {double size = 30}) {
  if (peer.device.platform == "Android") {
    return NeumorphicIcon((Icons.android),
        size: size, style: NeumorphicStyle(color: Colors.green[200]));
  } else if (peer.device.platform == "iOS") {
    return NeumorphicIcon((Icons.phone_iphone),
        size: size, style: NeumorphicStyle(color: Colors.grey[500]));
  } else {
    return NeumorphicIcon((Icons.device_unknown), size: size);
  }
}

Text initialsFromPeer(Peer peer) {
  // Get Initials
  return Text(peer.firstName[0].toUpperCase() + peer.lastName[0].toUpperCase(),
      style: mediumTextStyle());
}