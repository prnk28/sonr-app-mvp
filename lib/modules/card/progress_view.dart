import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'card_controller.dart';

class ProgressView extends HookWidget {
  //  Properties
  final TransferCard card;
  final Gradient gradient = SonrColor.randomGradient();
  final TransferCardController cardController;
  final Duration duration;

  // Constructer
  ProgressView(this.cardController, this.card, {this.duration = const Duration(milliseconds: 1400)}) : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    // Inject Hook Controller
    final iconKey = UniqueKey();
    final hookController = useAnimationController(duration: duration);
    hookController.forward();

    // Handle Animation Completed
    Future.delayed(duration, () {
      cardController.animationCompleted(true);
    });

    // Reactive to Progress
    return Container(
        width: Get.width,
        height: Get.height,
        child: Stack(
          alignment: Alignment.center,
          key: UniqueKey(),
          children: <Widget>[
            buildPainter(hookController, iconKey),
            buildShaderMask(hookController, iconKey),
          ],
        ));
  }

  // ^ Method Builds Wave Painter Canvas ^ //
  Widget buildPainter(AnimationController hookController, Key iconKey) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: AnimatedBuilder(
        animation: hookController,
        builder: (BuildContext context, Widget child) {
          return Opacity(
            opacity: 0.85,
            child: CustomPaint(
              painter: WavePainter(
                iconKey: iconKey,
                waveAnimation: hookController,
                percent: hookController.value,
                height: Get.height,
                width: Get.width,
                gradient: gradient,
              ),
            ),
          );
        },
      ),
    );
  }

  // ^ Method Builds Shader Box ^ //
  Widget buildShaderMask(AnimationController hookController, Key iconKey) {
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
            child: buildTransferIcon(hookController, iconKey),
          ),
        ),
      ),
    );
  }

  // ^ Method Builds Shader Box ^ //
  Widget buildTransferIcon(AnimationController hookController, UniqueKey iconKey) {
    return Stack(alignment: Alignment.center, children: [
      Obx(() {
        if (cardController.displayProgress.value) {
          return Container(child: CircularProgressIndicator(strokeWidth: 6, value: Get.find<SonrService>().progress.value), width: 270, height: 270);
        } else {
          return Container();
        }
      }),
      PlayAnimation(
        tween: 0.0.tweenTo(1.0),
        delay: Duration(milliseconds: (duration.inMilliseconds / 2).round()),
        duration: Duration(milliseconds: (duration.inMilliseconds / 5).round()),
        builder: (context, child, value) {
          return Icon(SonrIcon.dataFromCard(card), key: iconKey, size: 165, color: Colors.white.withOpacity(value));
        },
      )
    ]);
  }
}
