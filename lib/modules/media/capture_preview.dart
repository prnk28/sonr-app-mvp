import 'dart:io';
import 'package:sonr_app/theme/theme.dart';
import 'package:better_player/better_player.dart';

class MediaPreviewView extends StatelessWidget {
  final MediaFile mediaFile;
  final Function(bool decision) onDecision;
  MediaPreviewView({@required this.mediaFile, @required this.onDecision});
  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
        borderRadius: BorderRadius.circular(30),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        backendColor: Colors.transparent,
        child: Container(
            width: Get.width - 20,
            height: Get.height / 3 + 150,
            padding: EdgeInsets.only(top: 6),
            color: SonrColor.White,
            child: Column(
              children: [
                mediaFile.isVideo
                    // Video Player View
                    ? Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: AspectRatio(
                                aspectRatio: 9 / 16,
                                child: BetterPlayer.file(mediaFile.path,
                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                      controlsConfiguration: BetterPlayerControlsConfiguration(),
                                      allowedScreenSleep: false,
                                      autoPlay: true,
                                      looping: true,
                                      aspectRatio: 9 / 16,
                                    )))),
                      )

                    // Photo View
                    : Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(image: FileImage(File(mediaFile.path)), fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                Container(
                  padding: EdgeInsetsX.vertical(10),
                  margin: EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.bottomCenter,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    // Left Button - Cancel and Retake
                    ShapeButton.flat(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        onDecision(false);
                      },
                      text: SonrText.semibold("Redo", color: Colors.orange[600], size: 18),
                    ),

                    // Right Button - Continue
                    Container(
                      width: Get.width / 3 + 20,
                      height: 50,
                      child: ShapeButton.stadium(
                          onPressed: () {
                            HapticFeedback.heavyImpact();
                            onDecision(true);
                          },
                          text: SonrText.semibold("Continue", size: 18, color: SonrColor.Black.withOpacity(0.85)),
                          icon: SonrIcon.gradient(Icons.check, FlutterGradientNames.newLife, size: 28)),
                    ),
                  ]),
                )
              ],
            )));
  }
}
