import 'package:sonr_app/modules/peer/item_view.dart';
import 'package:sonr_app/theme/theme.dart';
import 'remote_controller.dart';

// ^ Main Card View ^ //
class RemoteView extends GetView<RemoteController> {
  RemoteView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
        child: Obx(
      () => AnimatedSlideSwitcher.fade(
        child: _buildView(controller.status.value),
        duration: const Duration(milliseconds: 2500),
      ),
    ));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(RemoteViewStatus status) {
    // Return View
    if (status == RemoteViewStatus.NotJoined) {
      return _JoinRemoteView(key: ValueKey<RemoteViewStatus>(RemoteViewStatus.NotJoined));
    } else if (status == RemoteViewStatus.Joined) {
      return RemoteLobbyView(key: ValueKey<RemoteViewStatus>(RemoteViewStatus.Joined));
    } else if (status == RemoteViewStatus.Invited) {
      return RemoteInviteView(key: ValueKey<RemoteViewStatus>(RemoteViewStatus.Invited));
    } else if (status == RemoteViewStatus.InProgress) {
      return RemoteProgressView(key: ValueKey<RemoteViewStatus>(RemoteViewStatus.InProgress));
    } else {
      return RemoteCompletedView(key: ValueKey<RemoteViewStatus>(RemoteViewStatus.Done));
    }
  }
}

// ^ Join a Remote View ^ //
class _JoinRemoteView extends GetView<RemoteController> {
  _JoinRemoteView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Check for Button Tap
                    controller.isJoinFieldTapped.value
                        ? "Enter lobby code below.".p_Grey
                        : Container(
                            child: SonrAssetIllustration.CreateGroup.widget,
                            height: 275,
                          ),

                    // Title
                    "Remote Lobby".h3,

                    "Enter a Lobby Code, to join a \nRemote Lobby.".p_Grey,

                    // Swap Between Button and Text Field View
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: controller.isJoinFieldTapped.value
                          ? _RemoteTextCodeField()
                          : ColorButton.primary(onPressed: controller.handleJoinTap, text: "Join"),
                    ),
                    Padding(padding: EdgeInsets.all(8)),
                  ])
            ],
          ),
        )));
  }
}

// ^ Card Aspect Ratio Remote View ^ //
class RemoteLobbyView extends GetView<RemoteController> {
  RemoteLobbyView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      "${controller.remoteInfo.value.display}".h2,
      Expanded(
          child: ListView.builder(
        itemCount: controller.remoteLobby.value.length,
        itemBuilder: (BuildContext context, int index) {
          // Build List Item
          return PeerListItem(
            controller.remoteLobby.value.peerAtIndex(index - 1),
            index - 1,
            remote: controller.remoteInfo.value,
          );
        },
      )),
      Padding(padding: EdgeInsets.all(8)),
    ]);
  }
}

// ^ Enter Code View ^ //
class _RemoteTextCodeField extends GetView<RemoteController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Neumorphic.floating(),
      padding: EdgeInsets.only(bottom: 8),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: OpacityAnimatedWidget(
        duration: 400.milliseconds,
        enabled: controller.isJoinFieldTapped.value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 4),
              child: TextField(
                showCursor: false,
                autocorrect: false,
                onChanged: (value) => controller.firstWord(value),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.center,
                autofocus: controller.isJoinFieldTapped.value,
                style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400, color: UserService.isDarkMode ? Colors.white : SonrColor.Black),
              ),
              width: Width.ratio(0.2),
            ),
            Container(
              margin: EdgeInsets.only(left: 2, right: 2),
              child: TextField(
                  showCursor: false,
                  autocorrect: false,
                  onChanged: (value) => controller.secondWord(value),
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.next,
                  style:
                      TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400, color: UserService.isDarkMode ? Colors.white : SonrColor.Black)),
              width: Width.ratio(0.2),
            ),
            Container(
              margin: EdgeInsets.only(right: 4),
              child: TextField(
                  showCursor: false,
                  autocorrect: false,
                  onSubmitted: (val) => controller.join(),
                  onChanged: (value) => controller.thirdWord(value),
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.done,
                  style:
                      TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400, color: UserService.isDarkMode ? Colors.white : SonrColor.Black)),
              width: Width.ratio(0.2),
            ),
          ],
        ),
      ),
    );
  }
}

// ^ Received Remote Invite View ^ //
class RemoteInviteView extends GetView<RemoteController> {
  RemoteInviteView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      "Remote Invite View".h2,
      "TODO: Display Invite thats received ".p_Grey,
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}

// ^ During Remote Transfer View ^ //

class RemoteProgressView extends GetView<RemoteController> {
  RemoteProgressView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //return Center();
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      "Remote Progress View".h2,
      "TODO: Display Lottie File with Animation Controller by Progress".p_Grey,
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}

// ^  Remote Completed View ^ //

class RemoteCompletedView extends GetView<RemoteController> {
  RemoteCompletedView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      "Remote View".h2,
      "TODO: Display Received Transfer Card".p_Grey,
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}
