import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart' hide Platform;
import 'package:sonr_app/data/data.dart';

enum TextInputValidStatus { None, Valid, Invalid }

extension TextInputValidStatusUtils on TextInputValidStatus {
  static TextInputValidStatus fromValidBool(bool val) {
    if (val) {
      return TextInputValidStatus.Valid;
    } else {
      return TextInputValidStatus.Invalid;
    }
  }

  static TextInputValidStatus fromInvalidBool(bool val) {
    if (val) {
      return TextInputValidStatus.Invalid;
    } else {
      return TextInputValidStatus.Valid;
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
  final Rx<TextInputValidStatus> status;
  final ValueChanged<String> onChanged;
  final Function onEditingComplete;
  final Iterable<String> autofillHints;

  // ^ Returns Random Hint Name ^
  static Tuple<String, String> hintName() {
    return <Tuple<String, String>>[
      MobileService.isNotApple ? Tuple("Bill", "Gates") : Tuple("Steve", "Jobs"),
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
                              style: TextStyle(fontWeight: FontWeight.w500, color: SonrColor.Critical),
                            )
                          : Container(),
                    ]))
                : Container(),
            Container(
              decoration: Neumorph.floating(),
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              child: TextField(
                style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400, color: UserService.isDarkMode ? Colors.white : SonrColor.Black),
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
                        hintStyle: TextStyle(
                            fontFamily: 'OpenSans', fontWeight: FontWeight.w400, color: UserService.isDarkMode ? Colors.white38 : Colors.black38)),
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
              border: UnderlineInputBorder(borderSide: BorderSide(color: SonrColor.Critical, width: 4)),
              hintText: hint,
              hintStyle:
                  TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400, color: UserService.isDarkMode ? Colors.white38 : Colors.black38))),
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
            Container(
                margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
                decoration: Neumorph.floating(),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                child: Stack(children: [
                  Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        SonrIcons.Search.gradientNamed(name: FlutterGradientNames.amourAmour, size: 30),
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
