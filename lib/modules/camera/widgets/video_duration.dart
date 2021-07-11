import 'package:sonr_app/style/style.dart';
import '../camera_controller.dart';

class VideoDuration extends StatelessWidget {
  final CameraController controller;
  const VideoDuration({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.videoInProgress.value
        ? Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: AppColor.AccentNavy.withOpacity(0.75)),
            child: RichText(
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                text: TextSpan(children: [
                  TextSpan(
                      text: controller.videoDurationString.value,
                      style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w300, fontSize: 16, color: AppColor.Black)),
                  TextSpan(text: "  s", style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w600, fontSize: 16, color: AppColor.Black)),
                ])),
          )
        : Container());
  }
}
