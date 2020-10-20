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
  String destination,
  BuildContext context,
  IconData iconData, {
  bool shouldPopScreen,
  bool shouldRevertToActive,
  String title,
}) {
  return NeumorphicAppBar(
    leading: Stack(
      alignment: Alignment.center,
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: appBarLeadingButton(iconData, onPressed: () {
              // Check if Bool Provided or False
              if (shouldPopScreen == null || !shouldPopScreen) {
                // Shift Screen
                Navigator.pushNamed(context, destination);
              } else {
                if (shouldRevertToActive) {
                  // Update Node
                  context.getBloc(BlocType.Web).add(Update(Status.Available));
                }

                // Pop Navigation
                Navigator.pop(context);
              }
            }, context: context)),
      ],
    ),
  );
}
