part of 'aesthetic.dart';

// ********************** **
// ** -- Color Methods -- **
// ********************** **
// Find Icons color based on Theme - Light/Dark
Color findIconsColor(BuildContext context) {
  final theme = NeumorphicTheme.of(context);
  if (theme.isUsingDark) {
    return theme.current.accentColor;
  } else {
    return null;
  }
}

// Find Text color based on Theme - Light/Dark
Color findTextColor(BuildContext context) {
  final theme = NeumorphicTheme.of(context);
  if (theme.isUsingDark) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}
