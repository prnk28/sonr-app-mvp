import 'package:flutter/material.dart';

import '../style.dart';
import 'utility.dart';

class SolidButton extends StatelessWidget {
  /// Button Text to Display
  final String title;

  /// Color of Button
  final Color color;

  /// Color of Text
  final Color textColor;

  /// Function called on Tap Up
  final void Function() onPressed;

  const SolidButton({
    Key? key,
    required this.title,
    required this.color,
    required this.onPressed,
    required this.textColor,
  }) : super(key: key);

  factory SolidButton.black({required String title, required void Function() onPressed}) {
    return SolidButton(
      title: title,
      color: Color(0xff3B3B3B),
      onPressed: onPressed,
      textColor: Color(0xffFFFFFF),
    );
  }

  factory SolidButton.grey({required String title, required void Function() onPressed}) {
    return SolidButton(
      title: title,
      color: AppTheme.GreyColor,
      onPressed: onPressed,
      textColor: Color(0xff000000),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ObxValue<RxBool>(
          (pressed) => GestureDetector(
              onTapDown: (details) {
                pressed(true);
              },
              onTapUp: (details) {
                pressed(false);
                Future.delayed(ButtonUtility.K_BUTTON_DURATION, () {
                  onPressed();
                });
              },
              child: AnimatedScale(
                  scale: pressed.value ? 0.95 : 1.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ButtonUtility.buildNeutralText(title, textColor),
                  ))),
          false.obs),
    );
  }
}

class DynamicSolidButton extends StatelessWidget {
  /// Button Text to Display
  final Rx<DynamicSolidButtonData> data;

  /// Function called on Tap Up
  final void Function() onPressed;

  const DynamicSolidButton({
    Key? key,
    required this.data,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ObxValue<RxBool>(
          (pressed) => GestureDetector(
              onTapDown: (details) {
                pressed(true);
              },
              onTapUp: (details) {
                pressed(false);
                Future.delayed(ButtonUtility.K_BUTTON_DURATION, () {
                  onPressed();
                });
              },
              child: AnimatedScale(scale: pressed.value ? 0.95 : 1.0, child: Obx(() => data.value.build()))),
          false.obs),
    );
  }
}

class DynamicSolidButtonData {
  /// Button Text to Display
  final String title;

  /// Color of Button
  final Color color;

  /// Color of Text
  final Color textColor;

  DynamicSolidButtonData(
    this.title,
    this.textColor,
    this.color,
  );

  factory DynamicSolidButtonData.invite() => DynamicSolidButtonData(
        "Invite",
        Color(0xff000000),
        AppTheme.GreyColor,
      );

  factory DynamicSolidButtonData.pending() => DynamicSolidButtonData(
        "Pending",
        AppTheme.GreyColor,
        Colors.orange,
      );

  factory DynamicSolidButtonData.inProgress() => DynamicSolidButtonData(
        "In Progress",
        AppTheme.GreyColor,
        SonrColor.Primary,
      );

  factory DynamicSolidButtonData.complete() => DynamicSolidButtonData(
        "Sent!",
        AppTheme.GreyColor,
        SonrColor.Tertiary,
      );

  Widget build() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ButtonUtility.buildNeutralText(title, textColor),
    );
  }
}
