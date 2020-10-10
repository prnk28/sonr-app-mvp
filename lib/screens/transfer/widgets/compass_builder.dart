part of 'compass.dart';

Widget _buildMajorSpoke(
  double direction, {
  bool isNegativeAlignment = false,
  Color textColor = Colors.black54,
  String textValue,
  EdgeInsets textPadding,
}) {
  // Check Negative Alignment
  double multiplier;
  if (isNegativeAlignment) {
    multiplier = -1;
  } else {
    multiplier = 1;
  }
  // Build Major Spoke
  return Align(
      alignment: directionToAlignment(multiplier * 1, direction),
      child: Stack(
        alignment: directionToAlignment(multiplier * 1, direction),
        children: [
          // Create Spoke
          RotationTransition(
              turns: new AlwaysStoppedAnimation(
                  directionToDegrees(direction) / 360),
              child: Padding(
                  padding: EdgeInsets.only(left: _K_MAJOR_SPOKE_WIDTH),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: 20,
                    ),
                    child: Container(
                      width: _K_MAJOR_SPOKE_WIDTH,
                      height: 1.5,
                      decoration: BoxDecoration(color: Colors.grey[700]),
                    ),
                  ))),
          // Create Text
          RotationTransition(
              turns: new AlwaysStoppedAnimation(
                  directionToDegrees(direction + 90) / 360),
              child: Padding(
                  padding: textPadding,
                  child: Text(textValue,
                      style: Design.text.hint(setColor: textColor)))),
        ],
      ));
}

Widget _buildAuxiliarySpoke(double direction) {
  return Align(
      alignment: directionToAlignment(-1, direction),
      child: RotationTransition(
        turns: new AlwaysStoppedAnimation(directionToDegrees(direction) / 360),
        child: Padding(
          padding: EdgeInsets.only(left: _K_MINOR_SPOKE_WIDTH),
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: 20,
            ),
            child: Container(
              width: 15,
              height: 1.35,
              decoration: BoxDecoration(color: Colors.grey),
            ),
          ),
        ),
      ));
}

Widget _buildMinorSpoke(double direction) {
  return Align(
      alignment: directionToAlignment(-1, direction),
      child: RotationTransition(
        turns: new AlwaysStoppedAnimation(directionToDegrees(direction) / 360),
        child: Padding(
          padding: EdgeInsets.only(left: _K_MINOR_SPOKE_WIDTH),
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: 20,
            ),
            child: Container(
              width: _K_MINOR_SPOKE_WIDTH,
              height: 1,
              decoration: BoxDecoration(color: Colors.grey),
            ),
          ),
        ),
      ));
}

// ********************
// ** Math Functions **
// ********************
num directionToRads(num deg) {
  return (directionToDegrees(deg) * pi) / 180.0;
}

Alignment directionToAlignment(double r, double deg) {
  // Calculate radians
  double radAngle = directionToRads(deg);

  double x = cos(radAngle) * r;
  double y = sin(radAngle) * r;
  return Alignment(x, y);
}

double directionToDegrees(double direction) {
  if (direction + 90 > 360) {
    return direction - 270;
  } else {
    return direction + 90;
  }
}
