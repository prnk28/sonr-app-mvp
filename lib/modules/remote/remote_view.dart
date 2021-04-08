import 'package:sonr_app/modules/common/lobby/remote_view.dart';
import 'package:sonr_app/theme/theme.dart';
import 'remote_controller.dart';

// ^ Main Card View ^ //
class RemoteView extends GetView<RemoteController> {
  RemoteView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
          width: Get.width,
          height: Get.height,
          margin: controller.status.value.currentMargin,
          duration: 1500.milliseconds,
          child: Neumorphic(
            style: SonrStyle.normal,
            child: AnimatedSlideSwitcher.fade(
              child: _buildView(controller.status.value),
              duration: const Duration(milliseconds: 2500),
            ),
          ),
        ));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(RemoteViewStatus status) {
    // Return View
    if (status == RemoteViewStatus.NotJoined) {
      return _JoinRemoteView(key: ValueKey<RemoteViewStatus>(RemoteViewStatus.NotJoined));
    } else if (status == RemoteViewStatus.Joined) {
      return RemoteLobbyCardView(key: ValueKey<RemoteViewStatus>(RemoteViewStatus.Joined));
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
          width: SonrStyle.viewSize.width,
          height: SonrStyle.viewSize.height,
          child: CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: <Widget>[
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title
                          SonrText.header("Join Remote"),

                          // Check for Button Tap
                          controller.isJoinFieldTapped.value
                              ? SonrText.normal("Enter lobby code below.", color: SonrColor.Black.withOpacity(0.7), size: 18)
                              : LottieContainer(
                                  type: LottieBoard.JoinRemote,
                                  repeat: true,
                                  height: 150,
                                ),
                          Padding(padding: EdgeInsets.all(8)),

                          // Swap Between Button and Text Field View
                          controller.isJoinFieldTapped.value
                              ? _RemoteTextCodeField()
                              : ColorButton.primary(onPressed: controller.handleJoinTap, text: "Enter Code"),
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

// ^ Enter Code View ^ //
class _RemoteTextCodeField extends GetView<RemoteController> {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
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
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, color: UserService.isDarkMode ? Colors.white : SonrColor.Black),
              ),
              width: SonrStyle.viewSize.width / 4.2,
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
                      TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, color: UserService.isDarkMode ? Colors.white : SonrColor.Black)),
              width: SonrStyle.viewSize.width / 4.2,
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
                      TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, color: UserService.isDarkMode ? Colors.white : SonrColor.Black)),
              width: SonrStyle.viewSize.width / 4.2,
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
      SonrText.header("Remote Invite View"),
      SonrText.normal("TODO: Display Invite thats received ", color: SonrColor.Black.withOpacity(0.7), size: 18),
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
      SonrText.header("Remote Progress View"),
      SonrText.normal("TODO: Display Lottie File with Animation Controller by Progress", color: SonrColor.Black.withOpacity(0.7), size: 18),
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
      SonrText.header("Remote View"),
      SonrText.normal("TODO: Display Received Transfer Card", color: SonrColor.Black.withOpacity(0.7), size: 18),
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}
