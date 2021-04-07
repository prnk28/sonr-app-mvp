import 'package:sonr_app/theme/theme.dart';
import 'remote_controller.dart';

class RemoteView extends GetView<RemoteController> {
  RemoteView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      margin: SonrStyle.viewMargin,
      child: Neumorphic(
        style: SonrStyle.normal,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          SonrText.header("Remote View"),
          SonrText.normal("Share to begin viewing your Cards!", color: SonrColor.Black.withOpacity(0.7), size: 18),
          Padding(padding: EdgeInsets.all(16)),
        ]),
      ),
    );
  }
}
