part of 'elements.dart';

// Text Field Decoration
InputDecoration textFieldDecoration() {
  return new InputDecoration(
      // Disable Line
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,

      // Input Text Style
      hintStyle: inputTextStyle(),

      // Pad for Border
      contentPadding: const EdgeInsets.only(left: 20.0, bottom: 7.5));
}

// Text Field Style
NeumorphicStyle textFieldStyle() {
  return NeumorphicStyle(
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(45)),
      depth: -6,
      lightSource: LightSource.topLeft,
      color: Colors.transparent);
}
