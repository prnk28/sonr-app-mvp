import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'icon.dart';
import 'package:sonr_app/theme/theme.dart' hide Platform;
import 'package:sonr_app/data/data.dart';

enum DesignTextStyle { Hero, HeadingOne, HeadingTwo, HeadingThree, HeadingFour, HeadingFive, HeadingSix, Paragraph, ParagraphGrey }

extension DesignTextUtils on String {
  SonrTextStyle get hero => SonrTextStyle(this, DesignTextStyle.Hero);
  SonrTextStyle get h1 => SonrTextStyle(this, DesignTextStyle.HeadingOne);
  SonrTextStyle get h2 => SonrTextStyle(this, DesignTextStyle.HeadingTwo);
  SonrTextStyle get h3 => SonrTextStyle(this, DesignTextStyle.HeadingThree);
  SonrTextStyle get h4 => SonrTextStyle(this, DesignTextStyle.HeadingFour);
  SonrTextStyle get h5 => SonrTextStyle(this, DesignTextStyle.HeadingFive);
  SonrTextStyle get h6 => SonrTextStyle(this, DesignTextStyle.HeadingSix);
  SonrTextStyle get p => SonrTextStyle(this, DesignTextStyle.Paragraph);
  SonrTextStyle get pGrey => SonrTextStyle(this, DesignTextStyle.ParagraphGrey);
}

class SonrTextStyle extends StatelessWidget {
  final String text;
  final DesignTextStyle type;

  const SonrTextStyle(this.text, this.type);
  @override
  Widget build(BuildContext context) {
    // Const Colors
    const colorBlack = Color(0xff323232);
    const colorGrey = Color(0xff787878);

    // Initialize
    String family = "Manrope";
    FontWeight weight = FontWeight.w800;
    double size = 80;
    Color color = Colors.white;

    // Get Values
    switch (type) {
      // @ Hero One
      case DesignTextStyle.Hero:
        return Center(
          child: ShaderMask(
              shaderCallback: (bounds) => FlutterGradients.crystalRiver(endAngle: 2.40855).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: family,
                  fontWeight: weight,
                  fontSize: size,
                  color: color,
                  fontFeatures: [
                    FontFeature.tabularFigures(),
                  ],
                ),
              )),
        );
        break;

      // @ Heading One
      case DesignTextStyle.HeadingOne:
        return Center(
          child: ShaderMask(
              shaderCallback: (bounds) => FlutterGradients.crystalRiver(endAngle: 2.40855).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w800,
                  fontSize: 44,
                  color: Colors.white,
                  fontFeatures: [
                    FontFeature.tabularFigures(),
                  ],
                ),
              )),
        );
        break;
      case DesignTextStyle.HeadingTwo:
        color = colorBlack;
        size = 38;
        weight = FontWeight.w800;
        family = "Manrope";
        break;
      case DesignTextStyle.HeadingThree:
        color = colorBlack;
        size = 32;
        weight = FontWeight.w800;
        family = "Manrope";
        break;
      case DesignTextStyle.HeadingFour:
        color = colorBlack;
        size = 28;
        weight = FontWeight.w800;
        family = "Manrope";
        break;
      case DesignTextStyle.HeadingFive:
        color = colorBlack;
        size = 24;
        weight = FontWeight.w400;
        family = "Manrope";
        break;
      case DesignTextStyle.HeadingSix:
        color = colorBlack;
        size = 20;
        weight = FontWeight.w700;
        family = "Manrope";
        break;
      case DesignTextStyle.Paragraph:
        color = colorBlack;
        size = 18;
        weight = FontWeight.w400;
        family = "OpenSans";
        break;
      case DesignTextStyle.ParagraphGrey:
        color = colorGrey;
        size = 18;
        weight = FontWeight.w400;
        family = "OpenSans";
        break;
    }
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: family,
        fontWeight: weight,
        fontSize: size,
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

  // ^ Black(w800) Text with Provided Data
  factory SonrText.header(String text, {double size = 40, Color color, Key key}) {
    return SonrText(text,
        isGradient: color != null ? false : true,
        isCentered: true,
        weight: FontWeight.w700,
        size: size,
        key: key,
        color: color,
        gradient: UserService.isDarkMode ? FlutterGradientNames.saintPetersburg.linear() : FlutterGradientNames.viciousStance.linear());
  }

  // ^ Light(w300) Text with Provided Data -- Description Text
  factory SonrText.title(String text, {Key key, Color color = SonrColor.Black, bool isCentered = false}) {
    return SonrText(text, weight: FontWeight.w600, size: Platform.isAndroid ? 35 : 37, key: key, color: color, isCentered: isCentered);
  }

  // ^ Light(w300) Text with Provided Data -- Description Text
  factory SonrText.subtitle(String text, {Key key, bool isCentered = false}) {
    return SonrText(text, weight: FontWeight.w500, size: Platform.isAndroid ? 20 : 21, key: key, color: SonrColor.Black, isCentered: isCentered);
  }

  // ^ Light(w300) Text with Provided Data -- Description Text
  factory SonrText.paragraph(String text, {Key key}) {
    return SonrText(text, weight: FontWeight.w400, size: Platform.isAndroid ? 16 : 17, key: key, color: SonrColor.Black);
  }

  // ^ Light(w300) Text with Provided Data -- Description Text
  factory SonrText.span(String text, {Key key}) {
    return SonrText(text, weight: FontWeight.w400, size: Platform.isAndroid ? 13 : 14, key: key, color: SonrColor.Black);
  }

  // ^ Light(w300) Text with Provided Data -- Description Text
  factory SonrText.light(String text, {Color color = SonrColor.Black, double size = 32, Key key}) {
    return SonrText(text, weight: FontWeight.w400, size: size, key: key, color: UserService.isDarkMode ? Colors.white : SonrColor.Black);
  }

  // ^ Normal(w400) Text with Provided Data
  factory SonrText.normal(String text, {Color color = SonrColor.Black, double size = 24, Key key}) {
    return SonrText(text, weight: FontWeight.w400, size: size, key: key, color: UserService.isDarkMode ? Colors.white : SonrColor.Black);
  }

  // ^ Medium(w500) Text with Provided Data -- Default Text
  factory SonrText.medium(String text, {Color color = SonrColor.Black, double size = 16, Key key}) {
    return SonrText(text, weight: FontWeight.w600, size: size, key: key, color: UserService.isDarkMode ? Colors.white : SonrColor.Black);
  }

  // ^ SemiBold(w600) Text with Provided Data -- Button Text
  factory SonrText.semibold(String text, {Color color = Colors.black87, double size = 18, Key key}) {
    return SonrText(text, weight: FontWeight.w700, size: size, key: key, color: UserService.isDarkMode ? Colors.white70 : SonrColor.Black);
  }

  // ^ Bold(w700) Text with Provided Data -- Header Text
  factory SonrText.bold(String text, {Color color = SonrColor.Black, double size = 32, Key key}) {
    return SonrText(text, weight: FontWeight.w800, size: size, key: key, color: UserService.isDarkMode ? Colors.white : SonrColor.Black);
  }

  // ^ Medium(w500) Text with Provided Publish Post Date, Formats JSON Date -- Default Text
  factory SonrText.postDate(String pubDate, {FlutterGradientNames gradient = FlutterGradientNames.premiumDark, double size = 16, Key key}) {
    var date = DateTime.parse(pubDate);
    var output = new DateFormat.yMMMMd('en_US');
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
