import 'design.dart';

class DesignButton {
  NeumorphicButton appBarLeadingButton(IconData iconData,
      {Function() onPressed, BuildContext context}) {
    return NeumorphicButton(
      padding: EdgeInsets.all(18),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        shape: NeumorphicShape.flat,
      ),
      child: Icon(
        iconData,
        color: NeumorphicTheme.isUsingDark(context)
            ? Colors.white70
            : Colors.black87,
      ),
      onPressed: onPressed,
    );
  }
}
