import 'package:intl/intl.dart';
import 'package:sonr_app/modules/peer/profile_view.dart';
import 'package:sonr_app/style.dart';
import 'activity_controller.dart';

class CurrentActivityItem extends GetView<ActivityController> {
  final Session session;
  const CurrentActivityItem({required this.session, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BoxContainer(
      height: 150,
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
                  profile: session.from.profile,
                ),
                _CurrentActivityContent(
                  firstName: session.from.profile.firstName,
                  payload: session.payload,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ActionButton(
                    onPressed: () {},
                    iconData: SonrIcons.Category,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 8)),
          _CurrentActivityProgress(progress: session.progress),
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
              child: payload.icon(color: SonrColor.AccentBlue, size: 18),
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
          ["${payload.toString().capitalizeFirst} from ".lightSpan(fontSize: 18), firstName.subheadingSpan(fontSize: 18)].rich(),

          // Date Time Text
          _buildDateTime().paragraph(fontSize: 16),
        ],
      ),
    );
  }

  String _buildDateTime() {
    final now = DateTime.now();
    final dateFormatter = DateFormat.yMMMd('en_US').add_jm();
    return dateFormatter.format(now);
  }
}

// @ Helper: Builds Transfer Progress
class _CurrentActivityProgress extends GetView<ActivityController> {
  final RxDouble progress;
  final double maxWidth = 260;

  _CurrentActivityProgress({required this.progress});
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: EdgeInsets.only(top: 8),
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
                  color: SonrTheme.foregroundColor,
                ),
              ),

              // Foreground Gradient
              Container(
                alignment: Alignment.center,
                width: _calculateWidth(progress.value),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), gradient: _calculateGradient(progress.value)),
              ),
              Align(
                alignment: Alignment.center,
                child: _calculateText(progress.value).subheading(fontSize: 16, color: _calculateTextColor(progress.value)),
              ),
            ],
          ),
        ));
  }

  Gradient _calculateGradient(double current) {
    int adjusted = (current * 100).round();
    if (adjusted != 100) {
      return SonrGradients.SeaShore;
    }
    return SonrGradient.Tertiary;
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
      return SonrColor.Black;
    }
    return SonrColor.White;
  }
}
