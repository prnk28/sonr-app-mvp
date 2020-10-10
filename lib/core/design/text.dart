import 'design.dart';

class DesignText {
  // App Bar Logo Text
  NeumorphicTextStyle neuLogo() {
    return NeumorphicTextStyle(
        fontFamily: "Raleway", fontWeight: FontWeight.w300, fontSize: 36);
  }

  // Header Text
  NeumorphicTextStyle neuBarTitle({Color setColor}) {
    return NeumorphicTextStyle(
      fontFamily: "Raleway",
      fontWeight: FontWeight.w400,
      fontSize: 28,
    );
  }

  // Medium Text
  TextStyle medium({Color setColor}) {
    return TextStyle(
        fontFamily: "Raleway",
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: setColor ?? Colors.black54);
  }

  // Header Text
  TextStyle header({Color setColor}) {
    return TextStyle(
      fontFamily: "Raleway",
      fontWeight: FontWeight.bold,
      fontSize: 40,
      color: setColor ?? Colors.white,
    );
  }

  // Bulb Direction
  TextStyle bulbValue({Color setColor}) {
    return TextStyle(
      fontFamily: "Raleway",
      fontWeight: FontWeight.bold,
      fontSize: 46,
      color: setColor ?? Colors.white,
    );
  }

  // Bulb Designation
  TextStyle bulbDesignation({Color setColor}) {
    return TextStyle(
      fontFamily: "Raleway",
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: setColor ?? Colors.white,
    );
  }

  // Hint Text
  TextStyle hint({Color setColor}) {
    return TextStyle(
      fontFamily: "Raleway",
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: setColor ?? Colors.black87,
    );
  }

  // Input Text
  TextStyle input({Color setColor}) {
    return TextStyle(
        fontFamily: "Raleway",
        fontWeight: FontWeight.normal,
        fontSize: 28,
        color: setColor ?? Colors.cyan);
  }

  // Description Text
  TextStyle description({Color setColor}) {
    return TextStyle(
        fontFamily: "Raleway",
        fontWeight: FontWeight.normal,
        fontSize: 24,
        color: setColor ?? Colors.black45);
  }
}
