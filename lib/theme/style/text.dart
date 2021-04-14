import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'icon.dart';
import 'package:sonr_app/theme/theme.dart' hide Platform;
import 'package:sonr_app/data/data.dart';

// ^ Design Style Type ^ //
enum DesignTextStyle {
  Hero,
  HeadOne,
  HeadTwo,
  HeadThree,
  HeadFour,
  HeadFive,
  HeadSix,
  Paragraph,
  Light,
}

// ^ Accessor for Strings ^ //
extension DesignTextUtils on String {
  // Hero: Gradient
  DesignText get hero => DesignText(this, DesignTextStyle.Hero, color: Colors.white);

  // Heading 1: Gradient
  DesignText get h1 => DesignText(this, DesignTextStyle.HeadOne, color: Colors.white);

  // Heading 2
  DesignText get h2 => DesignText(this, DesignTextStyle.HeadTwo, color: SonrColor.Black);
  DesignText get h2_Blue => DesignText(this, DesignTextStyle.HeadTwo, color: SonrPalette.Primary);
  DesignText get h2_Green => DesignText(this, DesignTextStyle.HeadTwo, color: SonrPalette.Tertiary);
  DesignText get h2_Grey => DesignText(this, DesignTextStyle.HeadTwo, color: SonrColor.Grey);
  DesignText get h2_Red => DesignText(this, DesignTextStyle.HeadTwo, color: SonrPalette.Critical);
  DesignText get h2_White => DesignText(this, DesignTextStyle.HeadTwo, color: SonrColor.White);
  DesignText headTwo({Color color = SonrColor.Black, FontWeight weight, TextAlign align = TextAlign.left, Key key}) =>
      DesignText(this, DesignTextStyle.HeadTwo, color: color, align: align, key: key, weight: weight); // Custom Options

  // Heading 3
  DesignText get h3 => DesignText(this, DesignTextStyle.HeadThree, color: SonrColor.Black);
  DesignText get h3_Blue => DesignText(this, DesignTextStyle.HeadThree, color: SonrPalette.Primary);
  DesignText get h3_Green => DesignText(this, DesignTextStyle.HeadThree, color: SonrPalette.Tertiary);
  DesignText get h3_Grey => DesignText(this, DesignTextStyle.HeadThree, color: SonrColor.Grey);
  DesignText get h3_Red => DesignText(this, DesignTextStyle.HeadThree, color: SonrPalette.Critical);
  DesignText get h3_White => DesignText(this, DesignTextStyle.HeadThree, color: SonrColor.White);
  DesignText headThree({Color color = SonrColor.Black, FontWeight weight, TextAlign align = TextAlign.left, Key key}) =>
      DesignText(this, DesignTextStyle.HeadThree, color: color, align: align, key: key, weight: weight); // Custom Options

  // Heading 4
  DesignText get h4 => DesignText(this, DesignTextStyle.HeadFour, color: SonrColor.Black);
  DesignText get h4_Blue => DesignText(this, DesignTextStyle.HeadFour, color: SonrPalette.Primary);
  DesignText get h4_Green => DesignText(this, DesignTextStyle.HeadFour, color: SonrPalette.Tertiary);
  DesignText get h4_Grey => DesignText(this, DesignTextStyle.HeadFour, color: SonrColor.Grey);
  DesignText get h4_Red => DesignText(this, DesignTextStyle.HeadFour, color: SonrPalette.Critical);
  DesignText get h4_White => DesignText(this, DesignTextStyle.HeadFour, color: SonrColor.White);
  DesignText headFour({Color color = SonrColor.Black, FontWeight weight, TextAlign align = TextAlign.left, Key key}) =>
      DesignText(this, DesignTextStyle.HeadFour, color: color, align: align, key: key, weight: weight); // Custom Options

  // Heading 5
  DesignText get h5 => DesignText(this, DesignTextStyle.HeadFive, color: SonrColor.Black);
  DesignText get h5_Blue => DesignText(this, DesignTextStyle.HeadFive, color: SonrPalette.Primary);
  DesignText get h5_Green => DesignText(this, DesignTextStyle.HeadFive, color: SonrPalette.Tertiary);
  DesignText get h5_Grey => DesignText(this, DesignTextStyle.HeadFive, color: SonrColor.Grey);
  DesignText get h5_Red => DesignText(this, DesignTextStyle.HeadFive, color: SonrPalette.Critical);
  DesignText get h5_White => DesignText(this, DesignTextStyle.HeadFive, color: SonrColor.White);
  DesignText headFive({Color color = SonrColor.Black, FontWeight weight, TextAlign align = TextAlign.left, Key key}) =>
      DesignText(this, DesignTextStyle.HeadFive, color: color, align: align, key: key, weight: weight); // Custom Options

  // Heading 6
  DesignText get h6 => DesignText(this, DesignTextStyle.HeadSix, color: SonrColor.Black);
  DesignText get h6_Blue => DesignText(this, DesignTextStyle.HeadSix, color: SonrPalette.Primary);
  DesignText get h6_Green => DesignText(this, DesignTextStyle.HeadSix, color: SonrPalette.Tertiary);
  DesignText get h6_Grey => DesignText(this, DesignTextStyle.HeadSix, color: SonrColor.Grey);
  DesignText get h6_Red => DesignText(this, DesignTextStyle.HeadSix, color: SonrPalette.Critical);
  DesignText get h6_White => DesignText(this, DesignTextStyle.HeadSix, color: SonrColor.White);
  DesignText headSix({Color color = SonrColor.Black, FontWeight weight, TextAlign align = TextAlign.left, Key key}) =>
      DesignText(this, DesignTextStyle.HeadSix, color: color, align: align, key: key, weight: weight); // Custom Options

  // Paragraph
  DesignText get p => DesignText(this, DesignTextStyle.Paragraph, color: SonrColor.Black);
  DesignText get p_Blue => DesignText(this, DesignTextStyle.Paragraph, color: SonrPalette.Primary);
  DesignText get p_Green => DesignText(this, DesignTextStyle.Paragraph, color: SonrPalette.Tertiary);
  DesignText get p_Grey => DesignText(this, DesignTextStyle.Paragraph, color: SonrColor.Grey);
  DesignText get p_Red => DesignText(this, DesignTextStyle.Paragraph, color: SonrPalette.Critical);
  DesignText get p_White => DesignText(this, DesignTextStyle.Paragraph, color: SonrColor.White);
  DesignText paragraph({Color color = SonrColor.Black, FontWeight weight, TextAlign align = TextAlign.left, Key key}) =>
      DesignText(this, DesignTextStyle.Paragraph, color: color, align: align, key: key, weight: weight); // Custom Options

  // Light
  DesignText get l => DesignText(this, DesignTextStyle.Light, color: SonrColor.Black);
  DesignText get l_Blue => DesignText(this, DesignTextStyle.Light, color: SonrPalette.Primary);
  DesignText get l_Green => DesignText(this, DesignTextStyle.Light, color: SonrPalette.Tertiary);
  DesignText get l_Grey => DesignText(this, DesignTextStyle.Light, color: SonrColor.Grey);
  DesignText get l_Red => DesignText(this, DesignTextStyle.Light, color: SonrPalette.Critical);
  DesignText get l_White => DesignText(this, DesignTextStyle.Light, color: SonrColor.White);
  DesignText light({Color color = SonrColor.Black, FontWeight weight, TextAlign align = TextAlign.left, Key key}) =>
      DesignText(this, DesignTextStyle.Light, color: color, align: align, key: key, weight: weight); // Custom Options

  // Miscelaneous
  GradientText gradient({double size = 32, @required FlutterGradientNames gradient, Key key}) => GradientText(this, gradient, size, key: key);
  URLText get url => URLText(this);
}

// ^ Parameters by Type ^ //
extension DesignTextParams on DesignTextStyle {
  // @ Accessors
  String get family => _params.item1;
  FontWeight get weight => _params.item2;
  double get size => _params.item3;

  // @ Type Values
  Triple<String, FontWeight, double> get _params {
    switch (this) {
      case DesignTextStyle.Hero:
        return Triple("Manrope", FontWeight.w800, 80);
        break;
      case DesignTextStyle.HeadOne:
        return Triple("Manrope", FontWeight.w800, 44);
        break;
      case DesignTextStyle.HeadTwo:
        return Triple("Manrope", FontWeight.w800, 38);
        break;
      case DesignTextStyle.HeadThree:
        return Triple("Manrope", FontWeight.w800, 32);
        break;
      case DesignTextStyle.HeadFour:
        return Triple("Manrope", FontWeight.w800, 28);
        break;
      case DesignTextStyle.HeadFive:
        return Triple("Manrope", FontWeight.w400, 24);
        break;
      case DesignTextStyle.HeadSix:
        return Triple("Manrope", FontWeight.w700, 20);
        break;
      case DesignTextStyle.Light:
        return Triple("Manrope", FontWeight.w300, 20);
        break;
      default:
        return Triple("OpenSans", FontWeight.w400, 16);
        break;
    }
  }
}

// ^ Design Text Widget ^ //
class DesignText extends StatelessWidget {
  final String text;
  final DesignTextStyle type;
  final Color color;
  final TextAlign align;
  final FontWeight weight;

  const DesignText(this.text, this.type, {this.color = SonrColor.Black, this.weight, this.align = TextAlign.left, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // # Gradient Text
    if (type == DesignTextStyle.Hero || type == DesignTextStyle.HeadOne) {
      return Center(
        child: ShaderMask(
            shaderCallback: (bounds) => FlutterGradients.crystalRiver(endAngle: 2.40855).createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
            child: _buildText(TextAlign.center)),
      );
    }

    // # Normal Text
    return _buildText(align);
  }

  // @ Builds Text Widget
  Text _buildText(TextAlign align) {
    return Text(
      text,
      overflow: TextOverflow.visible,
      textAlign: align,
      style: TextStyle(
        fontFamily: type.family,
        fontWeight: weight ?? type.weight,
        fontSize: type.size,
        color: color,
        fontFeatures: [
          FontFeature.tabularFigures(),
        ],
      ),
    );
  }
}

// ^ Gradient Text Type ^ //
class GradientText extends StatelessWidget {
  final String text;
  final FlutterGradientNames gradient;
  final double size;

  const GradientText(this.text, this.gradient, this.size, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShaderMask(
          shaderCallback: (bounds) => FlutterGradients.findByName(gradient).createShader(
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

// ^ URL Text Type ^ //
class URLText extends StatelessWidget {
  final String url;
  const URLText(this.url, {Key key}) : super(key: key);
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
      host.replaceAt(0, "m");
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
}
