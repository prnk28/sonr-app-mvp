import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/views/home/main/storage_chart.dart';

enum ToggleFilter { All, Media, Contact, Links }

class GridController extends GetxController with SingleGetTickerProviderMixin {
  // Tag Management
  final category = Rx<ToggleFilter>(ToggleFilter.All);
  final tagIndex = 0.obs;
  final chartData = RxList<PieChartSectionData>([]);
  final chartActiveIndex = (-1).obs;

  // References
  TabController tabController;
  ScrollController scrollController;

  // ^ Controller Constructer ^
  @override
  onInit() {
    // Set Scroll Controller
    scrollController = ScrollController(keepScrollOffset: false);
    chartData(refreshChart());

    // Set Default Properties
    tagIndex(0);

    // Handle Tab Controller
    tabController = TabController(vsync: this, length: 5);
    tabController.addListener(() {
      tagIndex(tabController.index);
    });

    // Initialize
    super.onInit();
  }

  // ^ Method for Setting Category Filter ^ //
  setTag(int index) {
    tagIndex(index);
    category(ToggleFilter.values[index]);
    tabController.animateTo(index);

    // Haptic Feedback
    HapticFeedback.mediumImpact();
  }

  // ^ Method for Returning Random Image Path
  String randomNoFilesPath() {
    return "assets/illustrations/no_files-${Random().nextInt(3) + 1}.png";
  }

  // ^ Handles Chart Item Tap ^ //
  void tapChart(PieTouchResponse pieTouchResponse) {
    final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent && pieTouchResponse.touchInput is! PointerUpEvent;
    if (desiredTouch && pieTouchResponse.touchedSection != null) {
      chartActiveIndex(pieTouchResponse.touchedSection.touchedSectionIndex);
    } else {
      chartActiveIndex(-1);
    }
  }

  // ^ Method Sets Pie Chart Data
  List<PieChartSectionData> refreshChart() {
    return List.generate(3, (i) {
      final isTouched = i == chartActiveIndex.value;
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
            badgeWidget: Badge(
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
            badgeWidget: Badge(
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
            badgeWidget: Badge(
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
