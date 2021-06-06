import 'package:sonr_app/pages/transfer/remote/remote_controller.dart';
import 'package:sonr_app/style.dart';

class RemoteSheet {
  static void open(String link) {
    // Print Link
    Logger.info("Remote Link: " + link);

    // Handle Controllers
    if (RemoteLobbyController.isNotRegistered) {
      Get.put(RemoteLobbyController());
    }
    Get.find<RemoteLobbyController>().joinRemote(link).then((value) {
      if (value) {
        Get.bottomSheet(RemoteSheetView(), isDismissible: false);
      }
    });
  }
}

class RemoteSheetView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Height.ratio(0.25),
      color: Colors.green,
    );
  }
}
