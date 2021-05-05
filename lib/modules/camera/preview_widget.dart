import 'package:sonr_app/modules/video/video_view.dart';
import 'package:sonr_app/theme/theme.dart';

class MediaPreviewView extends StatelessWidget {
  final SonrFile mediaFile;
  final Function(bool decision) onDecision;
  MediaPreviewView({@required this.mediaFile, @required this.onDecision});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.width - 20,
        height: Get.height / 3 + 150,
        padding: EdgeInsets.only(top: 6),
        color: SonrColor.White,
        child: Column(
          children: [
            mediaFile.singleFile.mime.isVideo
                // Video Player View
                ? Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: AspectRatio(
                            aspectRatio: 9 / 16,
                            child: VideoPlayerView.file(
                              mediaFile.fileAtIndex(),
                            ))),
                  )

                // Photo View
                : Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(image: FileImage(mediaFile.fileAtIndex()), fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
            Container(
              padding: EdgeWith.vertical(10),
              margin: EdgeInsets.only(left: 10, right: 10),
              alignment: Alignment.bottomCenter,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                // Left Button - Cancel and Retake
                PlainButton(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    onDecision(false);
                  },
                  text: "Redo",
                ),

                // Right Button - Continue
                Container(
                  width: Get.width / 3 + 20,
                  height: 50,
                  child: ColorButton.primary(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        onDecision(true);
                      },
                      text: "Continue",
                      icon: SonrIcons.Check),
                ),
              ]),
            )
          ],
        ));
  }
}
