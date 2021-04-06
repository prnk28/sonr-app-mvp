import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../theme.dart';


enum ColorButtonType { Primary, Secondary, Neutral, Critical }

class ColorButton extends StatefulWidget {
  static const double K_BORDER_RADIUS = 8;
  static const K_BUTTON_PADDING = const EdgeInsets.symmetric(horizontal: 24, vertical: 8);
  static const K_BUTTON_DURATION = Duration(milliseconds: 100);

  final EdgeInsets margin;
  final EdgeInsets padding;
  final Widget child;
  final Decoration decoration;
  final Function onPressed;
  final Function onLongPressed;
  final String tooltip;
  final bool isEnabled;
  final double width;
  final double pressedScale;

  const ColorButton({
    Key key,
    @required this.onPressed,
    @required this.child,
    @required this.decoration,
    @required this.pressedScale,
    this.margin,
    this.padding,
    this.onLongPressed,
    this.tooltip,
    this.isEnabled = true,
    this.width,
  }) : super(key: key);

  // @ Primary Button //
  factory ColorButton.primary({
    @required Function onPressed,
    Gradient gradient,
    Function onLongPressed,
    Widget child,
    String tooltip,
    EdgeInsets padding,
    EdgeInsets margin,
    SonrIcon icon,
    String text,
    double width,
    WidgetPosition iconPosition = WidgetPosition.Left,
  }) {
    // Build Decoration
    BoxDecoration decoration = BoxDecoration(
        gradient: gradient != null ? gradient : SonrPalette.primary(),
        borderRadius: BorderRadius.circular(K_BORDER_RADIUS),
        boxShadow: [BoxShadow(offset: Offset(0, 4), color: SonrPalette.Primary.withOpacity(0.4), blurRadius: 12, spreadRadius: 4)]);

    // Build Child
    return ColorButton(
        decoration: decoration,
        onPressed: onPressed,
        child: _buildChild(iconPosition, icon, text, child),
        tooltip: tooltip,
        width: width,
        padding: padding,
        margin: margin,
        onLongPressed: onLongPressed,
        pressedScale: 0.95);
  }

  // @ Secondary Button //
  factory ColorButton.secondary({
    @required Function onPressed,
    Color color,
    Function onLongPressed,
    Widget child,
    String tooltip,
    EdgeInsets padding,
    EdgeInsets margin,
    double width,
    SonrIcon icon,
    String text,
    WidgetPosition iconPosition = WidgetPosition.Left,
  }) {
    // Decoration
    BoxDecoration decoration = BoxDecoration(
      color: color != null ? color : SonrPalette.Secondary,
      borderRadius: BorderRadius.circular(K_BORDER_RADIUS),
    );

    // Build Child
    return ColorButton(
        decoration: decoration,
        onPressed: onPressed,
        width: width,
        child: _buildChild(iconPosition, icon, text, child),
        tooltip: tooltip,
        padding: padding,
        margin: margin,
        onLongPressed: onLongPressed,
        pressedScale: 0.98);
  }

  // @ Neutral Button //
  factory ColorButton.neutral({
    @required Function onPressed,
    Function onLongPressed,
    Widget child,
    String tooltip,
    EdgeInsets padding,
    EdgeInsets margin,
    SonrIcon icon,
    double width,
    String text,
    WidgetPosition iconPosition = WidgetPosition.Left,
  }) {
    // Decoration
    BoxDecoration decoration = BoxDecoration(
      color: SonrColor.Neutral,
      borderRadius: BorderRadius.circular(K_BORDER_RADIUS),
    );

    // Build Child
    return ColorButton(
        decoration: decoration,
        onPressed: onPressed,
        width: width,
        child: _buildChild(iconPosition, icon, text, child),
        tooltip: tooltip,
        padding: padding,
        margin: margin,
        onLongPressed: onLongPressed,
        pressedScale: 0.98);
  }

  // @ Helper Method to Build Icon View //
  static Widget _buildChild(WidgetPosition iconPosition, SonrIcon icon, String text, Widget child) {
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
  _ColorButtonState createState() => _ColorButtonState();
}

class _ColorButtonState extends State<ColorButton> {
  bool hasFinishedAnimationDown = false;
  bool hasFinishedLongAnimationDown = false;
  bool hasTapUp = false;
  bool hasLongTapUp = false;
  bool pressed = false;
  bool longPressed = false;
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
        if (!pressed && !longPressed) {
          _handlePress();
        }
      },
      onTapUp: (details) {
        widget.onPressed();
        hasTapUp = true;
        _resetIfTapUp();
      },
      onLongPressStart: (details) {
        hasLongTapUp = false;
        if (!longPressed) {
          _handleLongPress();
        }
      },
      onLongPressUp: () {
        if (widget.onLongPressed != null) {
          widget.onLongPressed();
        }
        hasLongTapUp = true;
        _resetIfLongTapUp();
      },
      onTapCancel: () {
        hasTapUp = true;
        _resetIfTapUp();
      },
      child: AnimatedScale(
        scale: this.pressed ? widget.pressedScale : 1.0,
        child: AnimatedContainer(
          decoration: widget.decoration,
          margin: widget.margin ?? const EdgeInsets.all(0),
          duration: ColorButton.K_BUTTON_DURATION,
          curve: Curves.ease,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: widget.child,
        ),
      ),
    );
  }

  Future<void> _handlePress() async {
    hasFinishedAnimationDown = false;
    setState(() {
      pressed = true;
    });

    await Future.delayed(ColorButton.K_BUTTON_DURATION); //wait until animation finished
    hasFinishedAnimationDown = true;

    //haptic vibration
    HapticFeedback.mediumImpact();
    _resetIfTapUp();
  }

  //used to stay pressed if no tap up
  void _resetIfTapUp() {
    if (hasFinishedAnimationDown == true && hasTapUp == true && !hasDisposed) {
      setState(() {
        pressed = false;

        hasFinishedAnimationDown = false;
        hasTapUp = false;
      });
    }
  }

  Future<void> _handleLongPress() async {
    hasFinishedLongAnimationDown = false;
    setState(() {
      longPressed = true;
    });

    await Future.delayed(ColorButton.K_BUTTON_DURATION); //wait until animation finished
    hasFinishedLongAnimationDown = true;

    //haptic vibration
    HapticFeedback.heavyImpact();
    _resetIfLongTapUp();
  }

  void _resetIfLongTapUp() {
    if (hasFinishedLongAnimationDown == true && hasLongTapUp == true && !hasDisposed) {
      setState(() {
        longPressed = false;

        hasFinishedLongAnimationDown = false;
        hasLongTapUp = false;
      });
    }
  }
}
