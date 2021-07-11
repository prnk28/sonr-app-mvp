import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/modules/peer/peer.dart';

class PeerBubbleView extends GetView<PeerController> {
  final Peer peer;
  final GlobalKey peerKey = GlobalKey();
  PeerBubbleView(this.peer) : super(key: ValueKey(peer.id.peer));
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoute.positioned(
          ShareHoverView(peer: peer),
          init: () => ShareController.initPopup(),
          parentKey: peerKey,
          offset: Offset(-Get.width / 2, 20),
        );
      },
      child: Container(
        key: peerKey,
        width: 36,
        height: 36,
        margin: EdgeInsets.symmetric(horizontal: 6),
        decoration: _buildDecoration(),
        child: Center(child: _buildPeerInitials()),
      ),
    );
  }

  Decoration _buildDecoration() {
    if (peer.profile.picture.length > 0) {
      return BoxDecoration(
        image: DecorationImage(image: MemoryImage(Uint8List.fromList(peer.profile.picture))),
        shape: BoxShape.circle,
      );
    } else {
      return BoxDecoration(
        color: AppTheme.ForegroundColor,
        shape: BoxShape.circle,
      );
    }
  }

  Widget _buildPeerInitials() {
    return peer.profile.initials.light(
      fontSize: 18,
      color: AppTheme.GreyColor,
    );
  }
}
