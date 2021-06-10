import 'package:flutter/material.dart';
import 'package:sonr_app/style.dart';
import 'package:styled_widget/styled_widget.dart';

class ToggleSwitch extends StatelessWidget {
  final RxBool toggleState;
  static const Color colorRed = Colors.red;
  static const Color colorGreen = Color(0xff46E387);

  ToggleSwitch({Key? key, required this.toggleState}) : super(key: key);

  final _styledBox = ({
    required Widget child,
    required bool toggleState,
  }) =>
      child.padding(all: 10).constrained(height: 50, width: 90).ripple(splashColor: Colors.white.withOpacity(0.1)).clipRRect(all: 30).decorated(
            color: toggleState ? colorGreen : colorRed,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: toggleState ? colorGreen.withOpacity(0.3) : colorRed.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 15),
              ),
            ],
            animate: true,
          );

  final _styledOuterCircle = ({
    required Widget child,
    required bool toggleState,
  }) =>
      child
          .decorated(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          )
          .constrained(width: toggleState ? 10 : 30, height: 30, animate: true)
          .padding(right: toggleState ? 10 : 0, animate: true)
          .alignment(
            toggleState ? Alignment.centerRight : Alignment.centerLeft,
            animate: true,
          );

  final _styledInnerCircle = ({
    required bool toggleState,
  }) =>
      Styled.widget()
          .decorated(
            color: toggleState ? colorGreen : colorRed,
            borderRadius: BorderRadius.circular(6),
            animate: true,
          )
          .constrained(width: toggleState ? 0 : 12, height: 12, animate: true)
          .alignment(Alignment.center);

  @override
  Widget build(BuildContext context) {
    return ObxValue<RxBool>(
        (toggled) => _styledInnerCircle(toggleState: toggled.value)
            .parent(({required Widget child}) => _styledOuterCircle(child: child, toggleState: toggleState.value))
            .parent(({required Widget child}) => _styledBox(child: child, toggleState: toggled.value))
            .gestures(onTap: () => toggled(!toggled.value))
            .alignment(Alignment.center)
            .backgroundColor(
              toggleState.value ? Color(0xffEEF6F1) : Color(0xffF7EEEE),
              animate: true,
            )
            .animate(Duration(milliseconds: 300), Curves.easeOut),
        toggleState);
  }
}
