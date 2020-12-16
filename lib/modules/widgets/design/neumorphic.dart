// ******************* **
// ** -- Theme Data -- **
// ******************* **
// ignore: non_constant_identifier_names
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

// ^ Sonr Global Theme Data ^ //
// ignore: non_constant_identifier_names
NeumorphicTheme SonrTheme(Widget child) {
  return NeumorphicTheme(
      themeMode: ThemeMode.light, //or dark / system
      darkTheme: NeumorphicThemeData(
        baseColor: Color.fromRGBO(239, 238, 238, 1.0),
        accentColor: Colors.green,
        lightSource: LightSource.topLeft,
        depth: 4,
        intensity: 0.3,
      ),
      theme: NeumorphicThemeData(
        baseColor: Color(0xffDDDDDD),
        accentColor: Colors.cyan,
        lightSource: LightSource.topLeft,
        depth: 6,
        intensity: 0.5,
      ),
      child: child);
}

// ^ Sonr Global AppBar Data ^ //
// ignore: non_constant_identifier_names
NeumorphicAppBar SonrAppBar(
  String title,
) {
  return NeumorphicAppBar(
      title: Center(
          child: NeumorphicText(title,
              style: NeumorphicStyle(
                depth: 2, //customize depth here
                color: Colors.white, //customize color here
              ),
              textStyle: NeumorphicTextStyle(
                fontFamily: "Raleway",
                fontWeight: FontWeight.w400,
                fontSize: 28,
              ),
              textAlign: TextAlign.center)),
      leading: null);
}

// ^ Sonr Global WindowBorder Data ^ //
// ignore: non_constant_identifier_names
RoundedRectangleBorder SonrWindowBorder() {
  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0));
}

// ^ Sonr Global WindowDecoration Data ^ //
// ignore: non_constant_identifier_names
BoxDecoration SonrWindowDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(40),
    color: NeumorphicTheme.baseColor(context),
  );
}
