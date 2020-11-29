import 'package:sonar_app/ui/ui.dart';
import 'dart:math';
part 'spokes.dart';

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
                    buildCenterBulb(this.direction),

                    // Spokes
                    Transform.rotate(
                        angle: ((this.direction ?? 0) * (pi / 180) * -1),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Stack(
                            children: <Widget>[
                              // ** <North> **//
                              buildMajorSpoke(0,
                                  isNegativeAlignment: true,
                                  textColor: Colors.red[900],
                                  textValue: "N",
                                  textPadding: EdgeInsets.only(
                                      bottom: K_MAJOR_BOTTOM_PADDING)),
                              // ** </North> **//

                              // <MinorSpokes> //
                              buildMinorSpoke(11.25),
                              buildMinorSpoke(22.5),
                              buildMinorSpoke(33.75),
                              // </MinorSpokes> //

                              // NorthEast
                              buildAuxiliarySpoke(45),

                              // <MinorSpokes> //
                              buildMinorSpoke(56.25),
                              buildMinorSpoke(67.5),
                              buildMinorSpoke(78.75),
                              // </MinorSpokes> //

                              // ** <East> **//
                              buildMajorSpoke(90,
                                  textValue: "W",
                                  textPadding: EdgeInsets.only(
                                      top: K_MAJOR_TOP_PADDING)),
                              // ** </East> **//

                              // <MinorSpokes> //
                              buildMinorSpoke(101.25),
                              buildMinorSpoke(112.5),
                              buildMinorSpoke(123.75),
                              // </MinorSpokes> //

                              // SouthEast
                              buildAuxiliarySpoke(135),

                              // <MinorSpokes> //
                              buildMinorSpoke(146.25),
                              buildMinorSpoke(157.5),
                              buildMinorSpoke(168.75),
                              // </MinorSpokes> //

                              // ** <South> **//
                              buildMajorSpoke(180,
                                  isNegativeAlignment: true,
                                  textValue: "S",
                                  textPadding: EdgeInsets.only(
                                      bottom: K_MAJOR_BOTTOM_PADDING)),
                              // ** </South> **//

                              // <MinorSpokes> //
                              buildMinorSpoke(191.25),
                              buildMinorSpoke(202.5),
                              buildMinorSpoke(213.75),
                              // </MinorSpokes> //

                              // SouthWest
                              buildAuxiliarySpoke(225),

                              // <MinorSpokes> //
                              buildMinorSpoke(236.25),
                              buildMinorSpoke(247.5),
                              buildMinorSpoke(258.75),
                              // </MinorSpokes> //

                              // ** <West> **//
                              buildMajorSpoke(270,
                                  textValue: "E",
                                  textPadding: EdgeInsets.only(
                                      top: K_MAJOR_TOP_PADDING)),
                              // ** </West> **//

                              // <MinorSpokes> //
                              buildMinorSpoke(281.25),
                              buildMinorSpoke(292.5),
                              buildMinorSpoke(303.75),
                              // </MinorSpokes> //

                              // NorthWest
                              buildAuxiliarySpoke(315),

                              // <MinorSpokes> //
                              buildMinorSpoke(326.25),
                              buildMinorSpoke(337.5),
                              buildMinorSpoke(348.75),
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
