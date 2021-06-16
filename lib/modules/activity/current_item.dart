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
      height: 110,
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 80,
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
    return Stack(
      alignment: Alignment.center,
      children: [
        ProfileAvatar(profile: profile, size: 52),
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 24),
          child: CircleContainer(
            alignment: Alignment.center,
            width: 28,
            height: 28,
            child: payload.icon(color: SonrTheme.backgroundColor, size: 18),
          ),
        )
      ],
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
      height: 42,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rich Text
          ["${payload.toString()} from ".lightSpan(fontSize: 18), firstName.subheadingSpan(fontSize: 18)].rich(),

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
          clipBehavior: Clip.antiAlias,
          height: 14,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Bottom Layer
              Container(
                width: maxWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: SonrTheme.foregroundColor,
                ),
              ),

              // Foreground Gradient
              Container(
                width: _calculateWidth(progress.value),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: SonrGradient.Theme(radius: 2),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: _calculateText(progress.value).heading(fontSize: 12),
              ),
            ],
          ),
        ));
  }

  double _calculateWidth(double current) {
    return maxWidth * current;
  }

  String _calculateText(double current) {
    int adjusted = (current * 100).round();
    return "$adjusted %";
  }
}
