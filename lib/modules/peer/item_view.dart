import 'package:sonr_app/modules/peer/peer_controller.dart';
import 'package:sonr_app/style.dart';
import 'profile_view.dart';

/// @ PeerListItem for Remote View
class PeerListItem extends GetWidget<PeerController> {
  final Peer peer;
  final int index;
  PeerListItem(this.peer, this.index);
  @override
  Widget build(BuildContext context) {
    controller.initalize(peer, setAnimated: false);
    return Padding(padding: EdgeInsets.all(8), child: Column(
      children: [
        BoxContainer(
          margin: EdgeWith.horizontal(8),
          child: ListTile(
            leading: ProfileAvatar.fromPeer(peer, size: 50),
            title: _buildTitle(),
            subtitle: _buildContent(),
          ),
        ),
      ],
    ));
  }

  Widget _buildTitle() {
    return Column(
      children: [
        "${peer.profile.fullName}".subheading(),
        RichText(
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            text: TextSpan(children: [
              TextSpan(
                  text: peer.platform.toString(),
                  style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w600, fontSize: 20, color: SonrColor.Primary)),
              TextSpan(
                  text: " ${peer.model}",
                  style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w300, fontSize: 20, color: SonrColor.AccentPurple)),
            ])),
      ],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.only(right: 16, top: 24, bottom: 8),
      child: Container(
        alignment: Alignment.center,
        child: ColorButton.primary(
          onPressed: () {
            TransferService.chooseFile().then((value) {
              if (value) {
                TransferService.sendInviteToPeer(peer);
              }
            });
          },
          text: "Share",
          icon: SonrIcons.Share,
        ),
      ),
    );
  }
}
