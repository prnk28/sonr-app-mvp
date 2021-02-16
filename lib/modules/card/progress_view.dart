import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/service/timer_service.dart';
import 'package:sonr_app/theme/theme.dart';

class ProgressView extends HookWidget {
  // Required Properties
  final IconData iconData;
  final double boxHeight = Get.height / 2;
  final double boxWidth = Get.width;
  final Gradient color = randomProgressGradient();

  // Constructer
  ProgressView(this.iconData) : super(key: GlobalKey());

  @override
  Widget build(BuildContext context) {
    // Inject Progress Controller and Hook Controller
    final progressController = Get.put(ProgressController());
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
                      percent: progressController.progress.value,
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

class ProgressController extends GetxController {
  // Properties
  RxDouble progress = 0.0.obs;

  // Duration Constants in Ms
  final kMinimumDuration = 250.milliseconds;
  final kAnimationDuration = 1750.milliseconds;

  // References
  var _isUsingTimer = false;

  // ^ Constructer converts progress/duration to percentage ^ //
  ProgressController() {
    // @ Start Timer
    Get.find<TimerService>().start(intervals: [kMinimumDuration], stopTime: kAnimationDuration);

    // @ Listen for Minimum Timer
    Get.find<TimerService>().timerIntervals.listen((data) {
      data.forEach((time, status) {
        // Check if Transfer Completed Before Animation
        if (time == kMinimumDuration && status && Get.find<SonrService>().progress.round() == 1) {
          _isUsingTimer = true;
          progress = Get.find<TimerService>().progress;
        }
        // Set Progress for Transfer
        else {
          _isUsingTimer = false;
          progress = Get.find<SonrService>().progress;
        }
      });
    });

    // @ Listen for Timer Complete
    Get.find<TimerService>().elapsed.listen((value) {
      if (_isUsingTimer) {
        if (value == kAnimationDuration) {
          Get.back();
        }
      }
    });

    // @ Listen for Transfer Complete
    Get.find<SonrService>().progress.listen((value) {
      if (!_isUsingTimer) {
        if (value == 1.0) {
          Get.back();
        }
      }
    });
  }
}
