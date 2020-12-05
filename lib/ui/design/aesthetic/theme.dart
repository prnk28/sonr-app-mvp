part of 'aesthetic.dart';

// ******************* **
// ** -- Theme Data -- **
// ******************* **
// ignore: non_constant_identifier_names
NeumorphicTheme AppTheme(Widget child) {
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
