import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/modules/peer/peer.dart';

class PeerBubbleView extends GetView<PeerController> {
  final Member member;
  final GlobalKey peerKey = GlobalKey();
  PeerBubbleView(this.member) : super(key: ValueKey(member.active.id.peer));
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoute.positioned(
          ShareHoverView(member: member),
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
    if (member.active.profile.picture.length > 0) {
      return BoxDecoration(
        image: DecorationImage(image: MemoryImage(Uint8List.fromList(member.active.profile.picture))),
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
    return member.active.profile.initials.light(
      fontSize: 18,
      color: AppTheme.GreyColor,
    );
  }
}
