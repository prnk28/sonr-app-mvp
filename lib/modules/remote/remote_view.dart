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
    return Obx(() => Container(
          width: SonrStyle.viewSize.width,
          height: SonrStyle.viewSize.height,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: <Widget>[
                    Column(children: [
                      SonrText.header("Join Remote"),

                      // Check for Keyboard Open
                      controller.isJoinFieldTapped.value
                          ? SonrText.normal("Enter lobby code here.", color: SonrColor.Black.withOpacity(0.7), size: 18)
                          : LottieContainer(
                              type: LottieBoard.JoinRemote,
                              repeat: true,
                              height: 150,
                            ),
                      GestureDetector(
                        onTap: () => controller.handleJoinTap(),
                        child: Neumorphic(
                          padding: EdgeInsets.only(bottom: 8),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: OpacityAnimatedWidget(
                            duration: 400.milliseconds,
                            enabled: controller.isJoinFieldTapped.value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: TextField(onChanged: (value) => controller.firstWord(value), textInputAction: TextInputAction.next),
                                  width: SonrStyle.viewSize.width / 4.2,
                                ),
                                Container(
                                  child: TextField(onChanged: (value) => controller.secondWord(value), textInputAction: TextInputAction.next),
                                  width: SonrStyle.viewSize.width / 4.2,
                                ),
                                Container(
                                  child: TextField(onChanged: (value) => controller.thirdWord(value), textInputAction: TextInputAction.done),
                                  width: SonrStyle.viewSize.width / 4.2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(8)),
                      ColorButton.secondary(
                        text: "Join",
                        onPressed: () => controller.join(),
                      ),
                      Padding(padding: EdgeInsets.all(8)),
                    ])
                  ],
                ),
              ),
            ],
          ),
        ));
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
