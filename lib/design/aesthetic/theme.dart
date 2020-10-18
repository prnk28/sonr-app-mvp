part of 'aesthetic.dart';

// ******************* **
// ** -- Theme Data -- **
// ******************* **
NeumorphicThemeData lightTheme() {
  return NeumorphicThemeData(
    baseColor: Color(0xffDDDDDD),
    accentColor: Colors.cyan,
    lightSource: LightSource.topLeft,
    depth: 6,
    intensity: 0.5,
  );
}

NeumorphicThemeData darkTheme() {
  return NeumorphicThemeData(
    baseColor: Color(0xff333333),
    accentColor: Colors.green,
    lightSource: LightSource.topLeft,
    depth: 4,
    intensity: 0.3,
  );
}
