import 'package:sonar_app/screens/screens.dart';

class CompassView extends StatelessWidget {
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
                      //those childs are not "good" for a real clock, but will fork for a sample
                      Align(
                        alignment: Alignment(-0.7, -0.7),
                        child: _createDot(context),
                      ),
                      Align(
                        alignment: Alignment(0.7, -0.7),
                        child: _createDot(context),
                      ),
                      Align(
                        alignment: Alignment(-0.7, 0.7),
                        child: _createDot(context),
                      ),
                      Align(
                        alignment: Alignment(0.7, 0.7),
                        child: _createDot(context),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: _buildLine(
                          context: context,
                          angle: degreesToRads(90),
                          width: 15,
                          gradient: FlutterGradients.ripeMalinka(),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _buildLine(
                          context: context,
                          angle: degreesToRads(180),
                          width: 15,
                          gradient: FlutterGradients.malibuBeach(),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _buildLine(
                          context: context,
                          angle: degreesToRads(0),
                          width: 15,
                          gradient: FlutterGradients.malibuBeach(),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildLine(
                          context: context,
                          angle: degreesToRads(270),
                          width: 15,
                          gradient: FlutterGradients.malibuBeach(),
                        ),
                      ),
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

  Widget _buildLine(
      {BuildContext context,
      double angle,
      double width,
      double height = 6,
      Gradient gradient}) {
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

  Widget _createDot(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: -10,
        boxShape: NeumorphicBoxShape.circle(),
      ),
      child: SizedBox(
        height: 10,
        width: 10,
      ),
    );
  }
}
