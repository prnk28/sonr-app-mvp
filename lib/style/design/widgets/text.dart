import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:sonr_app/style.dart';

enum DisplayTextStyle {
  /// AlongSans Hero
  Hero,

  /// RFlex Bold
  Heading,

  /// RFlex Regular
  Subheading,

  /// RFlex Bold - Size 26
  Section,

  /// RFlex Thin
  Paragraph,

  /// RFlex Light
  Light,
}

extension DisplayTextStyleUtils on DisplayTextStyle {
  /// Return Font Size for Type
  Triple<String, FontWeight, double> get _defaultParams {
    switch (this) {
      case DisplayTextStyle.Hero:
        return Triple("AlongSans", FontWeight.w800, 72);
      case DisplayTextStyle.Heading:
        return Triple("RFlex", FontWeight.w700, 32);
      case DisplayTextStyle.Section:
        return Triple("RFlex", FontWeight.w700, 26);
      case DisplayTextStyle.Subheading:
        return Triple("RFlex", FontWeight.w500, 26);
      case DisplayTextStyle.Paragraph:
        return Triple("RFlex", FontWeight.w100, 20);
      case DisplayTextStyle.Light:
        return Triple("RFlex", FontWeight.w300, 20);
    }
  }

  /// Retreive Font Family
  String get fontFamily => _defaultParams.item1;

  /// Retreive Font Family
  FontWeight get fontWeight => _defaultParams.item2;

  /// Retreive Font Size
  double get fontSize => _defaultParams.item3;
}

extension DisplayTextUtils on String {
  /// Hero
  DisplayText hero({
    Color color = SonrColor.Black,
    TextAlign align = TextAlign.start,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      DisplayText(this, DisplayTextStyle.Hero, align, color, fontSize, fontStyle);

  /// Heading - Default Size = 32
  DisplayText heading({
    Color color = SonrColor.Black,
    TextAlign align = TextAlign.start,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      DisplayText(this, DisplayTextStyle.Heading, align, color, fontSize, fontStyle);

  /// Subheading - Default Size = 26
  DisplayText subheading({
    Color color = SonrColor.Black,
    TextAlign align = TextAlign.start,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      DisplayText(this, DisplayTextStyle.Section, align, color, fontSize, fontStyle);

  /// Heading - Default Size = 26
  DisplayText section({
    Color color = SonrColor.Black,
    TextAlign align = TextAlign.start,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      DisplayText(this, DisplayTextStyle.Heading, align, color, fontSize, fontStyle);

  /// Paragraph - Default Size = 20
  DisplayText paragraph({
    Color color = SonrColor.Black,
    TextAlign align = TextAlign.start,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      DisplayText(this, DisplayTextStyle.Paragraph, align, color, fontSize, fontStyle);

  /// Paragraph - Default Size = 20
  DisplayText light({
    Color color = SonrColor.Black,
    TextAlign align = TextAlign.start,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      DisplayText(this, DisplayTextStyle.Light, align, color, fontSize, fontStyle);

  /// Gradient Style Text
  GradientText gradient({double size = 32, required Gradient value, Key? key}) => GradientText(this, value, size, key: key);

  /// URL Style Text
  URLText get url => URLText(this);
}

class DisplayText extends StatelessWidget {
  final String text;
  final DisplayTextStyle style;
  final TextAlign align;
  final Color color;
  final FontStyle fontStyle;
  final double? fontSize;

  const DisplayText(
    this.text,
    this.style,
    this.align,
    this.color,
    this.fontSize,
    this.fontStyle, {
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // # Gradient Text
    if (style == DisplayTextStyle.Hero) {
      return Center(
        child: ShaderMask(
            shaderCallback: (bounds) => SonrGradients.CrystalRiver.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
            child: _buildText(context, TextAlign.center)),
      );
    }

    // # Normal Text
    return _buildText(context, align);
  }

  // @ Builds Text Widget
  Text _buildText(BuildContext context, TextAlign align) {
    return Text(
      text,
      overflow: TextOverflow.visible,
      textAlign: align,
      style: TextStyle(
        fontStyle: fontStyle,
        fontFamily: style.fontFamily,
        fontWeight: style.fontWeight,
        fontSize: fontSize ?? style.fontSize,
        color: color,
        fontFeatures: [
          FontFeature.tabularFigures(),
        ],
      ),
    );
  }
}

/// ## Gradient Text Type
class GradientText extends StatelessWidget {
  final String text;
  final Gradient gradient;
  final double size;

  const GradientText(this.text, this.gradient, this.size, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShaderMask(
          shaderCallback: (bounds) => gradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
          child: Text(
            text,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Manrope",
              fontWeight: FontWeight.w800,
              fontSize: size,
              color: Colors.white,
              fontFeatures: [
                FontFeature.tabularFigures(),
              ],
            ),
          )),
    );
  }
}

/// ## URL Text Type
class URLText extends StatelessWidget {
  final String url;
  const URLText(this.url, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Parse URL
    Uri uri = Uri.parse(url);
    int segmentCount = uri.pathSegments.length;
    var host = uri.host;
    var path = "/";

    // Check host for Sub
    if (host.contains("mobile")) {
      host = host.substring(5);
      replaceAt(0, "m", host);
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

    // Return Text Spans
    var spans = [
      TextSpan(
          text: host,
          style: TextStyle(
              fontFamily: 'Manrope',
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted,
              fontWeight: FontWeight.w300,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.blueGrey[300])),
      TextSpan(
          text: directories > 0 ? path : "",
          style: TextStyle(
              fontFamily: 'Manrope',
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.blue[600]))
    ];

    return RichText(
      overflow: TextOverflow.fade,
      text: TextSpan(children: spans),
    );
  }

  String replaceAt(int index, String newChar, String oldStr) {
    return oldStr.substring(0, index) + newChar + oldStr.substring(index + 1);
  }
}
