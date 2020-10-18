part of 'elements.dart';

NeumorphicButton appBarLeadingButton(IconData iconData,
    {Function() onPressed, BuildContext context}) {
  return NeumorphicButton(
    padding: EdgeInsets.all(18),
    style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        shape: NeumorphicShape.convex,
        depth: 5),
    child: Icon(
      iconData,
      color: NeumorphicTheme.isUsingDark(context)
          ? Colors.white70
          : Colors.black87,
    ),
    onPressed: onPressed,
  );
}
