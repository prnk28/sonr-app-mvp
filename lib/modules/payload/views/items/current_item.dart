import 'package:sonr_app/modules/activity/activity.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/modules/peer/peer.dart';

class CurrentReceiveItem extends GetView<ActivityController> {
  final Session session;
  const CurrentReceiveItem({required this.session, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BoxContainer(
      height: session.total.value > 1 ? 175 : 150,
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CurrentActivityPeer(
                  payload: session.payload,
                  profile: session.from.active.profile,
                ),
                _CurrentActivityContent(
                  firstName: session.from.active.profile.firstName,
                  payload: session.payload,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ActionButton(
                    onPressed: () {},
                    iconData: SimpleIcons.Category,
                  ),
                ),
              ],
            ),
          ),
          _CurrentActivityProgress(progress: session.progress),
          _CurrentActivityIndexLabel(
            current: session.current,
            total: session.total.value,
          )
        ],
      ),
    );
  }
}

// @ Helper: Builds Peer Info
class _CurrentActivityPeer extends GetView<ActivityController> {
  final Profile profile;
  final Payload payload;

  _CurrentActivityPeer({required this.profile, required this.payload});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ProfileAvatar(profile: profile, size: 52),
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 24),
            child: CircleContainer(
              alignment: Alignment.center,
              width: 28,
              height: 28,
              child: payload.icon(color: AppColor.Blue, size: 20),
            ),
          )
        ],
      ),
    );
  }
}

// @ Helper: Builds Session Info
class _CurrentActivityContent extends GetView<ActivityController> {
  final String firstName;
  final Payload payload;

  _CurrentActivityContent({
    required this.firstName,
    required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rich Text
          [
            "${payload.toString().capitalizeFirst} from ".lightSpan(
              fontSize: 18,
              color: AppTheme.ItemColor,
            ),
            firstName.capitalizeFirst!.subheadingSpan(
              fontSize: 18,
              color: AppTheme.ItemColor,
            )
          ].rich(),

          // Date Time Text
          DateText(
            date: DateTime.now(),
            fontSize: 16,
            color: AppTheme.ItemColor,
          )
        ],
      ),
    );
  }
}

// @ Helper: Builds Transfer Progress
class _CurrentActivityProgress extends GetView<ActivityController> {
  final RxDouble progress;
  final double maxWidth = 260;

  _CurrentActivityProgress({required this.progress});
  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 42),
            alignment: Alignment.center,
            height: 32,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Bottom Layer
                Container(
                  alignment: Alignment.center,
                  width: maxWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: AppTheme.ForegroundColor,
                  ),
                ),

                // Foreground Gradient
                AnimatedContainer(
                  alignment: Alignment.center,
                  width: _calculateWidth(progress.value),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), gradient: _calculateGradient(progress.value)),
                  duration: 100.milliseconds,
                ),

                // Progress of Transfer
                Align(
                  alignment: Alignment.center,
                  child: AnimatedSlider.slideUp(
                    child: Container(
                      key: ValueKey<double>(progress.value),
                      child: _calculateText(progress.value).subheading(
                        fontSize: 16,
                        color: _calculateTextColor(progress.value),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Gradient _calculateGradient(double current) {
    int adjusted = (current * 100).round();
    if (adjusted != 100) {
      return DesignGradients.SeaShore;
    }
    return DesignGradients.ItmeoBranding;
  }

  double _calculateWidth(double current) {
    return maxWidth * current;
  }

  String _calculateText(double current) {
    int adjusted = (current * 100).round();
    if (adjusted != 100) {
      return "$adjusted %";
    } else {
      return "Complete!";
    }
  }

  Color _calculateTextColor(double current) {
    int adjusted = (current * 100).round();
    if (adjusted < 60) {
      return AppTheme.ItemColor;
    }
    return AppTheme.ItemColorInversed;
  }
}

class _CurrentActivityIndexLabel extends StatelessWidget {
  final RxInt current;
  final int total;

  const _CurrentActivityIndexLabel({Key? key, required this.current, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (total != 1) {
      return Obx(() => Container(padding: EdgeInsets.only(top: 8), alignment: Alignment.center, child: _buildLabel(current.value, total)));
    }
    return Container();
  }

  Widget _buildLabel(int current, int total) {
    return "($current / $total)".light(
      fontSize: 14,
      color: AppTheme.GreyColor,
    );
  }
}
