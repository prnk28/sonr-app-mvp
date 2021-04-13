import 'dart:ui';
import 'package:sonr_app/theme/theme.dart';
import 'home_controller.dart';

// ^ Alerts View ^ //
class AlertsView extends GetView<HomeController> {
  AlertsView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      margin: EdgeInsets.symmetric(vertical: Get.height * 0.15, horizontal: Get.width * 0.05),
      child: Neumorphic(
        style: SonrStyle.normal,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          "Alerts View".headTwo(align: TextAlign.center),
          "This Page is Under Construction.".paragraph(align: TextAlign.center, color: SonrColor.Grey),
        ]),
      ),
    );
  }
}
