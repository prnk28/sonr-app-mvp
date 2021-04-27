import 'package:sonr_app/views/transfer/transfer_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/data/data.dart';

// ^ PeerListItem for Remote View ^ //
class PeerListItem extends StatefulWidget {
  final Peer peer;
  final int index;
  final RemoteInfo remote;
  PeerListItem(this.peer, this.index, {this.remote});
  @override
  _PeerListItemState createState() => _PeerListItemState();
}

class _PeerListItemState extends State<PeerListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: Neumorph.floating(),
          margin: EdgeWith.horizontal(8),
          child: ExpansionTile(
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            leading: widget.peer.profilePicture(size: 50),
            title: "${widget.peer.profile.firstName} ${widget.peer.profile.lastName}".h3,
            subtitle: RichText(
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                text: TextSpan(children: [
                  TextSpan(
                      text: widget.peer.platform.toString(),
                      style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w600, fontSize: 20, color: SonrColor.Primary)),
                  TextSpan(
                      text: " - ${widget.peer.model}",
                      style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w300, fontSize: 20, color: SonrColor.AccentPurple)),
                ])),
            children: [
              Padding(padding: EdgeInsets.all(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorButton.neutral(onPressed: () {}, text: "Block"),
                  Padding(padding: EdgeInsets.all(8)),
                  ColorButton.primary(
                    onPressed: () {
                      if (widget.remote != null) {
                        Get.find<TransferController>().inviteWithPeer(widget.peer);
                      } else {
                        Get.find<TransferController>().inviteWithPeer(widget.peer);
                      }
                    },
                    text: "Invite",
                    icon: SonrIcons.Share,
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(8)),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.all(8))
      ],
    );
  }
}
