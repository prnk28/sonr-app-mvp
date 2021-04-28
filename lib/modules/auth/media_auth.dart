import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

// ^ File Invite Builds from Invite Protobuf ^ //
class MediaAuthView extends StatelessWidget {
  final AuthInvite invite;
  MediaAuthView(this.invite);

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
          // @ Header
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // From Information
            Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              invite.from.profile.hasLastName()
                  ? "${invite.from.profile.firstName} ${invite.from.profile.lastName}".gradient(gradient: FlutterGradientNames.solidStone)
                  : "${invite.from.profile.firstName}".gradient(gradient: FlutterGradientNames.solidStone),
              Row(children: [
                card.payload.toString().capitalizeFirst.gradient(gradient: FlutterGradientNames.plumBath, size: 22),
                "   ${card.metadata.sizeString}".h5
              ]),
            ]),
          ]),
          Divider(),
          Container(
            width: card.metadata.thumbnail.length > 0 ? Get.width - 50 : Get.width - 150,
            height: card.metadata.thumbnail.length > 0 ? Get.height / 3 : Get.height / 5,
            child: card.metadata.thumbnail.length > 0
                ? Image.memory(
                    Uint8List.fromList(card.metadata.thumbnail),
                    width: Get.width - 50,
                    height: Get.height / 3,
                  )
                : card.metadata.mime.type.gradient(),
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
      ),
    );
  }
}
