import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sonr_app/data/model/model_register.dart';
import 'style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'icon.dart';
import 'package:sonr_app/theme/theme.dart' hide Platform;

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
        gradient: UserService.isDarkMode.value ? FlutterGradientNames.saintPetersburg.linear() : FlutterGradientNames.viciousStance.linear());
  }

  // ^ Light(w300) Text with Provided Data -- Description Text
  factory SonrText.title(String text, {Key key, Color color = SonrColor.Black}) {
    return SonrText(text, weight: FontWeight.w600, size: Platform.isAndroid ? 35 : 37, key: key, color: color);
  }

  // ^ Light(w300) Text with Provided Data -- Description Text
  factory SonrText.subtitle(String text, {Key key}) {
    return SonrText(text, weight: FontWeight.w400, size: Platform.isAndroid ? 20 : 21, key: key, color: SonrColor.Black);
  }

  // ^ Light(w300) Text with Provided Data -- Description Text
  factory SonrText.paragraph(String text, {Key key}) {
    return SonrText(text, weight: FontWeight.w400, size: Platform.isAndroid ? 16 : 17, key: key, color: SonrColor.Black);
  }

  // ^ Light(w300) Text with Provided Data -- Description Text
  factory SonrText.span(String text, {Key key}) {
    return SonrText(text, weight: FontWeight.w300, size: Platform.isAndroid ? 13 : 14, key: key, color: SonrColor.Black);
  }

  // ^ Light(w300) Text with Provided Data -- Description Text
  factory SonrText.light(String text, {Color color = SonrColor.Black, double size = 32, Key key}) {
    return SonrText(text, weight: FontWeight.w300, size: size, key: key, color: UserService.isDarkMode.value ? Colors.white : SonrColor.Black);
  }

  // ^ Normal(w400) Text with Provided Data
  factory SonrText.normal(String text, {Color color = SonrColor.Black, double size = 24, Key key}) {
    return SonrText(text, weight: FontWeight.w400, size: size, key: key, color: UserService.isDarkMode.value ? Colors.white : SonrColor.Black);
  }

  // ^ Medium(w500) Text with Provided Data -- Default Text
  factory SonrText.medium(String text, {Color color = SonrColor.Black, double size = 16, Key key}) {
    return SonrText(text, weight: FontWeight.w500, size: size, key: key, color: UserService.isDarkMode.value ? Colors.white : SonrColor.Black);
  }

  // ^ SemiBold(w600) Text with Provided Data -- Button Text
  factory SonrText.semibold(String text, {Color color = Colors.black87, double size = 18, Key key}) {
    return SonrText(text, weight: FontWeight.w600, size: size, key: key, color: UserService.isDarkMode.value ? Colors.white70 : SonrColor.Black);
  }

  // ^ Bold(w700) Text with Provided Data -- Header Text
  factory SonrText.bold(String text, {Color color = SonrColor.Black, double size = 32, Key key}) {
    return SonrText(text, weight: FontWeight.w700, size: size, key: key, color: UserService.isDarkMode.value ? Colors.white : SonrColor.Black);
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
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300, fontSize: size, color: UserService.isDarkMode.value ? SonrColor.Black : Colors.white)),
              TextSpan(
                  text: "  $timeText",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: size, color: UserService.isDarkMode.value ? SonrColor.Black : Colors.white)),
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
              TextSpan(text: seconds.toString(), style: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: size, color: SonrColor.Black)),
              TextSpan(text: "  s", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: size, color: SonrColor.Black)),
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
        gradient: UserService.isDarkMode.value ? FlutterGradientNames.premiumWhite.linear() : FlutterGradientNames.premiumDark.linear());
  }

  // ^ Rich Text with FirstName and Invite
  factory SonrText.invite(String type, String firstName) {
    return SonrText("",
        isRich: true,
        richText: RichText(
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            text: TextSpan(children: [
              TextSpan(text: type.capitalizeFirst, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 26, color: SonrColor.Black)),
              TextSpan(
                  text: " from ${firstName.capitalizeFirst}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, fontSize: 22, color: Colors.blue[900])),
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
          style: GoogleFonts.poppins(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted,
              fontWeight: FontWeight.w300,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.blueGrey[300])),
      TextSpan(
          text: directories > 0 ? path : "",
          style: GoogleFonts.poppins(
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
              style: GoogleFonts.poppins(fontWeight: weight, fontSize: size ?? 32.0, color: Colors.white),
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
    if (UserService.isDarkMode.value) {
      return Colors.white;
    } else {
      return SonrColor.Black;
    }
  }

  // ^ Returns Random Hint Name ^
  static Tuple<String, String> hintName() {
    return <Tuple<String, String>>[
      Tuple("Steve", "Jobs"),
      Tuple("Michelangelo", "Buonarroti"),
      Tuple("Albert", "Einstein"),
      Tuple("Douglas", "Engelbart"),
      Tuple("Kendrick", "Lamar"),
      Tuple("David", "Chaum"),
      Tuple("Ada", "Lovelace"),
      Tuple("Madam", "Curie"),
      Tuple("Amelia", "Earhart"),
      Tuple("Oprah", "Winfrey"),
      Tuple("Maya", "Angelou"),
      Tuple("Frida", "Kahlo"),
    ].random();
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
  final Rx<TextInputValidStatus> status;
  final ValueChanged<String> onChanged;
  final Function onEditingComplete;
  final Iterable<String> autofillHints;

  SonrTextField(
      {@required this.hint,
      @required this.value,
      this.label,
      this.status,
      this.controller,
      this.onChanged,
      this.focusNode,
      this.onEditingComplete,
      this.textInputAction = TextInputAction.done,
      this.autoFocus = false,
      this.autoCorrect = true,
      this.textCapitalization = TextCapitalization.none,
      this.autofillHints});

  @override
  Widget build(BuildContext context) {
    return status != null
        ? ObxValue<Rx<TextInputValidStatus>>((status) {
            if (status.value == TextInputValidStatus.Invalid) {
              return buildInvalid(context);
            } else {
              return buildDefault(context);
            }
          }, status)
        : buildDefault(context);
  }

  Widget buildDefault(BuildContext context, {InputDecoration decoration, bool isError = false}) {
    return ValueBuilder<String>(
      initialValue: value,
      builder: (value, updateFn) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            label != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                    child: Row(children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: NeumorphicTheme.defaultTextColor(context),
                        ),
                      ),
                      isError
                          ? Text(
                              " *Error",
                              style: TextStyle(fontWeight: FontWeight.w500, color: SonrPalete.Red),
                            )
                          : Container(),
                    ]))
                : Container(),
            Neumorphic(
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
              style: NeumorphicStyle(
                depth: NeumorphicTheme.embossDepth(context),
                boxShape: NeumorphicBoxShape.stadium(),
              ),
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              child: TextField(
                style: GoogleFonts.poppins(fontWeight: FontWeight.w400, color: UserService.isDarkMode.value ? Colors.white : SonrColor.Black),
                controller: controller,
                autofocus: autoFocus,
                textInputAction: textInputAction,
                autocorrect: autoCorrect,
                textCapitalization: textCapitalization,
                focusNode: focusNode,
                autofillHints: autofillHints,
                onEditingComplete: onEditingComplete,
                onChanged: updateFn,
                decoration: decoration != null
                    ? decoration
                    : InputDecoration.collapsed(
                        hintText: hint,
                        hintStyle:
                            GoogleFonts.poppins(fontWeight: FontWeight.w400, color: UserService.isDarkMode.value ? Colors.white38 : Colors.black38)),
              ),
            )
          ],
        );
      },
      onUpdate: onChanged,
    );
  }

  Widget buildInvalid(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: 1.seconds,
      builder: (context, animation, child) => Transform.translate(
        offset: shakeOffset(animation),
        child: child,
      ),
      child: buildDefault(context,
          isError: true,
          decoration: InputDecoration.collapsed(
              border: UnderlineInputBorder(borderSide: BorderSide(color: SonrPalete.Red, width: 4)),
              hintText: hint,
              hintStyle: GoogleFonts.poppins(fontWeight: FontWeight.w400, color: UserService.isDarkMode.value ? Colors.white38 : Colors.black38))),
    );
  }

  // ^ Get Animated Offset for Shake Method ^ //
  Offset shakeOffset(double animation) {
    var shake = 2 * (0.5 - (0.5 - Curves.bounceOut.transform(animation)).abs());
    return Offset(18 * shake, 0);
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
