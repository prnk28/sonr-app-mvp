import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'card_controller.dart';

class ProgressView extends HookWidget {
  //  Properties
  final TransferCard card;
  final double iconSize = 250;
  final Gradient gradient = SonrColor.randomGradient();
  final TransferCardController cardController;

  // Constructer
  ProgressView(this.cardController, this.card) : super(key: GlobalKey());

  @override
  Widget build(BuildContext context) {
    // Inject Hook Controller
    final iconKey = GlobalKey();
    final hookController = useAnimationController(duration: Duration(milliseconds: 2000));
    hookController.forward();

    // Handle Animation Completed
    Future.delayed(Duration(milliseconds: 2000), () {
      cardController.animationCompleted(true);
    });

    // Reactive to Progress
    return Container(
        color: Colors.black.withOpacity(0.4),
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
  Widget buildPainter(AnimationController hookController, GlobalKey<State<StatefulWidget>> iconKey) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: AnimatedBuilder(
        animation: hookController,
        builder: (BuildContext context, Widget child) {
          return Opacity(
            opacity: 0.8,
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
  Widget buildShaderMask(AnimationController hookController, GlobalKey<State<StatefulWidget>> iconKey) {
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
  Widget buildTransferIcon(AnimationController hookController, GlobalKey<State<StatefulWidget>> iconKey) {
    // Build Widget
    return Stack(alignment: Alignment.center, children: [
      Obx(() {
        if (cardController.displayProgress.value) {
          return Container(
              child: CircularProgressIndicator(strokeWidth: 6, value: Get.find<SonrService>().progress.value),
              width: iconSize + 20,
              height: iconSize + 20);
        } else {
          return Container();
        }
      }),
      PlayAnimation(
        tween: 0.0.tweenTo(1.0),
        delay: 1000.milliseconds,
        duration: 250.milliseconds,
        builder: (context, child, value) {
          return Icon(SonrIcon.dataFromCard(card), key: iconKey, size: iconSize / 1.5, color: Colors.white.withOpacity(value));
        },
      )
    ]);
  }
}
