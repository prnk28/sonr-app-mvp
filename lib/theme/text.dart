import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:google_fonts/google_fonts.dart';

class SonrText extends StatelessWidget {
  final String text;
  final Color color;
  final Gradient gradient;
  final FontWeight weight;
  final double size;
  final bool isGradient;

  const SonrText(this.text, this.isGradient,
      {Key key, this.color, this.gradient, this.weight, this.size})
      : super(key: key);

  // ** Normal ** //
  // ^ Gradient Text with Provided Data
  factory SonrText.initials(Peer peer,
      {Color color, FontWeight weight, double size, Key key}) {
    return SonrText(peer.firstName[0].toUpperCase(), false,
        weight: FontWeight.bold,
        size: size ?? 32,
        key: key,
        color: color ?? Colors.white);
  }

  // ^ Gradient Text with Provided Data
  factory SonrText.normal(String text, {Color color, double size, Key key}) {
    return SonrText(text, false,
        weight: FontWeight.w500,
        size: size ?? 16,
        key: key,
        color: color ?? Colors.black);
  }

  // ^ Gradient Text with Provided Data
  factory SonrText.bold(String text, {Color color, double size, Key key}) {
    return SonrText(text, false,
        weight: FontWeight.bold,
        size: size ?? 32,
        key: key,
        color: color ?? Colors.black);
  }

  // ^ Gradient Text with Provided Data
  factory SonrText.description(String text,
      {Color color, double size, Key key}) {
    return SonrText(text, false,
        weight: FontWeight.bold,
        size: size ?? 24,
        key: key,
        color: color ?? Colors.grey[800]);
  }

  // ^ Gradient Text with Provided Data
  factory SonrText.header(String text, {Color color, double size, Key key}) {
    return SonrText(text, false,
        weight: FontWeight.w800,
        size: size ?? 108,
        key: key,
        color: color ?? Colors.white);
  }

  // ** Gradient ** //
  factory SonrText.gradient(String text, FlutterGradientNames gradient,
      {Color color, FontWeight weight, double size, Key key}) {
    return SonrText(text, true,
        weight: FontWeight.bold,
        size: size ?? 32,
        key: key,
        gradient: FlutterGradients.findByName(gradient));
  }

  @override
  Widget build(BuildContext context) {
    // @ Generate Style
    var style = GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: size ?? 32.0,
        color: color ?? _findTextColor());

    // @ Gradient Type Text
    if (isGradient) {
      return ShaderMask(
          shaderCallback: (bounds) => gradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
          child: Text(
            text,
            style: style,
          ));
    }

    // @ Normal Type Text
    else {
      return Text(text,
          style: GoogleFonts.poppins(
              fontWeight: weight,
              fontSize: size ?? 16,
              color: color ?? _findTextColor()));
    }
  }

  // ^ Find Text color based on Theme - Light/Dark ^
  Color _findTextColor() {
    if (Get.isDarkMode) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}

// ^ Builds Neumorphic Text Field ^ //
class SonrTextField extends StatefulWidget {
  final String label;
  final String hint;
  final String value;

  final ValueChanged<String> onChanged;
  final Function onEditingComplete;

  SonrTextField(
      {@required this.label,
      @required this.hint,
      @required this.value,
      this.onChanged,
      this.onEditingComplete});

  @override
  _SonrTextFieldState createState() => _SonrTextFieldState();
}

class _SonrTextFieldState extends State<SonrTextField> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            this.widget.label,
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
            onEditingComplete: () {
              this.widget.onEditingComplete();
            },
            onChanged: (value) {
              this.widget.onChanged(value);
            },
            controller: _controller,
            decoration: InputDecoration.collapsed(
                hintText: this.widget.hint,
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }
}
