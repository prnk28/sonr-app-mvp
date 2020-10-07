import 'design.dart';

class DesignButton {
  NeumorphicButton appBarLeadingButton(
      {Function() onPressed, Icon icon, BuildContext context}) {
    return NeumorphicButton(
      padding: EdgeInsets.all(18),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        shape: NeumorphicShape.flat,
      ),
      child: Icon(
        Icons.arrow_back,
        color: NeumorphicTheme.isUsingDark(context)
            ? Colors.white70
            : Colors.black87,
      ),
      onPressed: onPressed,
    );
  }
}
