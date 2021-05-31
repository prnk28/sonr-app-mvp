import 'package:sonr_app/modules/peer/item_view.dart';
import 'package:sonr_app/style/style.dart';
import 'remote_controller.dart';

/// @ Main Card View
class RemoteView extends GetView<RemoteLobbyController> {
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

class _RemoteLinkText extends GetView<RemoteLobbyController> {
  @override
  Widget build(BuildContext context) {
    // Return Text Spans
    var spans = [
      TextSpan(
          text: _condensedFingerprint(controller.topicLink.value),
          style: TextStyle(
              fontFamily: 'Manrope',
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted,
              fontWeight: FontWeight.w300,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.blueGrey[300])),
      TextSpan(
          text: _fetchHost(controller.topicLink.value),
          style: TextStyle(
              fontFamily: 'Manrope',
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.blue[600])),
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width,
        height: Height.ratio(0.2),
        padding: EdgeInsets.all(8),
        decoration: Neumorphic.floating(theme: Get.theme),
        child: Container(
            padding: EdgeInsets.all(4),
            decoration: Neumorphic.indented(theme: Get.theme),
            child: SizedBox(
              width: Width.ratio(0.6),
              height: Height.ratio(0.25),
              child: RichText(
                overflow: TextOverflow.fade,
                text: TextSpan(children: spans),
              ),
            )),
      ),
    );
  }

  String _fetchHost(String link) {
    var idx = link.indexOf(".remote");
    return link.substring(idx + 1);
  }

  String _condensedFingerprint(String fingerprint) {
    return fingerprint.substring(0, 8) + ".";
  }
}
