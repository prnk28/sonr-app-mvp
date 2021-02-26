import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'card_controller.dart';

class ProgressView extends HookWidget {
  //  Properties
  final TransferCard card;
  final Gradient gradient = SonrColor.progressGradient();
  final TransferCardController cardController;
  final Duration duration = const Duration(milliseconds: 1500);
  final bool utilizeProgress;

  // Constructer
  ProgressView(this.cardController, this.card, this.utilizeProgress) : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    // Inject Hook Controller
    final hookController = useAnimationController(duration: duration);
    hookController.loop();

    // Reactive to Progress
    return Container(
        width: Get.width,
        height: Get.height,
        child: Stack(
          alignment: Alignment.center,
          key: UniqueKey(),
          children: <Widget>[
            buildPainter(hookController, utilizeProgress),
            buildShaderMask(hookController, utilizeProgress),
          ],
        ));
  }

  // ^ Method Builds Wave Painter Canvas ^ //
  Widget buildPainter(AnimationController hookController, bool utilizeProgress) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: AnimatedBuilder(
        animation: hookController,
        builder: (BuildContext context, Widget child) {
          return Opacity(
              opacity: 0.85,
              child: utilizeProgress
                  ? Obx(() => CustomPaint(
                        size: Size(Get.width, Get.height),
                        painter: WavePainter(
                          waveAnimation: hookController,
                          percent: SonrService.progress.value,
                          gradient: gradient,
                        ),
                      ))
                  : CustomPaint(
                      size: Size(Get.width, Get.height),
                      painter: WavePainter(
                        waveAnimation: hookController,
                        percent: hookController.value,
                        gradient: gradient,
                      ),
                    ));
        },
      ),
    );
  }

  // ^ Method Builds Shader Box ^ //
  Widget buildShaderMask(AnimationController hookController, bool utilizeProgress) {
    return SizedBox(
      height: Get.width,
      width: Get.height,
      child: ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          colors: [SonrColor.base],
          stops: [0.0],
        ).createShader(bounds),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Center(
            child: buildTransferIcon(hookController, utilizeProgress),
          ),
        ),
      ),
    );
  }

  // ^ Method Builds Shader Box ^ //
  Widget buildTransferIcon(AnimationController hookController, bool utilizeProgress) {
    return Center(
        child: utilizeProgress
            ? Obx(() {
                if (SonrService.progress.value >= 0.5) {
                  return PlayAnimation(
                    tween: 0.0.tweenTo(1.0),
                    duration: Duration(milliseconds: 200),
                    builder: (context, child, value) {
                      return Icon(card.properties.mime.type.gradientData.data, size: 165, color: Colors.white.withOpacity(value));
                    },
                  );
                } else {
                  return Container();
                }
              })
            : PlayAnimation(
                tween: 0.0.tweenTo(1.0),
                delay: Duration(milliseconds: (duration.inMilliseconds / 2).round()),
                duration: Duration(milliseconds: (duration.inMilliseconds / 5).round()),
                builder: (context, child, value) {
                  return Icon(card.properties.mime.type.gradientData.data, size: 165, color: Colors.white.withOpacity(value));
                },
              ));
  }
}
