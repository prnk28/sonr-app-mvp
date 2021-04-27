import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sonr_app/theme/theme.dart';
import 'grid_controller.dart';

class StorageChart extends GetView<GridController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          child: PieChart(
            PieChartData(
                pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) => controller.tapChart(pieTouchResponse)),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 0,
                sections: controller.chartData),
          ),
        ));
  }
}

class Badge extends StatelessWidget {
  final double size;
  final Color borderColor;
  final Widget child;

  const Badge({
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
