import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'icon.dart';
import 'package:sonr_app/data/constants.dart';

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
  factory SonrText.light(String text, {Color color = Colors.black, double size = 32, Key key}) {
    return SonrText(text, weight: FontWeight.w300, size: size, key: key, color: color);
  }

  // ^ Normal(w400) Text with Provided Data
  factory SonrText.normal(String text, {Color color = Colors.black, double size = 24, Key key}) {
    return SonrText(text, weight: FontWeight.w400, size: size, key: key, color: color);
  }

  // ^ Medium(w500) Text with Provided Data -- Default Text
  factory SonrText.medium(String text, {Color color = Colors.black, double size = 16, Key key}) {
    return SonrText(text, weight: FontWeight.w500, size: size, key: key, color: color);
  }

  // ^ SemiBold(w600) Text with Provided Data -- Button Text
  factory SonrText.semibold(String text, {Color color = Colors.black87, double size = 18, Key key}) {
    return SonrText(text, weight: FontWeight.w600, size: size, key: key, color: color);
  }

  // ^ Bold(w700) Text with Provided Data -- Header Text
  factory SonrText.bold(String text, {Color color = Colors.black, double size = 32, Key key}) {
    return SonrText(text, weight: FontWeight.w700, size: size, key: key, color: color);
  }

  // ^ Black(w800) Text with Provided Data
  factory SonrText.black(String text, {Color color = Colors.black, double size = 16, Key key}) {
    return SonrText(text, weight: FontWeight.w800, size: size, key: key, color: color);
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
  factory SonrText.date(DateTime date, {double size = 14, Key key}) {
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
              TextSpan(text: dateText, style: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: size, color: Colors.black)),
              TextSpan(text: "  $timeText", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: size, color: Colors.black)),
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
              TextSpan(text: seconds.toString(), style: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: size, color: Colors.black)),
              TextSpan(text: "  s", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: size, color: Colors.black)),
            ])));
  }

  // ^ Header Text with Provided Data
  factory SonrText.header(String text, {FlutterGradientNames gradient = FlutterGradientNames.viciousStance, double size = 40, Key key}) {
    return SonrText(
      text,
      isGradient: true,
      isCentered: true,
      weight: FontWeight.w700,
      size: size,
      key: key,
      gradient: FlutterGradients.findByName(gradient),
    );
  }

  // ^ Gradient Text with Provided Data
  factory SonrText.gradient(String text, FlutterGradientNames gradient, {FontWeight weight = FontWeight.bold, double size = 40, Key key}) {
    return SonrText(text, isGradient: true, weight: weight, size: size, key: key, gradient: FlutterGradients.findByName(gradient));
  }

  // ^ AppBar Text with Provided Data
  factory SonrText.appBar(String text, {double size = 30, FlutterGradientNames gradient = FlutterGradientNames.premiumDark, Key key}) {
    return SonrText(
      text,
      isGradient: true,
      weight: FontWeight.w600,
      size: size,
      key: key,
      gradient: gradient.linear(),
    );
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

  // ^ Rich Text with FirstName and Invite
  factory SonrText.search(String query, String value, {Color color = Colors.black, double size = 16, Key key}) {
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
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: size, color: Colors.blue[500])),
                TextSpan(
                    text: value.substring(value.indexOf(query) + query.length),
                    style: GoogleFonts.poppins(fontWeight: FontWeight.normal, fontSize: size, color: color)),
              ])));
    } else {
      return SonrText(value, weight: FontWeight.w500, size: size, key: key, color: color);
    }
  }

  // ^ Rich Text with Provided Data as URL
  factory SonrText.url(String text) {
    return SonrText(text,
        isRich: true,
        richText: RichText(
          overflow: TextOverflow.fade,
          text: TextSpan(children: text.urlText),
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
  final TextEditingController controller;
  final TextInputAction textInputAction;

  final ValueChanged<String> onChanged;
  final Function onEditingComplete;

  SonrTextField(
      {@required this.hint,
      @required this.value,
      this.label,
      this.controller,
      this.onChanged,
      this.focusNode,
      this.onEditingComplete,
      this.textInputAction = TextInputAction.done,
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
            label != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: NeumorphicTheme.defaultTextColor(context),
                      ),
                    ),
                  )
                : Container(),
            Neumorphic(
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
              style: NeumorphicStyle(
                depth: NeumorphicTheme.embossDepth(context),
                boxShape: NeumorphicBoxShape.stadium(),
              ),
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              child: TextField(
                controller: controller,
                autofocus: autoFocus,
                textInputAction: textInputAction,
                autocorrect: autoCorrect,
                textCapitalization: textCapitalization,
                focusNode: focusNode,
                onEditingComplete: onEditingComplete,
                onChanged: updateFn,
                decoration:
                    InputDecoration.collapsed(hintText: hint, hintStyle: GoogleFonts.poppins(fontWeight: FontWeight.w400, color: Colors.black38)),
              ),
            )
          ],
        );
      },
      onUpdate: onChanged,
    );
  }
}

enum SearchFieldType { Username, Cards }

// ^ Builds Neumorphic Text Field for Search ^ //
class SonrSearchField extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final Function onEditingComplete;
  final Iterable<String> autofillHints;
  final SearchFieldType type;
  final Widget suggestion;

  factory SonrSearchField.forUsername({
    @required Widget suggestion,
    @required String value,
    ValueChanged<String> onChanged,
    Function onEditingComplete,
    Iterable<String> autofillHints,
    Function onSuggestionTap,
  }) {
    return SonrSearchField(SearchFieldType.Username, value: value);
  }

  factory SonrSearchField.forCards({
    @required Widget suggestion,
    @required String value,
    ValueChanged<String> onChanged,
    Function onEditingComplete,
    Iterable<String> autofillHints,
  }) {
    return SonrSearchField(
      SearchFieldType.Cards,
      value: value,
      suggestion: suggestion,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      autofillHints: autofillHints,
    );
  }

  SonrSearchField(
    this.type, {
    @required this.value,
    this.onChanged,
    this.onEditingComplete,
    this.autofillHints,
    this.suggestion,
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
                child: Stack(children: [
                  Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        SonrIcon.gradient(Icons.search, FlutterGradientNames.amourAmour, size: 30),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: TextField(
                              autofillHints: autofillHints,
                              showCursor: false,
                              autofocus: true,
                              onEditingComplete: onEditingComplete,
                              onChanged: updateFn,
                              decoration: InputDecoration.collapsed(hintText: "Search...", hintStyle: TextStyle(color: Colors.black38)),
                            ),
                          ),
                        ),
                      ])),
                  Align(alignment: Alignment.centerRight, child: suggestion)
                ]))
          ],
        );
      },
      onUpdate: onChanged,
    );
  }
}
