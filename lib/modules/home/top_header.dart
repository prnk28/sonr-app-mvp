import 'package:sonr_app/theme/navigation/app_bar.dart';
import 'package:sonr_app/theme/theme.dart';
import 'home_controller.dart';

class HomeTopHeaderBar extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipperOne(),
      child: Container(
        height: 600,
        width: Get.width,
        decoration: BoxDecoration(gradient: SonrPalette.primary()),
        child: Stack(children: [
          Align(alignment: Alignment.center, child: Text("WaveClipperOne()")),
          Align(alignment: Alignment.topCenter, child: SonrAppBar(title: "Home")),
        ]),
      ),
    );
  }
}
