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
            Infolist(
              options: [
                InfolistOption(
                  peer.profile.fullName,
                  peer.platform.iconData,
                  isHeader: true,
                  iconColor: peer.platform.defaultIconColor,
                ),
                InfolistOption("Camera", SonrIcons.Camera, onPressed: () {
                  SenderService.choose(ChooseOption.Camera).then((value) {
                    if (value != null) {
                      // Create Invite and Send
                      SenderService.invite(InviteRequestUtils.copyWithPeer(value, this.peer));
                    }
                  });
                }),
                InfolistOption("Media", SonrIcons.Photos, onPressed: () {
                  SenderService.choose(ChooseOption.Media).then((value) {
                    if (value != null) {
                      // Create Invite and Send
                      SenderService.invite(InviteRequestUtils.copyWithPeer(value, this.peer));
                    }
                  });
                }),
                InfolistOption("File", SonrIcons.Files, onPressed: () {
                  SenderService.choose(ChooseOption.File).then((value) {
                    if (value != null) {
                      // Create Invite and Send
                      SenderService.invite(InviteRequestUtils.copyWithPeer(value, this.peer));
                    }
                  });
                }),
                InfolistOption("Contact", SonrIcons.ContactCard, onPressed: () {
                  SenderService.choose(ChooseOption.Contact).then((value) {
                    if (value != null) {
                      // Create Invite and Send
                      SenderService.invite(InviteRequestUtils.copyWithPeer(value, this.peer));
                    }
                  });
                }),
              ],
            ),
            parentKey: peerKey,
            offset: Offset(-Get.width / 2, 20));
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
