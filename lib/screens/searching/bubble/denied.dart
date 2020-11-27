part of 'bubble.dart';

class DeniedBubble extends StatelessWidget {
  final double value;
  const DeniedBubble({Key key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: calculateOffset(value).dy,
        left: calculateOffset(value).dx,
        child: Container(
            child: Neumorphic(
          style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.circle(),
              depth: 10,
              lightSource: LightSource.topLeft,
              color: Colors.grey[300]),
          child: Container(
            width: 80,
            height: 80,
            child: FlareActor("assets/animations/denied.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "animate"),
          ),
        )));
  }
}
