import 'package:sonar_app/screens/screens.dart';

// Major Constants
const double _K_MAJOR_SPOKE_WIDTH = 18; // Spoke Length
const double _K_MAJOR_TOP_PADDING = 45; // West, East
const double _K_MAJOR_BOTTOM_PADDING = 20; // North, South

// Minor Constants
const double _K_MINOR_SPOKE_WIDTH = 12; // Spoke Length

class CompassView extends StatelessWidget {
  final UserBloc user;
  const CompassView({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Neumorphic(
        margin: EdgeInsets.all(14),
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.circle(),
        ),
        child: Neumorphic(
          style: NeumorphicStyle(
            depth: 14,
            boxShape: NeumorphicBoxShape.circle(),
          ),
          margin: EdgeInsets.all(20),
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: -8,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            margin: EdgeInsets.all(10),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                // Center Circle
                Neumorphic(
                  style: NeumorphicStyle(
                    depth: -3,
                    boxShape: NeumorphicBoxShape.circle(),
                  ),
                  margin: EdgeInsets.all(70),
                ),
                // Spokes
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Stack(
                    children: <Widget>[
                      // ** <North> **//
                      _buildMajorSpoke(0,
                          isNegativeAlignment: true,
                          textColor: Colors.red[900],
                          textValue: "N",
                          textPadding:
                              EdgeInsets.only(bottom: _K_MAJOR_BOTTOM_PADDING)),
                      // ** </North> **//

                      // <MinorSpokes> //
                      _buildMinorSpoke(11.25),
                      _buildMinorSpoke(22.5),
                      _buildMinorSpoke(33.75),
                      // </MinorSpokes> //

                      // NorthEast
                      _buildAuxiliarySpoke(45),

                      // <MinorSpokes> //
                      _buildMinorSpoke(56.25),
                      _buildMinorSpoke(67.5),
                      _buildMinorSpoke(78.75),
                      // </MinorSpokes> //

                      // ** <East> **//
                      _buildMajorSpoke(90,
                          textValue: "W",
                          textPadding:
                              EdgeInsets.only(top: _K_MAJOR_TOP_PADDING)),
                      // ** </East> **//

                      // <MinorSpokes> //
                      _buildMinorSpoke(101.25),
                      _buildMinorSpoke(112.5),
                      _buildMinorSpoke(123.75),
                      // </MinorSpokes> //

                      // SouthEast
                      _buildAuxiliarySpoke(135),

                      // <MinorSpokes> //
                      _buildMinorSpoke(146.25),
                      _buildMinorSpoke(157.5),
                      _buildMinorSpoke(168.75),
                      // </MinorSpokes> //

                      // ** <South> **//
                      _buildMajorSpoke(180,
                          isNegativeAlignment: true,
                          textValue: "S",
                          textPadding:
                              EdgeInsets.only(bottom: _K_MAJOR_BOTTOM_PADDING)),
                      // ** </South> **//

                      // <MinorSpokes> //
                      _buildMinorSpoke(191.25),
                      _buildMinorSpoke(202.5),
                      _buildMinorSpoke(213.75),
                      // </MinorSpokes> //

                      // SouthWest
                      _buildAuxiliarySpoke(225),

                      // <MinorSpokes> //
                      _buildMinorSpoke(236.25),
                      _buildMinorSpoke(247.5),
                      _buildMinorSpoke(258.75),
                      // </MinorSpokes> //

                      // ** <West> **//
                      _buildMajorSpoke(270,
                          textValue: "E",
                          textPadding:
                              EdgeInsets.only(top: _K_MAJOR_TOP_PADDING)),
                      // ** </West> **//

                      // <MinorSpokes> //
                      _buildMinorSpoke(281.25),
                      _buildMinorSpoke(292.5),
                      _buildMinorSpoke(303.75),
                      // </MinorSpokes> //

                      // NorthWest
                      _buildAuxiliarySpoke(315),

                      // <MinorSpokes> //
                      _buildMinorSpoke(326.25),
                      _buildMinorSpoke(337.5),
                      _buildMinorSpoke(348.75),
                      // </MinorSpokes> //
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
            Transform.rotate(
                angle: directionToRads(direction),
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
            Transform.rotate(
                angle: directionToRads(direction + 90),
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
        child: Transform.rotate(
          angle: directionToRads(direction),
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
        child: Transform.rotate(
          angle: directionToRads(direction),
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
}
