import 'package:get/get.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:sonr_app/data/data.dart';

// ^ File Invite Builds from Invite Protobuf ^ //
class FileAuthView extends StatelessWidget {
  final AuthInvite invite;
  FileAuthView(this.invite);

  @override
  Widget build(BuildContext context) {
    final card = invite.card;
    return NeumorphAvatarCard(
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
                invite.from.profile.hasLastName()
                    ? "${invite.from.profile.firstName} ${invite.from.profile.lastName}".gradient(gradient: FlutterGradientNames.solidStone)
                    : "${invite.from.profile.firstName}".gradient(gradient: FlutterGradientNames.solidStone),
                Row(children: [
                  card.payload.toString().capitalizeFirst.gradient(gradient: FlutterGradientNames.plumBath, size: 22),
                  "   ${card.file.sizeString}".h5
                ]),
              ]),
            ]),
            Divider(),
            Container(
              width: Get.width - 50,
              height: Get.height / 3,
              decoration: Neumorph.floating(),
              padding: EdgeInsets.all(8),
              child: RiveContainer(type: RiveBoard.Documents, width: Get.width - 150, height: Get.height / 3),
            ),
            Divider(),
            Padding(padding: EdgeInsets.all(4)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColorButton.primary(
                  onPressed: () => CardService.handleInviteResponse(true, invite, card),
                  text: "Accept",
                  gradient: SonrGradient.Tertiary,
                  icon: SonrIcons.Check,
                  margin: EdgeInsets.symmetric(horizontal: 54),
                ),
                Padding(padding: EdgeInsets.all(8)),
                PlainTextButton(onPressed: () => CardService.handleInviteResponse(false, invite, card), text: "Decline"),
              ],
            ),
          ],
        ));
  }
}
