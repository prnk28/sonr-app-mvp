import 'package:sonar_app/screens/screens.dart';

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
                //the click center
                Neumorphic(
                  style: NeumorphicStyle(
                    depth: -1,
                    boxShape: NeumorphicBoxShape.circle(),
                  ),
                  margin: EdgeInsets.all(65),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: <Widget>[
                      // ** <East> **//
                      _buildMajorSpoke(
                          angle: degreesToRads(0),
                          spokeWidth: 15,
                          gradient: FlutterGradients.malibuBeach(),
                          alignment: Alignment.centerRight,
                          textColor: Colors.black54,
                          textValue: "E",
                          textPadding: EdgeInsets.only(top: 40)),
                      // ** </East> **//

                      // ** <North> **//
                      _buildMajorSpoke(
                          angle: degreesToRads(90),
                          spokeWidth: 15,
                          gradient: FlutterGradients.ripeMalinka(),
                          alignment: Alignment.topCenter,
                          textColor: Colors.red[900],
                          textValue: "N",
                          textPadding: EdgeInsets.only(bottom: 20)),
                      // ** </North> **//

                      // ** <West> **//
                      _buildMajorSpoke(
                          angle: degreesToRads(180),
                          spokeWidth: 15,
                          gradient: FlutterGradients.malibuBeach(),
                          alignment: Alignment.centerLeft,
                          textColor: Colors.black54,
                          textValue: "W",
                          textPadding: EdgeInsets.only(top: 40)),
                      // ** </West> **//

                      // ** <South> **//
                      _buildMajorSpoke(
                          angle: degreesToRads(270),
                          spokeWidth: 15,
                          gradient: FlutterGradients.malibuBeach(),
                          alignment: Alignment.bottomCenter,
                          textColor: Colors.black54,
                          textValue: "S",
                          textPadding: EdgeInsets.only(bottom: 20)),
                      // ** </South> **//
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
      double spokeWidth,
      Gradient gradient,
      Color textColor,
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
                    padding: EdgeInsets.only(left: spokeWidth),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: 20,
                      ),
                      child: Container(
                        width: spokeWidth,
                        height: 3,
                        decoration: BoxDecoration(gradient: gradient),
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
      {double angle, double width, double height = 3, Gradient gradient}) {
    return Transform.rotate(
      angle: angle,
      child: Padding(
        padding: EdgeInsets.only(left: width),
        child: Neumorphic(
          style: NeumorphicStyle(
            depth: 20,
          ),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(gradient: gradient),
          ),
        ),
      ),
    );
  }
}
