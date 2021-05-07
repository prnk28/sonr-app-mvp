import 'package:get/get.dart';
import 'package:sonr_app/modules/peer/profile_view.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

/// ^ File Invite Builds from Invite Protobuf ^ //
class FileAuthView extends StatelessWidget {
  final AuthInvite invite;
  FileAuthView(this.invite);

  @override
  Widget build(BuildContext context) {
    return NeumorphicAvatarCard(
        profile: invite.from.profile,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          key: UniqueKey(),
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(children: [
              // Create Spacing
              Padding(padding: EdgeInsets.all(6)),
              // From Information
              Column(children: [
                ProfileName(profile: invite.from.profile, isHeader: true),
                Row(children: [
                  invite.payload.toString().capitalizeFirst!.gradient(value: SonrGradients.PlumBath, size: 22),
                  "   ${invite.file.prettySize()}".h5
                ]),
              ]),
            ]),
            Divider(),
            Container(
              width: Get.width - 50,
              height: Get.height / 3,
              decoration: Neumorphic.floating(),
              padding: EdgeInsets.all(8),
              child: RiveContainer(type: RiveBoard.Documents, width: Get.width - 150, height: Get.height / 3),
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
                PlainTextButton(onPressed: () => CardService.handleInviteResponse(false, invite), text: "Decline"),
              ],
            ),
          ],
        ));
  }
}
