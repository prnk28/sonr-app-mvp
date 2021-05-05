import 'package:flutter/material.dart';

import '../theme.dart';
import 'utility.dart';

class PlainButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String text;
  final Widget child;
  final WidgetPosition iconPosition;
  const PlainButton({Key key, @required this.onPressed, this.icon, this.text, this.child, this.iconPosition = WidgetPosition.Left}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxBool isPressed = false.obs;

    return Container(
      child: ObxValue<RxBool>((pressed) {
        return GestureDetector(
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
              child: AnimatedContainer(
                duration: ButtonUtility.K_BUTTON_DURATION,
                curve: Curves.ease,
                child: ButtonUtility.buildChild(iconPosition, icon, text, child),
              ),
            ));
      }, isPressed),
    );
  }
}

class PlainIconButton extends StatelessWidget {
  final Function onPressed;
  final Widget icon;

  const PlainIconButton({Key key, this.onPressed, this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RxBool isPressed = false.obs;
    return Container(
      child: ObxValue<RxBool>((pressed) {
        return GestureDetector(
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
              child: AnimatedContainer(
                duration: ButtonUtility.K_BUTTON_DURATION,
                curve: Curves.ease,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: icon,
                ),
              ),
            ));
      }, isPressed),
    );
  }
}

class PlainTextButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Widget child;
  final WidgetPosition iconPosition;
  const PlainTextButton({Key key, @required this.onPressed, this.text, this.child, this.iconPosition = WidgetPosition.Left}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxBool isPressed = false.obs;

    return Container(
      child: ObxValue<RxBool>((pressed) {
        return GestureDetector(
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
              child: AnimatedContainer(
                  duration: ButtonUtility.K_BUTTON_DURATION,
                  curve: Curves.ease,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: text.h6_Grey,
                  )),
            ));
      }, isPressed),
    );
  }
}
