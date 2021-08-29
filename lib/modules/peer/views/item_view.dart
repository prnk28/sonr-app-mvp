import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/modules/peer/peer.dart';

/// #### PeerListItem for Remote View
class PeerListItem extends GetWidget<PeerController> {
  final Member member;
  final int index;
  PeerListItem({required this.member, required this.index});
  @override
  Widget build(BuildContext context) {
    controller.initalize(member, setAnimated: false);
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
            color: AppTheme.DividerColor,
          ),
        ]));
  }

  Widget _buildTitle() {
    return [
      "${member.active.profile.fullName} \n".subheadingSpan(fontSize: 20),
      " ${member.active.sName}.snr/".paragraphSpan(fontSize: 16),
    ].rich();
  }

  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Align(
          alignment: Alignment.center,
          child: ProfileAvatar.fromPeer(
            member.active,
            size: 64,
            backgroundColor: Color(0xff8E8E93).withOpacity(0.3),
          ),
        ),
        Positioned.directional(
          textDirection: TextDirection.rtl,
          child: member.active.platform.icon(color: AppTheme.ItemColor.withOpacity(0.75), size: 26),
          start: 14,
          bottom: 4,
        )
      ],
    );
  }
}
