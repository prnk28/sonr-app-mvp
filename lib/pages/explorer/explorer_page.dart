import 'views/nearby_list.dart';
import 'package:sonr_app/style.dart';
import 'explorer_controller.dart';
import 'views/access_view.dart';

class ExplorerPage extends GetView<ExplorerController> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1280,
        height: 800,
        child: Row(children: [
          Container(
            color: SonrColor.AccentPurple,
            width: 1280 / 3 * 2,
            // height: Get.height,
            child: AccessView(),
          ),
          Container(
            color: SonrColor.AccentBlue,
            width: 1280 / 3,
            // height: Get.height,
            child: NearbyListView(),
          ),
        ]),
      ),
    );
  }
}
