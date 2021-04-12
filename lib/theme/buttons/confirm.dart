import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../theme.dart';
import 'utility.dart';

enum ConfirmButtonType { Save, Delete }

class ConfirmButton extends StatefulWidget {
  static const double K_BORDER_RADIUS = 8;
  static const K_BUTTON_PADDING = EdgeInsets.symmetric(horizontal: 24, vertical: 8);
  static const K_BUTTON_DURATION = Duration(milliseconds: 100);
  final ConfirmButtonType type;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Widget defaultChild;
  final Widget confirmChild;
  final Widget completeChild;
  final Decoration defaultDecoration;
  final Decoration confirmDecoration;
  final Decoration completeDecoration;
  final Function onConfirmed;
  final String tooltip;
  final double width;
  final double pressedScale;

  const ConfirmButton({
    Key key,
    @required this.onConfirmed,
    @required this.defaultChild,
    @required this.confirmChild,
    @required this.completeChild,
    @required this.defaultDecoration,
    @required this.confirmDecoration,
    @required this.completeDecoration,
    @required this.pressedScale,
    @required this.type,
    this.margin,
    this.padding,
    this.tooltip,
    this.width,
  }) : super(key: key);

  // @ Save Button //
  factory ConfirmButton.save({
    @required Function onConfirmed,
    // Default
    Widget defaultChild,
    SonrIcon defaultIcon,
    String defaultText,

    // Confirm
    Widget confirmChild,
    SonrIcon confirmIcon,
    String confirmText,

    // Complete
    Widget completeChild,
    SonrIcon completeIcon,
    String completeText,

    // Properties
    String tooltip,
    EdgeInsets padding,
    EdgeInsets margin,
    double width,
    WidgetPosition iconPosition = WidgetPosition.Left,
  }) {
    // Default Decoration
    BoxDecoration defaultDecoration = BoxDecoration(
        gradient: SonrPalette.neutral(),
        borderRadius: BorderRadius.circular(K_BORDER_RADIUS),
        boxShadow: [BoxShadow(offset: Offset(0, 4), color: SonrPalette.Primary.withOpacity(0.4), blurRadius: 12, spreadRadius: 4)]);

    // Confirm Decoration
    BoxDecoration confirmDecoration = BoxDecoration(
        gradient: SonrPalette.primary(),
        borderRadius: BorderRadius.circular(K_BORDER_RADIUS),
        boxShadow: [BoxShadow(offset: Offset(0, 4), color: SonrPalette.Primary.withOpacity(0.4), blurRadius: 12, spreadRadius: 4)]);

    // Complete Decoration
    BoxDecoration completeDecoration = BoxDecoration(
        gradient: SonrPalette.tertiary(),
        borderRadius: BorderRadius.circular(K_BORDER_RADIUS),
        boxShadow: [BoxShadow(offset: Offset(0, 4), color: SonrPalette.Primary.withOpacity(0.4), blurRadius: 12, spreadRadius: 4)]);

    // Build Child
    return ConfirmButton(
      type: ConfirmButtonType.Save,
      defaultDecoration: defaultDecoration,
      confirmDecoration: confirmDecoration,
      completeDecoration: completeDecoration,
      onConfirmed: onConfirmed,
      defaultChild: ButtonUtility.buildChild(iconPosition, defaultIcon, defaultText, defaultChild),
      confirmChild: ButtonUtility.buildChild(iconPosition, confirmIcon, confirmText, confirmChild),
      completeChild: ButtonUtility.buildChild(WidgetPosition.Left, SonrIcon.normal(Icons.delete_forever), "Saved!", null),
      tooltip: tooltip,
      width: width,
      padding: padding,
      margin: margin,
      pressedScale: 0.95,
    );
  }

  // @ Delete Button //
  factory ConfirmButton.delete({
    @required Function onConfirmed,
    // Default
    Widget defaultChild,
    SonrIcon defaultIcon,
    String defaultText,

    // Confirm
    Widget confirmChild,
    SonrIcon confirmIcon,
    String confirmText,

    // Complete
    Widget completeChild,
    SonrIcon completeIcon,
    String completeText,

    // Properties
    String tooltip,
    EdgeInsets padding,
    EdgeInsets margin,
    double width,
    WidgetPosition iconPosition = WidgetPosition.Left,
  }) {
    // Default Decoration
    BoxDecoration defaultDecoration = BoxDecoration(
        gradient: SonrPalette.neutral(),
        borderRadius: BorderRadius.circular(K_BORDER_RADIUS),
        boxShadow: [BoxShadow(offset: Offset(0, 4), color: SonrPalette.Primary.withOpacity(0.4), blurRadius: 12, spreadRadius: 4)]);

    // Confirm Decoration
    BoxDecoration confirmDecoration = BoxDecoration(
        gradient: SonrPalette.primary(),
        borderRadius: BorderRadius.circular(K_BORDER_RADIUS),
        boxShadow: [BoxShadow(offset: Offset(0, 4), color: SonrPalette.Primary.withOpacity(0.4), blurRadius: 12, spreadRadius: 4)]);

    // Complete Decoration
    BoxDecoration completeDecoration = BoxDecoration(
        gradient: SonrPalette.critical(),
        borderRadius: BorderRadius.circular(K_BORDER_RADIUS),
        boxShadow: [BoxShadow(offset: Offset(0, 4), color: SonrPalette.Primary.withOpacity(0.4), blurRadius: 12, spreadRadius: 4)]);

    // Build Child
    return ConfirmButton(
      type: ConfirmButtonType.Delete,
      defaultDecoration: defaultDecoration,
      confirmDecoration: confirmDecoration,
      completeDecoration: completeDecoration,
      onConfirmed: onConfirmed,
      defaultChild: ButtonUtility.buildChild(iconPosition, defaultIcon, defaultText, defaultChild),
      confirmChild: ButtonUtility.buildChild(iconPosition, confirmIcon, confirmText, confirmChild),
      completeChild: ButtonUtility.buildChild(WidgetPosition.Left, SonrIcon.normal(Icons.delete_forever), "Deleted.", null),
      tooltip: tooltip,
      width: width,
      padding: padding,
      margin: margin,
      pressedScale: 0.95,
    );
  }

  @override
  _ConfirmButtonState createState() => _ConfirmButtonState();
}

enum ConfirmStatus { Default, Pressed, Pending, Confirmed, Done }

extension ConfirmStatusUtil on ConfirmStatus {
  bool get isDefault => this == ConfirmStatus.Default;
  bool get isPressed => this == ConfirmStatus.Pressed;
  bool get isPending => this == ConfirmStatus.Pending;
  bool get isConfirmed => this == ConfirmStatus.Confirmed;
  bool get isDone => this == ConfirmStatus.Done;
}

class _ConfirmButtonState extends State<ConfirmButton> {
  bool hasFinishedAnimationDown = false;
  bool hasFinishedLongAnimationDown = false;
  bool hasTapUp = false;
  ConfirmStatus status = ConfirmStatus.Default;
  bool hasDisposed = false;

  @override
  void dispose() {
    super.dispose();
    hasDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    final result = _build(context);
    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip,
        child: result,
      );
    } else {
      return result;
    }
  }

  Widget _build(BuildContext context) {
    return GestureDetector(
      onTapDown: (detail) {
        hasTapUp = false;
        if (status.isDefault || status.isPressed) {
          _handlePress();
        } else {
          _handleConfirm();
        }
      },
      onTapUp: (details) {
        hasTapUp = true;
        _resetIfTapUp(status);
      },
      onTapCancel: () {
        hasTapUp = true;
        _resetIfTapUp(status);
      },
      child: AnimatedScale(
        scale: status.isPressed ? widget.pressedScale : 1.0,
        child: AnimatedContainer(
          decoration: _buildDecoration(),
          margin: widget.margin ?? const EdgeInsets.all(0),
          duration: ConfirmButton.K_BUTTON_DURATION,
          curve: Curves.ease,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: AnimatedSlideSwitcher.slideUp(child: _buildChild()),
        ),
      ),
    );
  }

  Widget _buildChild() {
    if (status.isDefault || status.isPressed) {
      return Container(child: widget.defaultChild, key: ValueKey<ConfirmStatus>(ConfirmStatus.Default));
    } else if (status.isPending || status.isConfirmed) {
      return Container(child: widget.confirmChild, key: ValueKey<ConfirmStatus>(ConfirmStatus.Confirmed));
    } else {
      return widget.completeChild;
    }
  }

  BoxDecoration _buildDecoration() {
    if (status.isDefault || status.isPressed) {
      return widget.defaultDecoration;
    } else if (status.isPending || status.isConfirmed) {
      return widget.confirmDecoration;
    } else {
      return widget.completeDecoration;
    }
  }

  Future<void> _handlePress() async {
    hasFinishedAnimationDown = false;
    setState(() {
      status = ConfirmStatus.Pressed;
    });

    await Future.delayed(ConfirmButton.K_BUTTON_DURATION); //wait until animation finished
    hasFinishedAnimationDown = true;

    // Haptic Feedback
    await HapticFeedback.mediumImpact();
    _resetIfTapUp(ConfirmStatus.Pending);
  }

  Future<void> _handleConfirm() async {
    hasFinishedAnimationDown = false;
    setState(() {
      status = ConfirmStatus.Confirmed;
    });

    await Future.delayed(ConfirmButton.K_BUTTON_DURATION); //wait until animation finished
    hasFinishedAnimationDown = true;

    // Haptic Feedback
    await HapticFeedback.heavyImpact();
    _resetIfTapUp(ConfirmStatus.Done);
    await Future.delayed(ConfirmButton.K_BUTTON_DURATION * 2); //wait until animation finished

    // Play Sound
    if (widget.type == ConfirmButtonType.Save) {
      DeviceService.playSound(type: UISoundType.Confirmed);
    } else if (widget.type == ConfirmButtonType.Delete) {
      DeviceService.playSound(type: UISoundType.Deleted);
    }

    widget.onConfirmed();
  }

  //used to stay pressed if no tap up
  void _resetIfTapUp(ConfirmStatus newStatus) {
    if (hasFinishedAnimationDown == true && hasTapUp == true && !hasDisposed) {
      setState(() {
        status = newStatus;

        hasFinishedAnimationDown = false;
        hasTapUp = false;
      });
    }
  }
}
