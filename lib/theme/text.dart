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

// ^ Builds Neumorphic Text Field ^ //
class NeuomorphicTextField extends StatefulWidget {
  final String label;
  final String hint;

  final ValueChanged<String> onChanged;
  final Function onEditingComplete;

  NeuomorphicTextField(
      {@required this.label,
      @required this.hint,
      this.onChanged,
      this.onEditingComplete});

  @override
  _NeuomorphicTextFieldState createState() => _NeuomorphicTextFieldState();
}

class _NeuomorphicTextFieldState extends State<NeuomorphicTextField> {
  TextEditingController _controller;
  String get text => _controller.value.text;

  @override
  void initState() {
    _controller = TextEditingController(text: text);
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
            onChanged: this.widget.onChanged,
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
