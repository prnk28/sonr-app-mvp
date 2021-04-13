

// ** Builds Compass View Bulb ** //
import 'package:sonr_app/theme/theme.dart';

class BulbView extends StatelessWidget {
  final String direction;
  final String heading;
  final Gradient gradient;
  BulbView(this.direction, this.heading, this.gradient);
  @override
  Widget build(BuildContext context) {
    // Return View
    return Neumorphic(
        style: NeumorphicStyle(
          depth: -5,
          boxShape: NeumorphicBoxShape.circle(),
        ),
        margin: EdgeInsets.all(65),
        child: Neumorphic(
            style: NeumorphicStyle(
              depth: 10,
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            margin: EdgeInsets.all(7.5),
            child: AnimatedContainer(
                duration: Duration(seconds: 1),
                decoration: BoxDecoration(gradient: gradient),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  direction.gradient(gradient: FlutterGradientNames.glassWater, size: 44, key: ValueKey<String>(direction)),
                  AnimatedSlideSwitcher.slideDown(
                      child: heading.gradient(gradient: FlutterGradientNames.glassWater, size: 24, key: ValueKey<String>(heading)))
                ]))));
  }
}
