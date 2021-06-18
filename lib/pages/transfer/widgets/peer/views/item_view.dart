import 'package:sonr_app/style.dart';
import '../peer.dart';

/// @ PeerListItem for Remote View
class PeerListItem extends GetWidget<PeerController> {
  final Peer peer;
  final int index;
  PeerListItem({required this.peer, required this.index});
  @override
  Widget build(BuildContext context) {
    controller.initalize(peer, setAnimated: false);
    return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
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
        "${peer.profile.fullName}".section(),
        [
          peer.platform.toString().lightSpan(fontSize: 20),
          " ${peer.model}".paragraphSpan(fontSize: 20),
        ].rich()
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
          text: "Invite",
          icon: SonrIcons.Share,
        ),
      ),
    );
  }
}
