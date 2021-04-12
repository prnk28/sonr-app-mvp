import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'file.dart';

// ^ File Invite Builds from Invite Protobuf ^ //
class FileAuthView extends StatelessWidget {
  final AuthInvite invite;
  FileAuthView(this.invite);

  @override
  Widget build(BuildContext context) {
    final card = invite.card;
    return Container(
        height: context.heightTransformer(reducedBy: 35),
        width: context.widthTransformer(reducedBy: 10),
        child: NeumorphicBackground(
            backendColor: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: Neumorphic(
              style: SonrStyle.normal,
              margin: EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                key: UniqueKey(),
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(children: [
                    // Build Profile Pic
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, left: 8),
                        child: Neumorphic(
                          padding: EdgeInsets.all(4),
                          style: NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.circle(),
                            depth: -10,
                          ),
                          child: invite.from.profile.hasPicture()
                              ? Image.memory(Uint8List.fromList(invite.from.profile.picture))
                              : Icon(
                                  Icons.insert_emoticon,
                                  size: 100,
                                  color: SonrColor.Black.withOpacity(0.5),
                                ),
                        ),
                      ),
                    ),
                    // Create Spacing
                    Padding(padding: EdgeInsets.all(6)),
                    // From Information
                    Column(children: [
                      invite.from.profile.hasLastName()
                          ? SonrText.gradient(invite.from.profile.firstName + " " + invite.from.profile.lastName, FlutterGradientNames.premiumDark,
                              size: 38)
                          : SonrText.gradient(invite.from.profile.firstName, FlutterGradientNames.premiumDark, size: 38),
                      Row(children: [
                        SonrText.gradient(card.payload.toString().capitalizeFirst, FlutterGradientNames.plumBath, size: 22),
                        "   ${card.metadata.sizeString}".h5
                      ]),
                    ]),
                  ]),
                  Divider(),
                  Container(
                    width: Get.width - 50,
                    height: Get.height / 3,
                    child: Neumorphic(
                        padding: EdgeInsets.all(8),
                        style: NeumorphicStyle(
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                          depth: -10,
                        ),
                        child: RiveContainer(type: RiveBoard.Documents, width: Get.width - 150, height: Get.height / 3)),
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
            )));
  }
}
