import 'package:sonar_app/screens/screens.dart';

import 'curve_painter.dart';

part 'bubble_builder.dart';

class BubbleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Padding(
            padding: EdgeInsets.only(bottom: 75),
            child: CustomPaint(
              painter: CurvePainter(1),
              child: Container(),
            )),
        Padding(
            padding: EdgeInsets.only(bottom: 325),
            child: CustomPaint(
              painter: CurvePainter(1.25),
              child: Container(),
            )),
        Padding(
          padding: EdgeInsets.only(bottom: 575),
          child: CustomPaint(painter: CurvePainter(4), child: Container()),
        ),
      ],
    );
  }
}
