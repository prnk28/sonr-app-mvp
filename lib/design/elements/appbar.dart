// ***************** **
// ** -- App Bars -- **
// ***************** **

part of 'elements.dart';

NeumorphicAppBar logoAppBar({Color setColor}) {
  return NeumorphicAppBar(
    title: Center(
        child: NeumorphicText(
      "Sonr",
      style: NeumorphicStyle(
        depth: 4, //customize depth here
        color: Colors.white, //customize color here
      ),
      textStyle: neuLogoTextStyle(),
    )),
  );
}

NeumorphicAppBar titleAppBar(
  String title,
) {
  return NeumorphicAppBar(
    title: Center(
        child: NeumorphicText(title,
            style: NeumorphicStyle(
              depth: 2, //customize depth here
              color: Colors.white, //customize color here
            ),
            textStyle: neuBarTitleTextStyle(),
            textAlign: TextAlign.center)),
  );
}

NeumorphicAppBar actionSingleAppBar(
  BuildContext context,
  IconData leadingIcon,
  IconData actionIcon, {
  Function() onLeadingPressed,
  Function() onActionPressed,
  String title: "",
}) {
  // Check if OnPressed Provided
  if (onLeadingPressed == null) {
    onLeadingPressed = _defaultOnPressed(context);
    log.w("OnPressed not assigned for leading app bar, popping screen");
  }

  // Create App Bar
  return NeumorphicAppBar(
    title: Center(
        child: NeumorphicText(title,
            style: NeumorphicStyle(
              depth: 2, //customize depth here
              color: Colors.white, //customize color here
            ),
            textStyle: neuBarTitleTextStyle(),
            textAlign: TextAlign.center)),
    leading: getAppBarButton(context, leadingIcon, onLeadingPressed),
    actions: [getAppBarButton(context, actionIcon, onActionPressed)],
  );
}

NeumorphicAppBar exitAppBar(
  BuildContext context,
  IconData icon, {
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
      title: Center(child: Text(title)),
      leading: getAppBarButton(context, icon, onPressed));
}

_defaultOnPressed(BuildContext context) {
  Navigator.pop(context);
}
