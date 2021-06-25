import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style.dart';
import 'peer.dart';

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
        child: Column(children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: _buildAvatar(),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: _buildTitle(),
              ),
              Spacer(),
              DynamicSolidButton(
                data: controller.buttonData,
                onPressed: () => controller.invite(),
              )
            ],
          ),
          Divider(
            indent: 8,
            endIndent: 8,
            color: AppTheme.dividerColor,
          ),
        ]));
  }

  Widget _buildTitle() {
    return [
      "${peer.profile.fullName} \n".subheadingSpan(fontSize: 20),
      " ${peer.sName}.snr/".paragraphSpan(fontSize: 16),
    ].rich();
  }

  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Align(
          alignment: Alignment.center,
          child: ProfileAvatar.fromPeer(
            peer,
            size: 64,
            backgroundColor: Color(0xff8E8E93).withOpacity(0.3),
          ),
        ),
        Positioned.directional(
          textDirection: TextDirection.rtl,
          child: peer.platform.icon(color: AppTheme.itemColor.withOpacity(0.75), size: 26),
          start: 14,
          bottom: 4,
        )
      ],
    );
  }
}
