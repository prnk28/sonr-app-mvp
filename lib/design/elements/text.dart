part of 'elements.dart';

// App Bar Logo Text
NeumorphicTextStyle neuLogoTextStyle() {
  return NeumorphicTextStyle(
      fontFamily: "Raleway", fontWeight: FontWeight.w300, fontSize: 36);
}

// Header Text
NeumorphicTextStyle neuBarTitleTextStyle({Color setColor}) {
  return NeumorphicTextStyle(
    fontFamily: "Raleway",
    fontWeight: FontWeight.w400,
    fontSize: 28,
  );
}

// Medium Text
TextStyle mediumTextStyle({Color setColor}) {
  return TextStyle(
      fontFamily: "Raleway",
      fontWeight: FontWeight.bold,
      fontSize: 32,
      color: setColor ?? Colors.black54);
}

// Header Text
TextStyle headerTextStyle({Color setColor}) {
  return TextStyle(
    fontFamily: "Raleway",
    fontWeight: FontWeight.bold,
    fontSize: 40,
    color: setColor ?? Colors.white,
  );
}

// Bulb Direction
TextStyle bulbValueTextStyle({Color setColor}) {
  return TextStyle(
    fontFamily: "Raleway",
    fontWeight: FontWeight.bold,
    fontSize: 46,
    color: setColor ?? Colors.white,
  );
}

// Bulb Designation
TextStyle bulbDesignationTextStyle({Color setColor}) {
  return TextStyle(
    fontFamily: "Raleway",
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: setColor ?? Colors.white,
  );
}

// Hint Text
TextStyle hintTextStyle({Color setColor}) {
  return TextStyle(
    fontFamily: "Raleway",
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: setColor ?? Colors.black87,
  );
}

// Input Text
TextStyle inputTextStyle({Color setColor}) {
  return TextStyle(
      fontFamily: "Raleway",
      fontWeight: FontWeight.normal,
      fontSize: 28,
      color: setColor ?? Colors.cyan);
}

// Description Text
TextStyle descriptionTextStyle({Color setColor}) {
  return TextStyle(
      fontFamily: "Raleway",
      fontWeight: FontWeight.normal,
      fontSize: 24,
      color: setColor ?? Colors.black45);
}
