import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

class ProgressView extends HookWidget {
  //  Properties
  final SonrFile file;
  final Gradient gradient = SonrGradient.Progress;
  final Duration duration = const Duration(milliseconds: 1500);
  final bool utilizeProgress;

  // Constructer
  ProgressView(this.file, this.utilizeProgress) : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    // Inject Hook Controller
    final hookController = useAnimationController(duration: duration);
    hookController.forward();

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

  /// @ Method Builds Wave Painter Canvas
  Widget buildPainter(AnimationController hookController, bool utilizeProgress) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: AnimatedBuilder(
        animation: hookController,
        builder: (BuildContext context, Widget? child) {
          return Opacity(
              opacity: 0.85,
              child: utilizeProgress
                  ? Obx(() => GestureDetector(
                        onTap: () => SonrOverlay.back(),
                        child: CustomPaint(
                          size: Size(Get.width, Get.height),
                          painter: WavePainter(
                            waveAnimation: hookController,
                            percent: SonrService.session.progress.value,
                            gradient: gradient,
                          ),
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

  /// @ Method Builds Shader Box
  Widget buildShaderMask(AnimationController hookController, bool utilizeProgress) {
    return SizedBox(
      height: Get.width,
      width: Get.height,
      child: ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          colors: [SonrColor.White],
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

  /// @ Method Builds Shader Box
  Widget buildTransferIcon(AnimationController hookController, bool utilizeProgress) {
    return Center(
        child: utilizeProgress
            ? Obx(() {
                if (SonrService.session.progress.value >= 0.5) {
                  return FadeIn(child: file.single.mime.type.gradient(size: 165));
                } else {
                  return Container();
                }
              })
            : FadeIn(
                delay: Duration(milliseconds: (duration.inMilliseconds / 2).round()),
                duration: Duration(milliseconds: (duration.inMilliseconds / 5).round()),
                child: file.single.mime.type.gradient(size: 165)));
  }
}
