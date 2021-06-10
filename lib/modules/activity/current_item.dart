import 'package:sonr_app/style.dart';
import 'activity_controller.dart';

class CurrentActivityItem extends GetView<ActivityController> {
  const CurrentActivityItem({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.only(bottom: 24),
      child: Container(
        decoration: SonrTheme.cardDecoration,
        child: Row(
          children: [
            _CurrentActivityPeer(),
            _CurrentActivityContent(),
            _CurrentActivityProgress(),
          ],
        ),
      ),
    );
  }
}

// @ Helper: Builds Peer Info
class _CurrentActivityPeer extends GetView<ActivityController> {
  @override
  Widget build(BuildContext context) {
    return Text("Peer");
  }
}

// @ Helper: Builds File Info
class _CurrentActivityContent extends GetView<ActivityController> {
  @override
  Widget build(BuildContext context) {
    return Text("Content");
  }
}

// @ Helper: Builds Transfer Progress
class _CurrentActivityProgress extends GetView<ActivityController> {
  @override
  Widget build(BuildContext context) {
    return Text("Progress: ${controller.currentActivity.progress.value}");
  }
}
