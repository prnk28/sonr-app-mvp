import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/service/timer_service.dart';
import 'package:sonr_app/theme/theme.dart';

import 'card_controller.dart';

class ProgressView extends HookWidget {
  // Required Properties
  final IconData iconData;
  final double boxHeight = Get.height / 2;
  final double boxWidth = Get.width;
  final Gradient color = randomProgressGradient();
  final TransferCardController cardController;

  // Constructer
  ProgressView(this.cardController, this.iconData) : super(key: GlobalKey());

  @override
  Widget build(BuildContext context) {
    // Inject Progress Controller and Hook Controller
    final hookController = useAnimationController(duration: Duration(seconds: 1));
    final iconKey = GlobalKey();
    hookController.repeat();

    // Reactive to Progress
    return Container(
      color: Colors.black.withOpacity(0.4),
      width: Get.width,
      height: Get.height,
      child: Obx(() {
        return Stack(
          alignment: Alignment.center,
          key: UniqueKey(),
          children: <Widget>[
            SizedBox(
              height: boxHeight,
              width: boxWidth,
              child: AnimatedBuilder(
                animation: hookController,
                builder: (BuildContext context, Widget child) {
                  return CustomPaint(
                    painter: WavePainter(
                      iconKey: iconKey,
                      waveAnimation: hookController,
                      percent: cardController.progress.value,
                      boxHeight: boxHeight,
                      gradient: color,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: boxHeight,
              width: boxWidth,
              child: ShaderMask(
                blendMode: BlendMode.srcOut,
                shaderCallback: (bounds) => LinearGradient(
                  colors: [K_BASE_COLOR],
                  stops: [0.0],
                ).createShader(bounds),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Icon(iconData, key: iconKey, size: 250),
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
