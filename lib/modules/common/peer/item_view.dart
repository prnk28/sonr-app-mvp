import 'package:sonr_app/theme/theme.dart';
import 'peer.dart';

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
        Neumorphic(
            margin: EdgeWith.horizontal(8),
            child: ExpansionTile(
              backgroundColor: Colors.transparent,
              collapsedBackgroundColor: Colors.transparent,
              leading: widget.peer.profilePicture(size: 50),
              title: SonrText.subtitle(widget.peer.profile.firstName + " " + widget.peer.profile.lastName, isCentered: true),
              subtitle: SonrText("",
                  isRich: true,
                  richText: RichText(
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      text: TextSpan(children: [
                        TextSpan(
                            text: widget.peer.platform.toString(),
                            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 20, color: SonrPalette.Primary)),
                        TextSpan(
                            text: " - ${widget.peer.model}",
                            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300, fontSize: 20, color: SonrPalette.Secondary)),
                      ]))),
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
                          SonrService.inviteWithPeer(widget.peer, info: widget.remote);
                        } else {
                          SonrService.inviteWithPeer(widget.peer);
                        }
                      },
                      text: "Invite",
                      icon: SonrIcon.invite,
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(8)),
              ],
            ),
            style: SonrStyle.normal),
        Padding(padding: EdgeInsets.all(8))
      ],
    );
  }
}