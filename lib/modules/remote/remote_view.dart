import 'package:sonr_app/theme/theme.dart';
import 'remote_controller.dart';

// ^ Main Card View ^ //
class RemoteView extends GetView<RemoteController> {
  RemoteView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      margin: SonrStyle.viewMargin,
      child: Neumorphic(
        style: SonrStyle.normal,
        child: Obx(() => AnimatedSlideSwitcher.fade(
              child: _buildView(controller.status.value),
              duration: const Duration(milliseconds: 2500),
            )),
      ),
    );
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(RemoteViewStatus status) {
    // Return View
    if (status == RemoteViewStatus.NotJoined) {
      return _RemoteInitialView(key: ValueKey<RemoteViewStatus>(RemoteViewStatus.NotJoined));
    } else if (status == RemoteViewStatus.Joined) {
      return _RemoteLobbyView(key: ValueKey<RemoteViewStatus>(RemoteViewStatus.Joined));
    } else if (status == RemoteViewStatus.Invited) {
      return _RemoteInviteView(key: ValueKey<RemoteViewStatus>(RemoteViewStatus.Invited));
    } else if (status == RemoteViewStatus.InProgress) {
      return _RemoteProgressView(key: ValueKey<RemoteViewStatus>(RemoteViewStatus.InProgress));
    } else {
      return _RemoteCompletedView(key: ValueKey<RemoteViewStatus>(RemoteViewStatus.Done));
    }
  }
}

// ^ Join a Remote View ^ //
class _RemoteInitialView extends GetView<RemoteController> {
  _RemoteInitialView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      SonrText.header("Remote View"),
      SonrText.normal("Share to begin viewing your Cards!", color: SonrColor.Black.withOpacity(0.7), size: 18),
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}

// ^ Within Remote View ^ //
class _RemoteLobbyView extends GetView<RemoteController> {
  _RemoteLobbyView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      SonrText.header("Remote View"),
      SonrText.normal("Share to begin viewing your Cards!", color: SonrColor.Black.withOpacity(0.7), size: 18),
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}

// ^ Received Remote Invite View ^ //
class _RemoteInviteView extends GetView<RemoteController> {
  _RemoteInviteView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      SonrText.header("Remote View"),
      SonrText.normal("Share to begin viewing your Cards!", color: SonrColor.Black.withOpacity(0.7), size: 18),
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}

// ^ During Remote Transfer View ^ //

class _RemoteProgressView extends GetView<RemoteController> {
  _RemoteProgressView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      SonrText.header("Remote View"),
      SonrText.normal("Share to begin viewing your Cards!", color: SonrColor.Black.withOpacity(0.7), size: 18),
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}

// ^  Remote Completed View ^ //

class _RemoteCompletedView extends GetView<RemoteController> {
  _RemoteCompletedView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      SonrText.header("Remote View"),
      SonrText.normal("Share to begin viewing your Cards!", color: SonrColor.Black.withOpacity(0.7), size: 18),
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}
