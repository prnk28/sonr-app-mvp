import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

/// @ File Invite Builds from Invite Protobuf
class MediaAuthView extends StatelessWidget {
  final AuthInvite invite;
  MediaAuthView(this.invite);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      key: UniqueKey(),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: invite.file.single.thumbBuffer.length > 0 ? Get.width - 50 : Get.width - 150,
          height: invite.file.single.thumbBuffer.length > 0 ? Get.height / 3 - 136 : Get.height / 5,
          child: invite.file.single.thumbBuffer.length > 0
              ? Image.memory(
                  Uint8List.fromList(invite.file.single.thumbBuffer),
                  width: Get.width - 50,
                  height: Get.height / 3,
                )
              : invite.file.single.mime.type.gradient(),
        ),
        Divider(),
        Padding(padding: EdgeInsets.all(4)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorButton.primary(
              onPressed: () => CardService.handleInviteResponse(true, invite),
              text: "Accept",
              gradient: SonrGradient.Tertiary,
              icon: SonrIcons.Check,
              margin: EdgeInsets.symmetric(horizontal: 54),
            ),
            Padding(padding: EdgeInsets.all(8)),
            PlainTextButton(onPressed: () => CardService.handleInviteResponse(false, invite), text: "Decline".paragraph(color: Get.theme.hintColor)),
          ],
        ),
      ],
    );
  }
}
