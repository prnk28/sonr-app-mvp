import 'dart:typed_data';
import 'package:get/get.dart';
import 'media.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ File Invite Builds from Invite Protobuf ^ //
class MediaAuthView extends StatelessWidget {
  final AuthInvite invite;
  MediaAuthView(this.invite);

  @override
  Widget build(BuildContext context) {
    // Build View
    final card = invite.card;
    return Container(
      height: context.heightTransformer(reducedBy: 35),
      width: context.widthTransformer(reducedBy: 10),
      child: Neumorphic(
        style: SonrStyle.normal,
        margin: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          key: UniqueKey(),
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // @ Header
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              // Build Profile Pic
              Container(
                child: Icon(
                  Icons.insert_emoticon,
                  size: 60,
                  color: SonrColor.Black.withOpacity(0.5),
                ),

                //   invite.from.profile.hasPicture()
                // ? Image.memory(
                //     Uint8List.fromList(invite.from.profile.picture),
                //     width: 60,
                //     height: 60,
                //   )
                // :
              ),

              // From Information
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                invite.from.profile.hasLastName()
                    ? SonrText.gradient(invite.from.profile.firstName + " " + invite.from.profile.lastName, FlutterGradientNames.premiumDark,
                        size: 32)
                    : SonrText.gradient(invite.from.profile.firstName, FlutterGradientNames.premiumDark, size: 32),
                Row(children: [
                  SonrText.gradient(card.metadata.mime.type.toString().capitalizeFirst, FlutterGradientNames.plumBath, size: 22),
                  "   ${card.metadata.sizeString}".h5
                ]),
              ]),
            ]),
            Divider(),
            Container(
              width: card.metadata.thumbnail.isNotEmpty ? Get.width - 50 : Get.width - 150,
              height: card.metadata.thumbnail.isNotEmpty ? Get.height / 3 : Get.height / 5,
              child: card.metadata.thumbnail.isNotEmpty
                  ? Image.memory(
                      Uint8List.fromList(card.metadata.thumbnail),
                      width: Get.width - 50,
                      height: Get.height / 3,
                    )
                  : SonrIcon.withMime(card.metadata.mime, size: 60),
            ),
            Divider(),
            Padding(padding: EdgeInsets.all(4)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColorButton.neutral(onPressed: () => CardService.handleInviteResponse(false, invite, card), text: "Decline"),
                Padding(padding: EdgeInsets.all(8)),
                ColorButton.primary(
                  onPressed: () => CardService.handleInviteResponse(true, invite, card),
                  text: "Accept",
                  gradient: SonrPalette.tertiary(),
                  icon: SonrIcon.gradient(Icons.check, FlutterGradientNames.newLife, size: 28),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
