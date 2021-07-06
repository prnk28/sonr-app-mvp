import 'package:flutter/services.dart';
import '../style.dart';
import 'utility.dart';

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
      gradient: SonrGradient.Neutral,
      borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
      boxShadow: AppTheme.boxShadow,
    );

    // Confirm Decoration
    BoxDecoration confirmDecoration = BoxDecoration(
      gradient: SonrGradient.Primary,
      borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
      boxShadow: AppTheme.boxShadow,
    );

    // Complete Decoration
    BoxDecoration completeDecoration = BoxDecoration(
      gradient: SonrGradient.Tertiary,
      borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
      boxShadow: AppTheme.boxShadow,
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
      completeChild: ButtonUtility.buildCompleteChild(SonrIcons.CheckShield, "Saved!"),
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
      gradient: SonrGradient.Neutral,
      borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
      boxShadow: AppTheme.boxShadow,
    );

    // Confirm Decoration
    BoxDecoration confirmDecoration = BoxDecoration(
      gradient: SonrGradient.Primary,
      borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
      boxShadow: AppTheme.boxShadow,
    );

    // Complete Decoration
    BoxDecoration completeDecoration = BoxDecoration(
      gradient: SonrGradient.Critical,
      borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
      boxShadow: AppTheme.boxShadow,
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
      completeChild: ButtonUtility.buildCompleteChild(SonrIcons.Trash, "Deleted."),
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
