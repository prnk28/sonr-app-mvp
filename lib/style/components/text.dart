import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:sonr_app/style/style.dart';

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
        return Triple("Montserrat", FontWeight.w900, 72);
      case DisplayTextStyle.Heading:
        return Triple("Montserrat", FontWeight.w700, 32);
      case DisplayTextStyle.Section:
        return Triple("Montserrat", FontWeight.w700, 26);
      case DisplayTextStyle.Subheading:
        return Triple("Montserrat", FontWeight.w500, 26);
      case DisplayTextStyle.Paragraph:
        return Triple("Montserrat", FontWeight.w100, 18);
      case DisplayTextStyle.Light:
        return Triple("Montserrat", FontWeight.w300, 18);
    }
  }

  /// Retreive Font Family
  String get fontFamily => _defaultParams.item1;

  /// Retreive Font Family
  FontWeight get fontWeight => _defaultParams.item2;

  /// Retreive Font Size
  double get fontSize => _defaultParams.item3;

  /// Build Text Style for this Type
  TextStyle style({
    Color? color,
    double? fontSize,
    FontStyle fontStyle = FontStyle.normal,
  }) =>
      TextStyle(
        fontStyle: fontStyle,
        fontFamily: this.fontFamily,
        fontWeight: this.fontWeight,
        fontSize: fontSize ?? this.fontSize,
        color: color ?? AppTheme.ItemColor,
        fontFeatures: [
          FontFeature.tabularFigures(),
        ],
      );
}

extension TextSpanListUtils on List<TextSpan> {
  /// Converts this List of `TextSpan` into a `RichText` Widget
  RichText rich({
    Key? key,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    bool softWrap = true,
    TextOverflow overflow = TextOverflow.clip,
    double textScaleFactor = 1.0,
    int? maxLines,
    Locale? locale,
    StrutStyle? strutStyle,
    TextWidthBasis textWidthBasis = TextWidthBasis.parent,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return RichText(
      text: TextSpan(children: this),
      key: key,
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}

extension DisplayTextUtils on String {
  /// Hero
  DisplayText hero({
    Color color = AppColor.White,
    TextAlign align = TextAlign.start,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      DisplayText(this, DisplayTextStyle.Hero, align, color, fontSize, fontStyle);

  /// Heading - Default Size = 32, FontWeight.w700
  DisplayText heading({
    Color color = AppColor.Black,
    TextAlign align = TextAlign.start,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      DisplayText(this, DisplayTextStyle.Heading, align, color, fontSize, fontStyle);

  /// Heading **Span** - Default Size = 32, FontWeight.w700
  TextSpan headingSpan({
    Color color = AppColor.Black,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      TextSpan(
        text: this,
        style: DisplayTextStyle.Heading.style(color: color, fontSize: fontSize, fontStyle: fontStyle),
      );

  /// Subheading - Default Size = 26, FontWeight.w500
  DisplayText subheading({
    Color color = AppColor.Black,
    TextAlign align = TextAlign.start,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      DisplayText(this, DisplayTextStyle.Subheading, align, color, fontSize, fontStyle);

  /// Subheading **Span** - Default Size = 26, FontWeight.w500
  TextSpan subheadingSpan({
    Color color = AppColor.Black,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      TextSpan(
        text: this,
        style: DisplayTextStyle.Subheading.style(color: color, fontSize: fontSize, fontStyle: fontStyle),
      );

  /// Section - Default Size = 20, FontWeight.w700
  DisplayText section({
    Color color = AppColor.Black,
    TextAlign align = TextAlign.start,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      DisplayText(this, DisplayTextStyle.Section, align, color, fontSize, fontStyle);

  /// Section **Span** - Default Size = 20, FontWeight.w700
  TextSpan sectionSpan({
    Color color = AppColor.Black,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      TextSpan(
        text: this,
        style: DisplayTextStyle.Section.style(color: color, fontSize: fontSize, fontStyle: fontStyle),
      );

  /// Paragraph - Default Size = 20, FontWeight.w100
  DisplayText paragraph({
    Color color = AppColor.Black,
    TextAlign align = TextAlign.start,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      DisplayText(this, DisplayTextStyle.Paragraph, align, color, fontSize, fontStyle);

  /// Paragraph **Span** - Default Size = 20, FontWeight.w100
  TextSpan paragraphSpan({
    Color color = AppColor.Black,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      TextSpan(
        text: this,
        style: DisplayTextStyle.Paragraph.style(color: color, fontSize: fontSize, fontStyle: fontStyle),
      );

  /// Light - Default Size = 20,  FontWeight.w300
  DisplayText light({
    Color color = AppColor.Black,
    TextAlign align = TextAlign.start,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      DisplayText(this, DisplayTextStyle.Light, align, color, fontSize, fontStyle);

  /// Light **Span** - Default Size = 20, FontWeight.w300
  TextSpan lightSpan({
    Color color = AppColor.Black,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
  }) =>
      TextSpan(
        text: this,
        style: DisplayTextStyle.Light.style(color: color, fontSize: fontSize, fontStyle: fontStyle),
      );

  /// Gradient Style Text
  GradientText gradient({double size = 32, required Gradient value, Key? key}) => GradientText(this, value, size, key: key);

  /// Retreives Size of Painted Text
  Size size(DisplayTextStyle style, {double fontSize = 20}) {
    final TextPainter textPainter =
        TextPainter(text: TextSpan(text: this, style: style.style(fontSize: fontSize)), maxLines: 1, textDirection: TextDirection.ltr)
          ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  /// URL Style Text
  URLText get url => URLText(this);
}

class DateText extends StatelessWidget {
  final DateTime date;
  final Color? color;
  final double fontSize;
  final FontStyle fontStyle;
  final DisplayTextStyle textStyle;

  factory DateText.fromMilliseconds(
    int date, {
    Color? color,
    double fontSize = 16,
    FontStyle fontStyle = FontStyle.normal,
    DisplayTextStyle textStyle = DisplayTextStyle.Paragraph,
  }) {
    return DateText(
      date: DateTime.fromMillisecondsSinceEpoch(date),
      color: color,
      fontSize: fontSize,
      fontStyle: fontStyle,
      textStyle: textStyle,
    );
  }

  const DateText({
    Key? key,
    required this.date,
    this.color,
    this.fontSize = 16,
    this.fontStyle = FontStyle.normal,
    this.textStyle = DisplayTextStyle.Paragraph,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _buildDateTime(),
      style: textStyle.style(
        color: color,
        fontSize: fontSize,
        fontStyle: fontStyle,
      ),
    );
  }

  String _buildDateTime() {
    final dateFormatter = intl.DateFormat.yMMMd('en_US').add_jm();
    return dateFormatter.format(date);
  }
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
            shaderCallback: (bounds) => DesignGradients.CrystalRiver.createShader(
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
    return Text(text,
        overflow: TextOverflow.visible,
        textAlign: align,
        style: style.style(
          fontSize: fontSize,
          fontStyle: fontStyle,
          color: color,
        ));
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

    return [host.lightSpan(fontSize: 16), directories > 0 ? path.subheadingSpan(fontSize: 16) : "".subheadingSpan()].rich();
  }

  String replaceAt(int index, String newChar, String oldStr) {
    return oldStr.substring(0, index) + newChar + oldStr.substring(index + 1);
  }
}
