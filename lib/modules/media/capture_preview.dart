import 'dart:io';
import 'package:sonr_app/core/core.dart';
import 'package:better_player/better_player.dart';

class MediaPreviewView extends StatelessWidget {
  final MediaFile mediaFile;
  final Function(bool decision) onDecision;
  MediaPreviewView({@required this.mediaFile, @required this.onDecision});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            mediaFile.isVideo
                // Video Player View
                ? Container(
                    width: Get.width,
                    height: Get.height,
                    child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: BetterPlayer.file(mediaFile.path,
                            betterPlayerConfiguration: BetterPlayerConfiguration(
                              controlsConfiguration: BetterPlayerControlsConfiguration(),
                              allowedScreenSleep: false,
                              autoPlay: true,
                              looping: true,
                              aspectRatio: 9 / 16,
                            ))))

                // Photo View
                : Positioned.fill(
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      child: Image.file(File(mediaFile.path)),
                    ),
                  ),
            Container(
              alignment: Alignment.bottomCenter,
              child: NeumorphicBackground(
                backendColor: Colors.transparent,
                child: Neumorphic(
                  padding: EdgeInsets.only(top: 20, bottom: 40),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    // Left Button - Cancel and Retake
                    SonrButton.circle(
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          onDecision(false);
                        },
                        icon: SonrIcon.close),

                    // Right Button - Continue and Accept
                    SonrButton.circle(
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          onDecision(true);
                        },
                        icon: SonrIcon.accept),
                  ]),
                ),
              ),
            )
          ],
        ));
  }
}
