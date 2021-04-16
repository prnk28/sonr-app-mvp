import 'package:sonr_app/pages/transfer/bulb_view.dart';
import 'package:sonr_app/theme/form/theme.dart';
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
      child: HexagonView(),
    );
  }
}
