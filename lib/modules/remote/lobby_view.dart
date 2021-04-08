// ^ Within Remote View ^ //
import 'package:sonr_app/common/peer/item_view.dart';
import 'package:sonr_app/theme/theme.dart';
import 'remote_controller.dart';

class RemoteLobbyView extends GetView<RemoteController> {
  RemoteLobbyView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          SonrText.header("${controller.currentRemote.value.display}"),
          Expanded(
              child: ListView.builder(
            itemCount: controller.currentLobby.value != null ? controller.currentLobby.value.length + 1 : 1,
            itemBuilder: (BuildContext context, int index) {
              // Build List Item
              return PeerListItem(
                controller.currentLobby.value.atIndex(index - 1),
                index - 1,
                remote: controller.currentRemote.value,
              );
            },
          )),
          Padding(padding: EdgeInsets.all(8)),
        ]));
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
