import 'package:sonar_app/screens/screens.dart';
import 'dart:math' as math;

part 'compass_builder.dart';

// Major Constants
const double _K_MAJOR_SPOKE_WIDTH = 18; // Spoke Length
const double _K_MAJOR_TOP_PADDING = 45; // West, East
const double _K_MAJOR_BOTTOM_PADDING = 20; // North, South

// Minor Constants
const double _K_MINOR_SPOKE_WIDTH = 12; // Spoke Length

class CompassView extends StatelessWidget {
  final double direction;
  const CompassView({Key key, this.direction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      // Compass Total
      AspectRatio(
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
              // Interior Compass
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
                    Transform.rotate(
                        angle: ((this.direction ?? 0) * (math.pi / 180) * -2),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Stack(
                            children: <Widget>[
                              // ** <North> **//
                              _buildMajorSpoke(0,
                                  isNegativeAlignment: true,
                                  textColor: Colors.red[900],
                                  textValue: "N",
                                  textPadding: EdgeInsets.only(
                                      bottom: _K_MAJOR_BOTTOM_PADDING)),
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
                                  textPadding: EdgeInsets.only(
                                      top: _K_MAJOR_TOP_PADDING)),
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
                                  textPadding: EdgeInsets.only(
                                      bottom: _K_MAJOR_BOTTOM_PADDING)),
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
                                  textPadding: EdgeInsets.only(
                                      top: _K_MAJOR_TOP_PADDING)),
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
                        )),
                  ]),
            ),
          ),
        ),
      ),

      // Ticker
      Padding(
          padding: EdgeInsets.only(top: 15),
          child: Neumorphic(
            style: NeumorphicStyle(
                depth: -20, lightSource: LightSource.topRight, intensity: 0.75),
            child: Container(
              width: 3,
              height: 36,
              decoration: BoxDecoration(color: Colors.red[900]),
            ),
          )),

      // Ticker Handle
      Padding(
          padding: EdgeInsets.only(top: 50),
          child: Neumorphic(
            style: NeumorphicStyle(
                depth: -20, lightSource: LightSource.topRight, intensity: 0.75),
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: Colors.red[900]),
            ),
          )),
    ]);
  }
}
