import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'icon.dart';

class SonrText extends StatelessWidget {
  final String text;
  final Color color;
  final Gradient gradient;
  final FontWeight weight;
  final RichText richText;
  final double size;
  final bool isGradient;
  final bool isRich;
  final bool isCentered;

  const SonrText(this.text,
      {Key key,
      this.isGradient = false,
      this.isRich = false,
      this.isCentered = false,
      this.color,
      this.gradient,
      this.richText,
      this.weight,
      this.size})
      : super(key: key);

  // ^ Normal Text with Provided Data
  factory SonrText.normal(String text, {Color color, double size, Key key}) {
    return SonrText(text, weight: FontWeight.w500, size: size ?? 16, key: key, color: color ?? Colors.black);
  }

  // ^ Bold Text with Provided Data
  factory SonrText.bold(String text, {Color color, double size, Key key}) {
    return SonrText(text, weight: FontWeight.bold, size: size ?? 32, key: key, color: color ?? Colors.black);
  }

  // ^ Description Text with Provided Data
  factory SonrText.description(String text, {Color color, double size, Key key}) {
    return SonrText(text, weight: FontWeight.bold, size: size ?? 24, key: key, color: color ?? Colors.grey);
  }

  // ^ Date Text with Provided Data
  factory SonrText.date(DateTime date, {Color color, double size, Key key}) {
    // Formatters
    final dateFormat = new DateFormat.yMd();
    final timeFormat = new DateFormat.jm();

    // Get String
    String dateText = dateFormat.format(date);
    String timeText = timeFormat.format(date);

    return SonrText("",
        isRich: true,
        richText: RichText(
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            text: TextSpan(children: [
              TextSpan(text: dateText, style: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 14, color: Colors.black)),
              TextSpan(text: "  $timeText", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black)),
            ])));
  }

  // ^ Header Text with Provided Data
  factory SonrText.header(String text, {FlutterGradientNames gradient = FlutterGradientNames.viciousStance, double size, Key key}) {
    return SonrText(
      text,
      isGradient: true,
      isCentered: true,
      weight: FontWeight.w800,
      size: size ?? 40,
      key: key,
      gradient: FlutterGradients.findByName(gradient),
    );
  }

  // ^ Gradient Text with Provided Data
  factory SonrText.gradient(String text, FlutterGradientNames gradient, {Color color, FontWeight weight, double size, Key key}) {
    return SonrText(text, isGradient: true, weight: FontWeight.bold, size: size ?? 40, key: key, gradient: FlutterGradients.findByName(gradient));
  }

  // ^ AppBar Text with Provided Data
  factory SonrText.appBar(String text, {Color color, double size, FlutterGradientNames gradient = FlutterGradientNames.premiumDark, Key key}) {
    return SonrText(
      text,
      isGradient: true,
      weight: FontWeight.w600,
      size: size ?? 30,
      key: key,
      gradient: FlutterGradients.findByName(gradient),
    );
  }

  // ^ Gradient Text with Provided Data
  factory SonrText.initials(Peer peer,
      {Color color, FlutterGradientNames gradient = FlutterGradientNames.glassWater, FontWeight weight, double size, Key key}) {
    return SonrText(peer.profile.firstName[0].toUpperCase(),
        isGradient: true, weight: FontWeight.bold, size: size ?? 36, key: key, gradient: FlutterGradients.findByName(gradient));
  }

  // ^ Rich Text with FirstName and Invite
  factory SonrText.invite(String type, String firstName) {
    return SonrText("",
        isRich: true,
        richText: RichText(
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            text: TextSpan(children: [
              TextSpan(text: type.capitalizeFirst, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 26, color: Colors.black)),
              TextSpan(
                  text: " from ${firstName.capitalizeFirst}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, fontSize: 22, color: Colors.blue[900])),
            ])));
  }

  // ^ Rich Text with Provided Data as URL
  factory SonrText.url(String text) {
    // Initialize
    Uri uri = Uri.parse(text);
    int segmentCount = uri.pathSegments.length;
    String host = uri.host;
    String path = "/";

    // Check host for Sub
    if (host.contains("mobile")) {
      host = host.substring(5);
      replaceCharAt(host, 0, "m");
    }

    // Create Path
    int directories = 0;
    for (int i = 0; i <= segmentCount - 1; i++) {
      // Check if final Segment
      if (i == segmentCount - 1) {
        directories > 0 ? path += path += "/${uri.pathSegments[i]}" : path += uri.pathSegments[i];
      } else {
        directories += 1;
        path += ".";
      }
    }

    // Return With Rich Text
    return SonrText(text,
        isRich: true,
        richText: RichText(
            overflow: TextOverflow.fade,
            text: TextSpan(children: [
              TextSpan(
                  text: host,
                  style: GoogleFonts.poppins(
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.dotted,
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.blueGrey[300])),
              TextSpan(
                  text: path,
                  style: GoogleFonts.poppins(
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.dotted,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.blue[600])),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    // @ Gradient Type Text
    if (isGradient) {
      return Center(
        child: ShaderMask(
            shaderCallback: (bounds) => gradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              textAlign: isCentered ? TextAlign.center : TextAlign.start,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: size ?? 32.0, color: Colors.white),
            )),
      );
    }

    // @ Rich Type Text
    if (isRich) {
      return richText;
    }

    // @ Normal Type Text
    return Text(text, style: GoogleFonts.poppins(fontWeight: weight, fontSize: size ?? 16, color: color ?? findTextColor()));
  }

  // ^ Find Text color based on Theme - Light/Dark ^
  static Color findTextColor() {
    if (Get.isDarkMode) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  // ^ Replace Character in given String with given Index ^
  static String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
  }

  // ^ Convert a Size in Bytes to Text String ^
  static String convertSizeToText(int size) {
    // @ Less than 1KB
    if (size < pow(10, 3)) {
      return "$size B";
    }
    // @ Less than 1MB
    else if (size >= pow(10, 3) && size < pow(10, 6)) {
      // Adjust Size Value, Return String
      var adjusted = size / pow(10, 3);
      return "${double.parse((adjusted).toStringAsFixed(2))} KB";
    }
    // @ Less than 1GB
    else if (size >= pow(10, 6) && size < pow(10, 9)) {
      // Adjust Size Value, Return String
      var adjusted = size / pow(10, 6);
      return "${double.parse((adjusted).toStringAsFixed(2))} MB";
    }
    // @ Greater than GB
    else {
      // Adjust Size Value, Return String
      var adjusted = size / pow(10, 9);
      return "${double.parse((adjusted).toStringAsFixed(2))} GB";
    }
  }

  // ^ Convert a Boolean Value to English Text String ^
  static String convertBoolToText(bool val) {
    if (val) {
      return "YES";
    } else {
      return "NO";
    }
  }
}

// ^ Builds Neumorphic Text Field ^ //
class SonrTextField extends StatelessWidget {
  final String label;
  final String hint;
  final String value;
  final FocusNode focusNode;
  final bool autoFocus;
  final bool autoCorrect;
  final TextCapitalization textCapitalization;

  final ValueChanged<String> onChanged;
  final Function onEditingComplete;

  SonrTextField(
      {@required this.label,
      @required this.hint,
      @required this.value,
      this.onChanged,
      this.focusNode,
      this.onEditingComplete,
      this.autoFocus = false,
      this.autoCorrect = true,
      this.textCapitalization = TextCapitalization.none});

  @override
  Widget build(BuildContext context) {
    return ValueBuilder<String>(
      initialValue: value,
      builder: (value, updateFn) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: NeumorphicTheme.defaultTextColor(context),
                ),
              ),
            ),
            Neumorphic(
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
              style: NeumorphicStyle(
                depth: NeumorphicTheme.embossDepth(context),
                boxShape: NeumorphicBoxShape.stadium(),
              ),
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              child: TextField(
                autofocus: autoFocus,
                autocorrect: autoCorrect,
                textCapitalization: textCapitalization,
                focusNode: focusNode,
                onEditingComplete: onEditingComplete,
                onChanged: updateFn,
                decoration: InputDecoration.collapsed(hintText: hint, hintStyle: TextStyle(color: Colors.black38)),
              ),
            )
          ],
        );
      },
      onUpdate: onChanged,
    );
  }
}

// ^ Builds Neumorphic Text Field for Search ^ //
class SonrSearchField extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final Function onEditingComplete;
  final Iterable<String> autofillHints;

  SonrSearchField({
    @required this.value,
    this.onChanged,
    this.onEditingComplete,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return ValueBuilder<String>(
      initialValue: value,
      builder: (value, updateFn) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Neumorphic(
                margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
                style: NeumorphicStyle(
                  depth: NeumorphicTheme.embossDepth(context),
                  boxShape: NeumorphicBoxShape.stadium(),
                ),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                child: Row(children: [
                  SonrIcon.gradient(Icons.search, FlutterGradientNames.amourAmour, size: 28),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: TextField(
                        autofillHints: autofillHints,
                        autofocus: true,
                        onEditingComplete: onEditingComplete,
                        onChanged: updateFn,
                        decoration: InputDecoration.collapsed(hintText: "Search...", hintStyle: TextStyle(color: Colors.black38)),
                      ),
                    ),
                  ),
                ]))
          ],
        );
      },
      onUpdate: onChanged,
    );
  }
}
