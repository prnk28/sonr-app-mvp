import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/modules/peer/peer.dart';

class PeerMiniView extends GetView<PeerController> {
  final Peer peer;
  final GlobalKey peerKey = GlobalKey();
  PeerMiniView(this.peer) : super(key: ValueKey(peer.id.peer));
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoute.positioned(
            Infolist(
              options: [
                InfolistOption(
                  peer.profile.fullName,
                  SonrIcons.ATSign,
                  isHeader: true,
                ),
                InfolistOption("Media", SonrIcons.Photos),
                InfolistOption("File", SonrIcons.Files),
                InfolistOption("Contact", SonrIcons.ContactCard),
              ],
            ),
            parentKey: peerKey,
            offset: Offset(-Get.width / 2, 20));
      },
      child: Container(
        key: peerKey,
        width: 32,
        height: 32,
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
        color: AppTheme.foregroundColor,
        shape: BoxShape.circle,
      );
    }
  }

  Widget _buildPeerInitials() {
    return peer.profile.initials.light(
      fontSize: 18,
      color: AppTheme.greyColor,
    );
  }
}
