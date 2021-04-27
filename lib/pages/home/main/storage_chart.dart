import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:sonr_app/theme/theme.dart';

/// Icons by svgrepo.com (https://www.svgrepo.com/collection/job-and-professions-3/)
class StorageChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StorageChartState();
}

class StorageChartState extends State {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PieChart(
        PieChartData(
            pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
              setState(() {
                final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent && pieTouchResponse.touchInput is! PointerUpEvent;
                if (desiredTouch && pieTouchResponse.touchedSection != null) {
                  touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                } else {
                  touchedIndex = -1;
                }
              });
            }),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: showingSections()),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 16 : 12;
      final double radius = isTouched ? 72 : 58;
      final double widgetSize = isTouched ? 36 : 28;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: SonrColor.Secondary,
            value: 50,
            title: '50%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              size: widgetSize,
              borderColor: SonrColor.Secondary,
              child: SonrIcons.Video.gradient(gradient: SonrGradient.Primary, size: 18),
            ),
            badgePositionPercentageOffset: .96,
          );
        case 1:
          return PieChartSectionData(
            color: SonrColor.Tertiary,
            value: 34,
            title: '34%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              size: widgetSize,
              borderColor: SonrColor.Tertiary,
              child: SonrIcons.Files.gradient(gradient: SonrGradient.Tertiary, size: 18),
            ),
            badgePositionPercentageOffset: 1.02,
          );
        case 2:
          return PieChartSectionData(
            color: SonrColor.AccentPink,
            value: 16,
            title: '16%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              size: widgetSize,
              borderColor: SonrColor.AccentPink,
              child: SonrIcons.Photos.gradient(gradient: SonrGradient.Critical, size: 18),
            ),
            badgePositionPercentageOffset: .96,
          );
        default:
          return null;
      }
    });
  }
}

class _Badge extends StatelessWidget {
  final double size;
  final Color borderColor;
  final Widget child;

  const _Badge({
    Key key,
    @required this.size,
    @required this.borderColor,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: Neumorph.compact(shape: BoxShape.circle),
      child: Center(child: child),
    );
  }
}
