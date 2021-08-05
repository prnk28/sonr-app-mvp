import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style/style.dart' hide Platform;
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

/// #### Builds Neumorphic Text Field
class DesignTextField extends StatelessWidget {
  final String? label;
  final String hint;
  final String value;
  final FocusNode? focusNode;
  final bool autoFocus;
  final bool autoCorrect;
  final TextCapitalization textCapitalization;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final Rx<TextInputValidStatus>? status;
  final ValueChanged<String>? onChanged;
  final void Function()? onEditingComplete;

  DesignTextField({
    required this.hint,
    required this.value,
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
  });

  @override
  Widget build(BuildContext context) {
    return status != null
        ? ObxValue<Rx<TextInputValidStatus>>((status) {
            if (status.value == TextInputValidStatus.Invalid) {
              return buildInvalid(context);
            } else {
              return buildDefault(context);
            }
          }, status!)
        : buildDefault(context);
  }

  Widget buildDefault(BuildContext context, {InputDecoration? decoration, bool isError = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        label != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                child: Row(children: [
                  Text(
                    label!,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  isError
                      ? Text(
                          " *Error",
                          style: TextStyle(fontWeight: FontWeight.w500, color: AppColor.Red),
                        )
                      : Container(),
                ]))
            : Container(),
        BoxContainer(
          margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          child: TextField(
            style: TextStyle(
              fontFamily: 'R-Flex',
              fontWeight: FontWeight.w500,
              color: AppTheme.ItemColor,
            ),
            controller: controller,
            autofocus: autoFocus,
            textInputAction: textInputAction,
            autocorrect: autoCorrect,
            textCapitalization: textCapitalization,
            focusNode: focusNode,
            onEditingComplete: onEditingComplete,
            onChanged: onChanged,
            decoration: decoration != null
                ? decoration
                : InputDecoration.collapsed(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontFamily: 'R-Flex',
                      fontWeight: FontWeight.w300,
                      color: AppTheme.ItemColor,
                    )),
          ),
        )
      ],
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
              border: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: AppColor.Red,
                width: 2,
              )),
              hintText: hint,
              hintStyle: TextStyle(
                fontFamily: 'R-Flex',
                fontWeight: FontWeight.w300,
                color: AppTheme.ItemColor,
              ))),
    );
  }

  /// #### Get Animated Offset for Shake Method
  Offset shakeOffset(double animation) {
    var shake = 2 * (0.5 - (0.5 - Curves.bounceOut.transform(animation)).abs());
    return Offset(18 * shake, 0);
  }
}

/// ### SNameTextField
/// Creates TextField for SName Field.
class SNameTextField extends StatelessWidget {
  final void Function(String value) onEditingComplete;
  final void Function(String value)? onChanged;
  final hint = TextUtils.hintName;

  SNameTextField({
    Key? key,
    required this.onEditingComplete,
    this.onChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      child: ObxValue<RxDouble>(
          (leftPadding) => Stack(children: [
                ObxValue<RxString>(
                    (value) => TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                          ],
                          style: DisplayTextStyle.Light.style(color: AppTheme.ItemColor, fontSize: 24),
                          autofocus: true,
                          textInputAction: TextInputAction.go,
                          autocorrect: false,
                          showCursor: false,
                          textCapitalization: TextCapitalization.none,
                          onEditingComplete: () {
                            onEditingComplete(value.value);
                          },
                          onChanged: (val) {
                            // Update Value
                            value(val);

                            // Find Size
                            final size = val.size(DisplayTextStyle.Light, fontSize: 24);
                            final length = size.width;

                            // Update Padding
                            if (length > 0) {
                              leftPadding(length);
                            } else {
                              leftPadding(hint.item1.size(DisplayTextStyle.Light, fontSize: 24).width + 1);
                            }

                            // Callback
                            if (onChanged != null) {
                              onChanged!(val);
                            }
                          },
                          decoration: InputDecoration.collapsed(
                            hintText: hint.item1,
                          ),
                        ),
                    "".obs),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: leftPadding.value),
                  child: Text(
                    ".snr/",
                    style: DisplayTextStyle.Paragraph.style(color: AppTheme.ItemColor, fontSize: 24),
                  ),
                ),
              ]),
          (hint.item1.length * 12.0).obs),
    );
  }
}

class TextUtils {
  /// #### Returns Random Hint Name
  static Tuple<String, String> get hintName {
    switch (DeviceService.device.platform) {
      case Platform.ANDROID:
        return [
          Tuple("Larry", "Page"),
          Tuple("Sergei", "Bring"),
          Tuple("Eric", "Schmidt"),
        ].random();
      case Platform.IOS:
        return [Tuple("Steve", "Jobs"), Tuple("Steve", "Wozniak"), Tuple("Jony", "Ive")].random();
      case Platform.LINUX:
        return Tuple("Linus", "Trovalds");
      case Platform.MACOS:
        return [Tuple("Steve", "Jobs"), Tuple("Jony", "Ive"), Tuple("Andy", "Hertzeld")].random();
      case Platform.WEB:
        return [Tuple("Vitalik", "Buterin"), Tuple("Elon", "Musk"), Tuple("Jeff", "Bezos"), Tuple("Tim", "Berners-Lee")].random();
      case Platform.WINDOWS:
        return [Tuple("Bill", "Gates"), Tuple("Paul", "Allen")].random();
      default:
        return [
          Tuple("Michelangelo", "Buonarroti"),
          Tuple("Kendrick", "Lamar"),
          Tuple("Madam", "Curie"),
          Tuple("Amelia", "Earhart"),
          Tuple("Oprah", "Winfrey"),
          Tuple("Frida", "Kahlo"),
        ].random();
    }
  }
}
