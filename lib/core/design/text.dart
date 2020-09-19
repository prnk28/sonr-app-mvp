import 'design.dart';

class DesignText {
  // App Bar Logo Text
  NeumorphicTextStyle logo() {
    return NeumorphicTextStyle(
        fontFamily: "GT-Pressura", fontWeight: FontWeight.w300, fontSize: 36);
  }

  // Medium Text
  TextStyle medium({Color setColor}) {
    return TextStyle(
        fontFamily: "GT-Pressura",
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: setColor ?? Colors.black54);
  }

  // Header Text
  TextStyle header({Color setColor}) {
    return TextStyle(
      fontFamily: "GT-Pressura",
      fontWeight: FontWeight.bold,
      fontSize: 40,
      color: setColor ?? Colors.white,
    );
  }

  // Hint Text
  TextStyle hint({Color setColor}) {
    return TextStyle(
      fontFamily: "GT-Pressura",
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: setColor ?? Colors.black87,
    );
  }

  // Input Text
  TextStyle input({Color setColor}) {
    return TextStyle(
        fontFamily: "GT-Pressura",
        fontWeight: FontWeight.normal,
        fontSize: 28,
        color: setColor ?? Colors.cyan);
  }

  // Description Text
  TextStyle description({Color setColor}) {
    return TextStyle(
        fontFamily: "GT-Pressura",
        fontWeight: FontWeight.normal,
        fontSize: 24,
        color: setColor ?? Colors.black45);
  }
}
