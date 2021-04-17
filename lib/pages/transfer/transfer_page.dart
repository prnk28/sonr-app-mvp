import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/model/model_file.dart';
import 'package:sonr_app/modules/common/peer/peer.dart';
import 'package:sonr_app/theme/theme.dart';
import 'lobby_view.dart';
import 'transfer_controller.dart';

// ^ Transfer Screen Entry with Arguments ^ //
class Transfer {
  static void transferWithContact() {
    Get.offNamed("/transfer", arguments: TransferArguments(Payload.CONTACT, contact: UserService.contact.value));
  }

  static void transferWithFile(FileItem fileItem) {
    Get.offNamed("/transfer", arguments: TransferArguments(fileItem.payload, metadata: fileItem.metadata, item: fileItem));
  }

  static void transferWithUrl(String url) {
    Get.offNamed("/transfer", arguments: TransferArguments(Payload.URL, url: url));
  }
}

// ^ Transfer Screen Entry Point ^ //
class TransferScreen extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    // Set Payload from Args
    controller.setPayload(Get.arguments);

    // Build View
    return Obx(
      () {
        if (controller.isRemoteActive.value) {
          return RemoteLobbyFullView(info: controller.remote.value);
        } else {
          return LocalLobbyView();
        }
      },
    );
  }
}

// ^ Fullscreen Remote View ^ //
class RemoteLobbyFullView extends HookWidget {
  RemoteLobbyFullView({Key key, @required this.info}) : super(key: key);
  final RemoteInfo info;

  @override
  Widget build(BuildContext context) {
    final remoteStream = LobbyService.useRemoteLobby(info);
    return SonrScaffold(
        gradientName: FlutterGradientNames.plumBath,
        appBar: DesignAppBar(
          action: PlainButton(icon: SonrIcons.Logout, onPressed: () => Get.find<TransferController>().stopRemote()),
          leading: PlainButton(icon: SonrIcons.Close, onPressed: () => Get.offNamed("/home")),
          title: _buildTitleWidget(),
        ),
        body: ListView.builder(
            itemCount: remoteStream != null ? remoteStream.data.length + 1 : 1,
            itemBuilder: (BuildContext context, int index) {
              return PeerListItem(
                remoteStream.data.atIndex(index),
                index,
                remote: info,
              );
            }));
  }

  // # Update Title Widget
  Widget _buildTitleWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      "Remote".h3,
      IconButton(
        icon: Icon(Icons.info_outline),
        onPressed: () {
          SonrSnack.remote(message: info.display, duration: 12000);
        },
      )
    ]);
  }
}
