import 'design.dart';

class DesignButton {
  NeumorphicButton appBarLeadingButton({Function() onPressed, Icon icon}) {
    return NeumorphicButton(
        margin: EdgeInsets.only(top: 12),
        style: NeumorphicStyle(
            shape: NeumorphicShape.flat, boxShape: NeumorphicBoxShape.circle()),
        onPressed: onPressed,
        child: icon);
  }
}
