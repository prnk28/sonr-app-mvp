import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style/style.dart';

/// #### PeerListItem for Remote View
class PeerLinkerItem extends StatelessWidget {
  final Peer peer;
  final Function onPressed;
  PeerLinkerItem({required this.peer, required this.onPressed});
  @override
  Widget build(BuildContext context) {
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
              ColorButton.neutral(
                text: 'Link',
                onPressed: () => this.onPressed(),
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

  /// #### Method Builds Host Name Cleaned
  String get _cleanHostName => peer.hostName.substring(peer.hostName.indexOf('.') + 1);

  /// ### Method Builds Title Widget
  Widget _buildTitle() {
    return [
      "${_cleanHostName} \n".subheadingSpan(fontSize: 20),
      " ${peer.sName}.snr/".paragraphSpan(fontSize: 16),
    ].rich();
  }

  /// ### Method Builds Avatar Widget
  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Align(
          alignment: Alignment.center,
          child: peer.platform.icon(size: 32),
        ),
        Positioned.directional(
          textDirection: TextDirection.rtl,
          child: peer.platform.icon(color: AppTheme.ItemColor.withOpacity(0.75), size: 26),
          start: 14,
          bottom: 4,
        )
      ],
    );
  }
}
