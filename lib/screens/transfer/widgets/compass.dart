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
    Expanded(
        child: new Align(
            alignment: Alignment.bottomCenter,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[new Icon(Icons.star), new Text("Bottom Text")],
            )));
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
                      _buildMajorSpoke(
                          angle: degreesToRads(90),
                          alignment: Alignment.topCenter,
                          textColor: Colors.red[900],
                          textValue: "N",
                          textPadding:
                              EdgeInsets.only(bottom: _K_MAJOR_BOTTOM_PADDING)),
                      // ** </North> **//

                      // ** <NorthByEast> **//
                      _buildMinorSpoke(
                        angle: degreesToRads(101.25),
                        alignmentValues: degreesToRectangular(1, 11.25),
                      ),
                      // ** </NorthByEast> **//

                      // ** <East> **//
                      _buildMajorSpoke(
                          angle: degreesToRads(0),
                          alignment: Alignment.centerRight,
                          textValue: "E",
                          textPadding:
                              EdgeInsets.only(top: _K_MAJOR_TOP_PADDING)),
                      // ** </East> **//

                      // ** <South> **//
                      _buildMajorSpoke(
                          angle: degreesToRads(270),
                          alignment: Alignment.bottomCenter,
                          textValue: "S",
                          textPadding:
                              EdgeInsets.only(bottom: _K_MAJOR_BOTTOM_PADDING)),
                      // ** </South> **//

                      // ** <West> **//
                      _buildMajorSpoke(
                          angle: degreesToRads(180),
                          alignment: Alignment.centerLeft,
                          textValue: "W",
                          textPadding:
                              EdgeInsets.only(top: _K_MAJOR_TOP_PADDING)),
                      // ** </West> **//
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
      {double angle,
      Color textColor = Colors.black54,
      String textValue,
      EdgeInsets textPadding,
      Alignment alignment}) {
    return Align(
        alignment: alignment,
        child: Stack(
          alignment: alignment,
          children: [
            // Create Spoke
            Transform.rotate(
                angle: angle,
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
                angle: angle + degreesToRads(90),
                child: Padding(
                    padding: textPadding,
                    child: Text(textValue,
                        style: Design.text.hint(setColor: textColor)))),
          ],
        ));
  }

  Widget _buildMinorSpoke(
      {double angle, Tuple2<double, double> alignmentValues}) {
    return Align(
        alignment: Alignment(alignmentValues.item1, alignmentValues.item2),
        child: Transform.rotate(
          angle: angle,
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
