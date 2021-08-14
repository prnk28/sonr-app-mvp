import 'package:flutter/material.dart' hide AnimatedScale;

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
                  duration: 300.milliseconds,
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
              child: AnimatedScale(scale: pressed.value ? 0.95 : 1.0, duration: 400.milliseconds, child: Obx(() => data.value.build()))),
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
        AppColor.Blue,
      );

  factory DynamicSolidButtonData.complete() => DynamicSolidButtonData(
        "Sent!",
        AppTheme.GreyColor,
        AppColor.Green,
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

enum ConfirmButtonType { Save, Delete }

class ConfirmButton extends StatelessWidget {
  final ConfirmButtonType type;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Widget defaultChild;
  final Widget confirmChild;
  final Widget completeChild;
  final BoxDecoration defaultDecoration;
  final BoxDecoration confirmDecoration;
  final BoxDecoration completeDecoration;
  final Function onConfirmed;
  final double width;

  const ConfirmButton({
    Key? key,
    required this.onConfirmed,
    required this.defaultChild,
    required this.confirmChild,
    required this.completeChild,
    required this.defaultDecoration,
    required this.confirmDecoration,
    required this.completeDecoration,
    required this.type,
    this.margin,
    this.padding,
    this.width = 200,
  }) : super(key: key);

  // @ Save Button //
  factory ConfirmButton.save({
    required Function onConfirmed,
    // Default
    Widget? defaultChild,
    IconData? defaultIcon,
    String? defaultText,

    // Confirm
    Widget? confirmChild,
    IconData? confirmIcon,
    String? confirmText,

    // Complete
    Widget? completeChild,
    IconData? completeIcon,
    String? completeText,

    // Properties
    String? tooltip,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double width = 200,
    WidgetPosition iconPosition = WidgetPosition.Left,
  }) {
    // Default Decoration
    BoxDecoration defaultDecoration = BoxDecoration(
      color: CGUtility.hex("#a2a2a2"),
      borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
      boxShadow: AppTheme.RectBoxShadow,
    );

    // Confirm Decoration
    BoxDecoration confirmDecoration = BoxDecoration(
      gradient: DesignGradients.MalibuBeach,
      borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
      boxShadow: AppTheme.RectBoxShadow,
    );

    // Complete Decoration
    BoxDecoration completeDecoration = BoxDecoration(
      gradient: DesignGradients.ItmeoBranding,
      borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
      boxShadow: AppTheme.RectBoxShadow,
    );

    // Build Child
    return ConfirmButton(
      type: ConfirmButtonType.Save,
      defaultDecoration: defaultDecoration,
      confirmDecoration: confirmDecoration,
      completeDecoration: completeDecoration,
      onConfirmed: onConfirmed,
      defaultChild: ButtonUtility.buildChild(iconPosition, defaultIcon, defaultText, defaultChild),
      confirmChild: ButtonUtility.buildChild(iconPosition, confirmIcon, confirmText, confirmChild),
      completeChild: ButtonUtility.buildCompleteChild(SimpleIcons.CheckShield, "Saved!"),
      width: width,
      padding: padding,
      margin: margin,
    );
  }

  // @ Delete Button //
  factory ConfirmButton.delete({
    required Function onConfirmed,
    // Default
    Widget? defaultChild,
    IconData? defaultIcon,
    String? defaultText,

    // Confirm
    Widget? confirmChild,
    IconData? confirmIcon,
    String? confirmText,

    // Complete
    Widget? completeChild,
    IconData? completeIcon,
    String? completeText,

    // Properties
    String? tooltip,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double width = 200,
    WidgetPosition iconPosition = WidgetPosition.Left,
  }) {
    // Default Decoration
    BoxDecoration defaultDecoration = BoxDecoration(
      color: CGUtility.hex("#a2a2a2"),
      borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
      boxShadow: AppTheme.RectBoxShadow,
    );

    // Confirm Decoration
    BoxDecoration confirmDecoration = BoxDecoration(
      gradient: DesignGradients.MalibuBeach,
      borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
      boxShadow: AppTheme.RectBoxShadow,
    );

    // Complete Decoration
    BoxDecoration completeDecoration = BoxDecoration(
      gradient: DesignGradients.ItmeoBranding,
      borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
      boxShadow: AppTheme.RectBoxShadow,
    );

    // Build Child
    return ConfirmButton(
      type: ConfirmButtonType.Delete,
      defaultDecoration: defaultDecoration,
      confirmDecoration: confirmDecoration,
      completeDecoration: completeDecoration,
      onConfirmed: onConfirmed,
      defaultChild: ButtonUtility.buildChild(iconPosition, defaultIcon, defaultText, defaultChild),
      confirmChild: ButtonUtility.buildChild(iconPosition, confirmIcon, confirmText, confirmChild),
      completeChild: ButtonUtility.buildCompleteChild(SimpleIcons.Trash, "Deleted."),
      width: width,
      padding: padding,
      margin: margin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetX<_ConfirmButtonController>(
      init: _ConfirmButtonController(onConfirmed, type),
      global: false,
      autoRemove: false,
      builder: (controller) {
        return GestureDetector(
          onTapDown: controller.onTapDown,
          onTapCancel: controller.onTapCancel,
          child: AnimatedScale(
            scale: controller.status.value.scale,
            duration: 275.milliseconds,
            child: Container(
              decoration: _buildDecoration(controller.status.value),
              margin: margin ?? const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: AnimatedSlider.slideUp(child: _buildChild(controller.status.value)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChild(ConfirmStatus status) {
    if (status.isInitial) {
      return Container(child: defaultChild, key: ValueKey<int>(0));
    } else if (status.isPending) {
      return Container(child: confirmChild, key: ValueKey<int>(1));
    } else {
      return Container(child: completeChild, key: ValueKey<int>(2));
    }
  }

  BoxDecoration _buildDecoration(ConfirmStatus status) {
    if (status.isInitial) {
      return defaultDecoration;
    } else if (status.isPending) {
      return confirmDecoration;
    } else {
      return completeDecoration;
    }
  }
}

enum ConfirmStatus { Default, PressDown, PressUp, ConfirmDown, ConfirmUp }

extension ConfirmStatusUtil on ConfirmStatus {
  bool get isInitial => this == ConfirmStatus.Default || this == ConfirmStatus.PressDown;
  bool get isPending => this == ConfirmStatus.PressUp || this == ConfirmStatus.ConfirmDown;
  bool get isComplete => this == ConfirmStatus.ConfirmUp;
  bool get isPressed => this == ConfirmStatus.PressDown || this == ConfirmStatus.ConfirmDown;
  bool get isUp => this == ConfirmStatus.PressUp || this == ConfirmStatus.ConfirmUp;
  double get scale => this.isPressed ? 0.95 : 1.0;
}

class _ConfirmButtonController extends GetxController {
  final ConfirmButtonType type;
  final Function onConfirmed;
  final status = ConfirmStatus.Default.obs;

  _ConfirmButtonController(this.onConfirmed, this.type);

  void onTapDown(TapDownDetails details) {
    if (status.value.isInitial) {
      _handlePress();
    } else {
      _handleConfirm();
    }
  }

  void onTapCancel() {
    if (!isClosed) {
      if (status.value.isPending) {
        status(ConfirmStatus.PressUp);
      } else {
        status(ConfirmStatus.Default);
      }
    }
  }

  Future<void> _handlePress() async {
    await _updateStatus(
        downStatus: ConfirmStatus.PressDown,
        upStatus: ConfirmStatus.PressUp,
        onTapUp: () async {
          await HapticFeedback.mediumImpact();
        });
  }

  Future<void> _handleConfirm() async {
    await _updateStatus(
        downStatus: ConfirmStatus.ConfirmDown,
        upStatus: ConfirmStatus.ConfirmUp,
        onTapUp: () async {
          await HapticFeedback.heavyImpact();
          // Play Sound
          if (type == ConfirmButtonType.Save) {
            await Sound.Confirmed.play();
          } else if (type == ConfirmButtonType.Delete) {
            await Sound.Deleted.play();
          }
          await Future.delayed(ButtonUtility.K_CONFIRM_DURATION); //wait until animation finished
          onConfirmed();
        });
  }

  Future<void> _updateStatus({required ConfirmStatus downStatus, required ConfirmStatus upStatus, required Function onTapUp}) async {
    if (!isClosed) {
      status(downStatus);
      await Future.delayed(ButtonUtility.K_BUTTON_DURATION); //wait until animation finished
      status(upStatus);
      onTapUp();
    }
  }
}

class ComplexButton extends StatelessWidget {
  /// Function called on Tap Up
  final Function onPressed;

  /// Widget for Action Icon: Max Size 32
  final ComplexIcons type;

  /// String for Text Below Button
  final String label;

  /// Circle Size
  final double size;

  /// Text Label Size
  final double fontSize;

  /// Text Label Color
  final Color? textColor;

  const ComplexButton({
    Key? key,
    required this.onPressed,
    required this.type,
    required this.label,
    this.size = 100,
    this.fontSize = 20,
    this.textColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ObxValue<RxBool>(
              (isPressed) => GestureDetector(
                  onTapDown: (details) => isPressed(true),
                  onTapCancel: () => isPressed(false),
                  onTapUp: (details) async {
                    isPressed(false);
                    await HapticFeedback.mediumImpact();
                    Future.delayed(ButtonUtility.K_BUTTON_DURATION, () {
                      onPressed();
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedScale(
                        scale: isPressed.value ? 0.9 : 1.0,
                        duration: 275.milliseconds,
                        child: Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            gradient: AppGradients.Foreground,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(24),
                        ),
                      ),
                      AnimatedScale(
                        scale: isPressed.value ? 1.1 : 1.0,
                        duration: 275.milliseconds,
                        child: type.dots(
                          width: size * 0.5,
                          height: size * 0.5,
                        ),
                      )
                    ],
                  )),
              false.obs),

          // Build Label
          Get.isDarkMode
              ? label.light(
                  color: textColor ?? AppColor.White.withOpacity(0.8),
                  fontSize: fontSize,
                )
              : label.light(
                  color: textColor ?? AppColor.Black.withOpacity(0.8),
                  fontSize: fontSize,
                ),
        ],
      ),
    );
  }
}
