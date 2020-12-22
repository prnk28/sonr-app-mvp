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

// ^ Hint Text ^
Text descriptionText(String text, {Color setColor}) {
  return Text(text,
      style: GoogleFonts.poppins(
          fontWeight: FontWeight.normal,
          fontSize: 24,
          color: setColor ?? Colors.black45));
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

class GradientText extends StatelessWidget {
  final String text;
  final Gradient gradient;
  final TextStyle style;

  const GradientText(this.text, this.gradient, {Key key, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (bounds) => gradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
        child: Text(
          text,
          style: style,
        ));
  }
}
