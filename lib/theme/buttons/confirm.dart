import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../theme.dart';

class ConfirmButton extends StatefulWidget {
  static const double K_BORDER_RADIUS = 8;
  static const K_BUTTON_PADDING = const EdgeInsets.symmetric(horizontal: 24, vertical: 8);
  static const K_BUTTON_DURATION = Duration(milliseconds: 100);

  final EdgeInsets margin;
  final EdgeInsets padding;
  final Widget defaultChild;
  final Widget confirmChild;
  final Decoration defaultDecoration;
  final Decoration confirmDecoration;
  final Function onConfirmed;
  final String tooltip;
  final double width;
  final double pressedScale;

  const ConfirmButton({
    Key key,
    @required this.onConfirmed,
    @required this.defaultChild,
    @required this.confirmChild,
    @required this.defaultDecoration,
    @required this.confirmDecoration,
    @required this.pressedScale,
    this.margin,
    this.padding,
    this.tooltip,
    this.width,
  }) : super(key: key);

  // @ Delete Button //
  factory ConfirmButton.delete({
    @required Function onConfirmed,
    Widget defaultChild,
    SonrIcon defaultIcon,
    String defaultText,
    Widget confirmChild,
    SonrIcon confirmIcon,
    String confirmText,
    String tooltip,
    EdgeInsets padding,
    EdgeInsets margin,
    double width,
    WidgetPosition iconPosition = WidgetPosition.Left,
  }) {
    // Build Decoration
    BoxDecoration defaultDecoration = BoxDecoration(
        gradient: SonrPalette.neutral(),
        borderRadius: BorderRadius.circular(K_BORDER_RADIUS),
        boxShadow: [BoxShadow(offset: Offset(0, 4), color: SonrPalette.Primary.withOpacity(0.4), blurRadius: 12, spreadRadius: 4)]);

    BoxDecoration confirmDecoration = BoxDecoration(
        gradient: SonrPalette.primary(),
        borderRadius: BorderRadius.circular(K_BORDER_RADIUS),
        boxShadow: [BoxShadow(offset: Offset(0, 4), color: SonrPalette.Primary.withOpacity(0.4), blurRadius: 12, spreadRadius: 4)]);

    // Build Child
    return ConfirmButton(
        defaultDecoration: defaultDecoration,
        confirmDecoration: confirmDecoration,
        onConfirmed: onConfirmed,
        defaultChild: buildChild(iconPosition, defaultIcon, defaultText, defaultChild),
        confirmChild: buildChild(iconPosition, confirmIcon, confirmText, confirmChild),
        tooltip: tooltip,
        width: width,
        padding: padding,
        margin: margin,
        pressedScale: 0.95);
  }

  // @ Helper Method to Build Icon View //
  static Widget buildChild(WidgetPosition iconPosition, SonrIcon icon, String text, Widget child) {
    if (child != null) {
      return child;
    } else if (icon != null && text == null) {
      return Container(padding: EdgeInsets.all(8), child: icon);
    } else if (text != null && icon == null) {
      return Container(padding: EdgeInsets.all(8), child: _buildText(text));
    } else if (text != null && icon != null) {
      switch (iconPosition) {
        case WidgetPosition.Left:
          return Container(
              padding: EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_buildIcon(icon), Padding(padding: EdgeInsets.all(4)), _buildText(text)]));
        case WidgetPosition.Right:
          return Container(
              padding: EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_buildText(text), Padding(padding: EdgeInsets.all(4)), _buildIcon(icon)]));
        case WidgetPosition.Top:
          return Container(
              padding: EdgeInsets.all(8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_buildIcon(icon), Padding(padding: EdgeInsets.all(4)), _buildText(text)]));
        case WidgetPosition.Bottom:
          return Container(
              padding: EdgeInsets.all(8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_buildText(text), Padding(padding: EdgeInsets.all(4)), _buildIcon(icon)]));
        case WidgetPosition.Center:
          return icon;
        default:
          return Container();
      }
    } else {
      return Container();
    }
  }

  static Widget _buildIcon(SonrIcon icon) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 2.0,
          child: Icon(icon.data, color: SonrColor.Black.withOpacity(0.5), size: 20),
        ),
        Icon(icon.data, color: Colors.white, size: 20),
      ],
    );
  }

  static Widget _buildText(String text) {
    return Text(text,
        overflow: TextOverflow.fade,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.white,
            shadows: [Shadow(blurRadius: 4, color: SonrColor.Black.withOpacity(0.5))]));
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
      return ConfirmButton.buildChild(WidgetPosition.Left, SonrIcon.normal(Icons.delete_forever), "Deleted.", null);
    }
  }

  BoxDecoration _buildDecoration() {
    if (status.isDefault || status.isPressed) {
      return widget.defaultDecoration;
    } else if (status.isPending || status.isConfirmed) {
      return widget.confirmDecoration;
    } else {
      return BoxDecoration(
          gradient: SonrPalette.critical(),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(offset: Offset(0, 4), color: SonrPalette.Primary.withOpacity(0.4), blurRadius: 12, spreadRadius: 4)]);
    }
  }

  Future<void> _handlePress() async {
    hasFinishedAnimationDown = false;
    setState(() {
      status = ConfirmStatus.Pressed;
    });

    await Future.delayed(ConfirmButton.K_BUTTON_DURATION); //wait until animation finished
    hasFinishedAnimationDown = true;

    //haptic vibration
    HapticFeedback.mediumImpact();
    _resetIfTapUp(ConfirmStatus.Pending);
  }

  Future<void> _handleConfirm() async {
    hasFinishedAnimationDown = false;
    setState(() {
      status = ConfirmStatus.Confirmed;
    });

    await Future.delayed(ConfirmButton.K_BUTTON_DURATION); //wait until animation finished
    hasFinishedAnimationDown = true;

    //haptic vibration
    HapticFeedback.heavyImpact();
    _resetIfTapUp(ConfirmStatus.Done);
    await Future.delayed(ConfirmButton.K_BUTTON_DURATION); //wait until animation finished
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
