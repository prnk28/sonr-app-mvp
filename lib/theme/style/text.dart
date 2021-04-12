import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'icon.dart';
import 'package:sonr_app/theme/theme.dart' hide Platform;
import 'package:sonr_app/data/data.dart';

// ^ Design Style Type ^ //
enum DesignTextStyle { Hero, HeadOne, HeadTwo, HeadThree, HeadFour, HeadFive, HeadSix, Paragraph, Light }

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
  DesignText get h2_Red => DesignText(this, DesignTextStyle.HeadTwo, color: SonrPalette.Red);
  DesignText get h2_White => DesignText(this, DesignTextStyle.HeadTwo, color: SonrColor.White);
  DesignText headTwo({Color color = SonrColor.Black, TextAlign align = TextAlign.left}) =>
      DesignText(this, DesignTextStyle.HeadTwo, color: color, align: align); // Custom Options

  // Heading 3
  DesignText get h3 => DesignText(this, DesignTextStyle.HeadThree, color: SonrColor.Black);
  DesignText get h3_Blue => DesignText(this, DesignTextStyle.HeadThree, color: SonrPalette.Primary);
  DesignText get h3_Green => DesignText(this, DesignTextStyle.HeadThree, color: SonrPalette.Tertiary);
  DesignText get h3_Grey => DesignText(this, DesignTextStyle.HeadThree, color: SonrColor.Grey);
  DesignText get h3_Red => DesignText(this, DesignTextStyle.HeadThree, color: SonrPalette.Red);
  DesignText get h3_White => DesignText(this, DesignTextStyle.HeadThree, color: SonrColor.White);
  DesignText headThree({Color color = SonrColor.Black, TextAlign align = TextAlign.left}) =>
      DesignText(this, DesignTextStyle.HeadThree, color: color, align: align); // Custom Options

  // Heading 4
  DesignText get h4 => DesignText(this, DesignTextStyle.HeadFour, color: SonrColor.Black);
  DesignText get h4_Blue => DesignText(this, DesignTextStyle.HeadFour, color: SonrPalette.Primary);
  DesignText get h4_Green => DesignText(this, DesignTextStyle.HeadFour, color: SonrPalette.Tertiary);
  DesignText get h4_Grey => DesignText(this, DesignTextStyle.HeadFour, color: SonrColor.Grey);
  DesignText get h4_Red => DesignText(this, DesignTextStyle.HeadFour, color: SonrPalette.Red);
  DesignText get h4_White => DesignText(this, DesignTextStyle.HeadFour, color: SonrColor.White);
  DesignText headFour({Color color = SonrColor.Black, TextAlign align = TextAlign.left}) =>
      DesignText(this, DesignTextStyle.HeadFour, color: color, align: align); // Custom Options

  // Heading 5
  DesignText get h5 => DesignText(this, DesignTextStyle.HeadFive, color: SonrColor.Black);
  DesignText get h5_Blue => DesignText(this, DesignTextStyle.HeadFive, color: SonrPalette.Primary);
  DesignText get h5_Green => DesignText(this, DesignTextStyle.HeadFive, color: SonrPalette.Tertiary);
  DesignText get h5_Grey => DesignText(this, DesignTextStyle.HeadFive, color: SonrColor.Grey);
  DesignText get h5_Red => DesignText(this, DesignTextStyle.HeadFive, color: SonrPalette.Red);
  DesignText get h5_White => DesignText(this, DesignTextStyle.HeadFive, color: SonrColor.White);
  DesignText headFive({Color color = SonrColor.Black, TextAlign align = TextAlign.left}) =>
      DesignText(this, DesignTextStyle.HeadFive, color: color, align: align); // Custom Options

  // Heading 6
  DesignText get h6 => DesignText(this, DesignTextStyle.HeadSix, color: SonrColor.Black);
  DesignText get h6_Blue => DesignText(this, DesignTextStyle.HeadSix, color: SonrPalette.Primary);
  DesignText get h6_Green => DesignText(this, DesignTextStyle.HeadSix, color: SonrPalette.Tertiary);
  DesignText get h6_Grey => DesignText(this, DesignTextStyle.HeadSix, color: SonrColor.Grey);
  DesignText get h6_Red => DesignText(this, DesignTextStyle.HeadSix, color: SonrPalette.Red);
  DesignText get h6_White => DesignText(this, DesignTextStyle.HeadSix, color: SonrColor.White);
  DesignText headSix({Color color = SonrColor.Black, TextAlign align = TextAlign.left}) =>
      DesignText(this, DesignTextStyle.HeadSix, color: color, align: align); // Custom Options

  // Paragraph
  DesignText get p => DesignText(this, DesignTextStyle.Paragraph, color: SonrColor.Black);
  DesignText get p_Blue => DesignText(this, DesignTextStyle.Paragraph, color: SonrPalette.Primary);
  DesignText get p_Green => DesignText(this, DesignTextStyle.Paragraph, color: SonrPalette.Tertiary);
  DesignText get p_Grey => DesignText(this, DesignTextStyle.Paragraph, color: SonrColor.Grey);
  DesignText get p_Red => DesignText(this, DesignTextStyle.Paragraph, color: SonrPalette.Red);
  DesignText get p_White => DesignText(this, DesignTextStyle.Paragraph, color: SonrColor.White);
  DesignText paragraph({Color color = SonrColor.Black, TextAlign align = TextAlign.left}) =>
      DesignText(this, DesignTextStyle.Paragraph, color: color, align: align); // Custom Options

  // Light
  DesignText get l => DesignText(this, DesignTextStyle.Light, color: SonrColor.Black);
  DesignText get l_Blue => DesignText(this, DesignTextStyle.Light, color: SonrPalette.Primary);
  DesignText get l_Green => DesignText(this, DesignTextStyle.Light, color: SonrPalette.Tertiary);
  DesignText get l_Grey => DesignText(this, DesignTextStyle.Light, color: SonrColor.Grey);
  DesignText get l_Red => DesignText(this, DesignTextStyle.Light, color: SonrPalette.Red);
  DesignText get l_White => DesignText(this, DesignTextStyle.Light, color: SonrColor.White);
  DesignText light({Color color = SonrColor.Black, TextAlign align = TextAlign.left}) =>
      DesignText(this, DesignTextStyle.Light, color: color, align: align); // Custom Options
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

  const DesignText(this.text, this.type, {this.color = SonrColor.Black, this.align = TextAlign.left});
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
      overflow: TextOverflow.ellipsis,
      textAlign: align,
      style: TextStyle(
        fontFamily: type.family,
        fontWeight: type.weight,
        fontSize: type.size,
        color: color,
        fontFeatures: [
          FontFeature.tabularFigures(),
        ],
      ),
    );
  }
}

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

  // ^ Light(w300) Text with Provided Data -- Description Text
  factory SonrText.light(String text, {Color color = SonrColor.Black, double size = 32, Key key}) {
    return SonrText(text, weight: FontWeight.w400, size: size, key: key, color: UserService.isDarkMode ? Colors.white : SonrColor.Black);
  }

  // // ^ SemiBold(w600) Text with Provided Data -- Button Text
  // factory SonrText.semibold(String text, {Color color = Colors.black87, double size = 18, Key key}) {
  //   return SonrText(text, weight: FontWeight.w700, size: size, key: key, color: UserService.isDarkMode ? Colors.white70 : SonrColor.Black);
  // }

  // ^ Bold(w700) Text with Provided Data -- Header Text
  factory SonrText.bold(String text, {Color color = SonrColor.Black, double size = 32, Key key}) {
    return SonrText(text, weight: FontWeight.w800, size: size, key: key, color: UserService.isDarkMode ? Colors.white : SonrColor.Black);
  }

  // ^ Medium(w500) Text with Provided Publish Post Date, Formats JSON Date -- Default Text
  factory SonrText.postDate(String pubDate, {FlutterGradientNames gradient = FlutterGradientNames.premiumDark, double size = 16, Key key}) {
    var date = DateTime.parse(pubDate);
    var output = DateFormat.yMMMMd('en_US');
    return SonrText.gradient(output.format(date).toString(), gradient, size: size, key: key, weight: FontWeight.w500);
  }

  // ^ Normal(w400) Text with Provided Data
  factory SonrText.postDescription(int titleLength, String postDesc, {Color color, double size = 14, Key key}) {
    // Calculate Description length
    int maxDesc = 118;
    if (titleLength > 50) {
      int factor = titleLength - 50;
      maxDesc = maxDesc - factor;
    }

    // Clean from HTML Tags
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String cleaned = postDesc.replaceAll(exp, '');

    // Limit Characters
    var text = cleaned.substring(0, maxDesc) + "...";
    return SonrText(text, weight: FontWeight.w400, size: size, key: key, color: color ?? Colors.grey[800]);
  }

  // ^ Date Text with Provided Data
  factory SonrText.date(DateTime date, {double size = 14, Key key, Color color = Colors.white}) {
    // Formatters
    final dateFormat = DateFormat.yMd();
    final timeFormat = DateFormat.jm();

    // Get String
    String dateText = dateFormat.format(date);
    String timeText = timeFormat.format(date);

    return SonrText("",
        isRich: true,
        richText: RichText(
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            text: TextSpan(children: [
              TextSpan(
                  text: dateText,
                  style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w300,
                      fontSize: size,
                      fontFeatures: [
                        FontFeature.tabularFigures(),
                      ],
                      color: UserService.isDarkMode ? SonrColor.Black : Colors.white)),
              TextSpan(
                  text: "  $timeText",
                  style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontFeatures: [
                        FontFeature.tabularFigures(),
                      ],
                      fontSize: size,
                      color: UserService.isDarkMode ? SonrColor.Black : Colors.white)),
            ])));
  }

  // ^ Date Text with Provided Data
  factory SonrText.duration(int milliseconds, {double size = 14, Key key}) {
    int seconds = milliseconds ~/ 1000;
    return SonrText("",
        isRich: true,
        richText: RichText(
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            text: TextSpan(children: [
              TextSpan(
                  text: seconds.toString(),
                  style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w300, fontSize: size, color: SonrColor.Black)),
              TextSpan(text: "  s", style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w600, fontSize: size, color: SonrColor.Black)),
            ])));
  }

  // ^ Gradient Text with Provided Data
  factory SonrText.gradient(String text, FlutterGradientNames gradient, {FontWeight weight = FontWeight.bold, double size = 40, Key key}) {
    return SonrText(text, isGradient: true, weight: weight, size: size, key: key, gradient: FlutterGradients.findByName(gradient));
  }

  // ^ AppBar Text with Provided Data
  factory SonrText.appBar(String text, {double size = 30, FlutterGradientNames gradient = FlutterGradientNames.premiumDark, Key key}) {
    return SonrText(text,
        isGradient: true,
        weight: FontWeight.w600,
        size: size,
        key: key,
        gradient: UserService.isDarkMode ? FlutterGradientNames.premiumWhite.linear() : FlutterGradientNames.premiumDark.linear());
  }

  // ^ Rich Text with FirstName and Invite
  factory SonrText.invite(String type, String firstName) {
    return SonrText("",
        isRich: true,
        richText: RichText(
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            text: TextSpan(children: [
              TextSpan(
                  text: type.capitalizeFirst,
                  style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w800, fontSize: 26, color: SonrColor.Black)),
              TextSpan(
                  text: " from ${firstName.capitalizeFirst}",
                  style: TextStyle(
                      fontFamily: 'Manrope', fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, fontSize: 22, color: Colors.blue[900])),
            ])));
  }

  // ^ Rich Text with FirstName and Invite
  factory SonrText.search(String query, String value, {Color color = SonrColor.Black, double size = 16, Key key}) {
    // Text Contains Query
    if (value.toLowerCase().contains(query.toLowerCase())) {
      query = query.toLowerCase();
      value = value.toLowerCase();
      return SonrText("",
          isRich: true,
          richText: RichText(
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              text: TextSpan(children: [
                TextSpan(
                    text: value.substring(value.indexOf(query), query.length).toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'Manrope', fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: size, color: Colors.blue[500])),
                TextSpan(
                    text: value.substring(value.indexOf(query) + query.length),
                    style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.normal, fontSize: size, color: color)),
              ])));
    } else {
      return SonrText(value, weight: FontWeight.w500, size: size, key: key, color: color);
    }
  }

  // ^ Rich Text with Provided Data as URL
  factory SonrText.url(String url) {
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

    return SonrText("",
        isRich: true,
        richText: RichText(
          overflow: TextOverflow.fade,
          text: TextSpan(children: spans),
        ));
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
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: weight,
                fontSize: size ?? 32.0,
                color: Colors.white,
                fontFeatures: [
                  FontFeature.tabularFigures(),
                ],
              ),
            )),
      );
    }

    // @ Rich Type Text
    if (isRich) {
      return richText;
    }

    // @ Normal Type Text
    return Text(text,
        textAlign: isCentered ? TextAlign.center : TextAlign.start,
        style: TextStyle(fontFamily: 'Manrope', fontWeight: weight, fontSize: size ?? 16, color: color ?? findTextColor()));
  }

  // ^ Find Text color based on Theme - Light/Dark ^
  static Color findTextColor() {
    if (UserService.isDarkMode) {
      return Colors.white;
    } else {
      return SonrColor.Black;
    }
  }
}
