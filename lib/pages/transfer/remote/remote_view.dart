import 'package:sonr_app/modules/peer/item_view.dart';
import 'package:sonr_app/style/style.dart';
import 'remote_controller.dart';

/// @ Main Card View
class RemoteView extends GetView<RemoteController> {
  RemoteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      child: Column(
        children: [
          // Label
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: "Lobby Link".headFour(align: TextAlign.start, color: Get.theme.focusColor),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 4)),
          _RemoteLinkText(),
          Padding(padding: EdgeInsets.only(top: 8)),
          Expanded(
              child: ListView.builder(
            itemCount: controller.remoteLobby.value.count,
            itemBuilder: (BuildContext context, int index) {
              var peer = controller.remoteLobby.value.peerAtIndex(index - 1);
              return PeerListItem(
                peer,
                index - 1,
              );
            },
          )),
        ],
      ),
    );
  }
}

class _RemoteLinkText extends GetView<RemoteController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Height.ratio(0.2),
      padding: EdgeInsets.all(8),
      decoration: Neumorphic.floating(theme: Get.theme),
      child: Container(padding: EdgeInsets.all(4), decoration: Neumorphic.indented(theme: Get.theme), child: controller.topicLink.value.url),
    );
  }
}
