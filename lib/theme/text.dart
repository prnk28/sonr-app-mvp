import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color.dart';

// ^ Helper: Get Initials from Peer Data ^ //
Text initialsFromPeer(Peer peer, {Color color: Colors.white}) {
  // Get Initials
  return Text(peer.firstName[0].toUpperCase(),
      style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 32,
          color: color ?? Colors.black54));
}

// ^ Text Field Decoration ^
InputDecoration textFieldDecoration({Color setColor}) {
  return new InputDecoration(
      // Disable Line
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,

      // Input Text Style
      hintStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.normal,
          fontSize: 28,
          color: setColor ?? Colors.cyan),

      // Pad for Border
      contentPadding: const EdgeInsets.only(left: 20.0, bottom: 7.5));
}

// ^ Text Field Style ^
NeumorphicStyle textFieldStyle() {
  return NeumorphicStyle(
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(45)),
      depth: -6,
      lightSource: LightSource.topLeft,
      color: Colors.transparent);
}

// ^ Hint Text ^
Text hintText(String text, {Color setColor}) {
  return Text(text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: setColor ?? Colors.black87,
      ));
}

// ^ Hint Text ^
Text descriptionText(String text, {Color setColor}) {
  return Text(text,
      style: GoogleFonts.poppins(
          fontWeight: FontWeight.normal,
          fontSize: 24,
          color: setColor ?? Colors.black45));
}

// ^ Default Text ^ //
Text defaultText(String text) {
  return Text(text, style: GoogleFonts.poppins(color: findTextColor()));
}

// ^ Bold Text ^ //
Text boldText(String text, {double size, Color setColor}) {
  return Text(text,
      style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: size ?? 32.0,
          color: setColor ?? findTextColor()));
}

// ^ Normal Text ^ //
Text normalText(String text, {double size, Color setColor}) {
  return Text(text,
      style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: size ?? 16,
          color: setColor ?? findTextColor()));
}
