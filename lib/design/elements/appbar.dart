// ***************** **
// ** -- App Bars -- **
// ***************** **

part of 'elements.dart';

NeumorphicAppBar logoAppBar({Color setColor}) {
  return NeumorphicAppBar(
    title: NeumorphicText("Sonr",
        style: NeumorphicStyle(
          depth: 4, //customize depth here
          color: Colors.white, //customize color here
        ),
        textStyle: neuLogoTextStyle(),
        textAlign: TextAlign.center),
  );
}

NeumorphicAppBar screenAppBar(
  String title,
) {
  return NeumorphicAppBar(
    title: NeumorphicText(title,
        style: NeumorphicStyle(
          depth: 2, //customize depth here
          color: Colors.white, //customize color here
        ),
        textStyle: neuBarTitleTextStyle(),
        textAlign: TextAlign.center),
    leading: Container(),
  );
}

NeumorphicAppBar leadingAppBar(
  BuildContext context,
  IconData iconData, {
  Function() onPressed,
  String title: "",
}) {
  // Check if OnPressed Provided
  if (onPressed == null) {
    onPressed = _defaultOnPressed(context);
    log.w("OnPressed not assigned for leading app bar, popping screen");
  }

  // Create App Bar
  return NeumorphicAppBar(
    title: Text(title),
    leading: Stack(
      alignment: Alignment.center,
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: NeumorphicButton(
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
            ))
      ],
    ),
  );
}

_defaultOnPressed(BuildContext context) {
  Navigator.pop(context);
}
