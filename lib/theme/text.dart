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



