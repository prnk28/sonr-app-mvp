import 'package:sonr_app/modules/peer/peer.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:sonr_app/style/style.dart';

extension CompareLobbyResultUtil on CompareLobbyResult {
  List<Widget> mapNearby() {
    if (this.current != null) {
      if (hasMoreThanVisible) {
        final firstValues = this.current!.peers.values.take(4).toList();
        return firstValues.map<Widget>((value) => PeerItem.mini(value)).toList();
      } else {
        return this.current!.peers.values.map<Widget>((value) => PeerItem.mini(value)).toList();
      }
    } else {
      return [];
    }
  }

  Widget text() {
    if (!this.hasStayed) {
      return FadeIn(
        animate: true,
        child: this.differenceCount.toString().light(
              color: this.hasJoined ? SonrColor.Tertiary : SonrColor.Critical,
            ),
      );
    } else {
      return Container();
    }
  }

  Widget icon() {
    if (this.hasJoined) {
      return Center(
        child: FadeInUp(
          animate: true,
          duration: 300.milliseconds,
          child: SonrIcons.Up.icon(
            color: AppTheme.itemColor,
            size: 14,
          ),
        ),
      );
    } else if (this.hasLeft) {
      return Center(
        child: FadeInDown(
          animate: true,
          from: 40,
          duration: 300.milliseconds,
          child: SonrIcons.Down.icon(
            color: SonrColor.Critical,
            size: 14,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
