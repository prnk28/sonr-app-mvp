import 'package:sonr_app/style.dart';
import '../activity.dart';

/// @ Completed Transfer Popup View
class CompletedPopup extends GetView<ActivityController> {
  //final Transfer transfer;
  //CompletedPopup({Key? key, required this.transfer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      // Scaffold Box
      Container(
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 72),
        child: SonrScaffold(body: Container()),
      ),

      // Lotte Animation
      LottieFile.Celebrate.lottie(width: Get.width, height: Get.height, repeat: false, fit: BoxFit.fitHeight),
    ]);
  }
}
