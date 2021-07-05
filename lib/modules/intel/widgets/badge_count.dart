import 'package:sonr_app/modules/intel/intel.dart';
import 'package:sonr_app/style/style.dart';

class IntelBadgeCount extends StatelessWidget {
  final LobbyInfo info;

  const IntelBadgeCount({Key? key, required this.info}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildText(),
          _buildIcon(),
        ],
      ),
    );
  }

  Widget _buildText() {
    return FadeIn(
      animate: true,
      child: info.differenceCount.toString().light(
            color: info.hasJoined ? SonrColor.Tertiary : SonrColor.Critical,
          ),
    );
  }

  Widget _buildIcon() {
    if (info.hasJoined) {
      return FadeInUp(
        animate: true,
        from: 40,
        duration: 300.milliseconds,
        child: SonrIcons.Up.icon(
          color: AppTheme.itemColor,
          size: 14,
        ),
      );
    } else {
      return FadeInDown(
        animate: true,
        from: 40,
        duration: 300.milliseconds,
        child: SonrIcons.Down.icon(
          color: SonrColor.Critical,
          size: 14,
        ),
      );
    }
  }
}
