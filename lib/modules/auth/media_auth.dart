import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

// ^ File Invite Builds from Invite Protobuf ^ //
class MediaAuthView extends StatelessWidget {
  final AuthInvite? invite;
  MediaAuthView(this.invite);

  @override
  Widget build(BuildContext context) {
    return NeumorphicAvatarCard(
      profile: invite!.from.profile,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        key: UniqueKey(),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // @ Header
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // From Information
            Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              invite!.from.profile.hasLastName()
                  ? "${invite!.from.profile.firstName} ${invite!.from.profile.lastName}".gradient(value: SonrGradients.SolidStone)
                  : "${invite!.from.profile.firstName}".gradient(value: SonrGradients.SolidStone),
              Row(children: [
                invite!.payload.toString().capitalizeFirst!.gradient(value: SonrGradients.PlumBath, size: 22),
                "   ${invite!.file.prettySize()}".h5
              ]),
            ]),
          ]),
          Divider(),
          Container(
            width: invite!.file.single.thumbnail.length > 0 ? Get.width - 50 : Get.width - 150,
            height: invite!.file.single.thumbnail.length > 0 ? Get.height / 3 : Get.height / 5,
            child: invite!.file.single.thumbnail.length > 0
                ? Image.memory(
                    Uint8List.fromList(invite!.file.single.thumbnail),
                    width: Get.width - 50,
                    height: Get.height / 3,
                  )
                : invite!.file.single.mime.type.gradient(),
          ),
          Divider(),
          Padding(padding: EdgeInsets.all(4)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorButton.primary(
                onPressed: () => CardService.handleInviteResponse(true, invite!),
                text: "Accept",
                gradient: SonrGradient.Tertiary,
                icon: SonrIcons.Check,
                margin: EdgeInsets.symmetric(horizontal: 54),
              ),
              Padding(padding: EdgeInsets.all(8)),
              PlainTextButton(onPressed: () => CardService.handleInviteResponse(false, invite!), text: "Decline"),
            ],
          ),
        ],
      ),
    );
  }
}
