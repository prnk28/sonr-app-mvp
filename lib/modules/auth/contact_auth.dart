import 'package:sonr_app/modules/peer/profile_view.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:get/get.dart';

/// @ Contact Invite from AuthInvite Proftobuf
class ContactAuthView extends StatelessWidget {
  final AuthInvite? invite;
  final AuthReply? reply;
  final bool isReply;
  ContactAuthView(this.isReply, {this.invite, this.reply});

  @override
  Widget build(BuildContext context) {
    Contact card;
    if (isReply) {
      card = reply!.card.contact;
    } else {
      card = invite!.contact;
    }
    return Container(
      height: context.heightTransformer(reducedBy: 35),
      width: context.widthTransformer(reducedBy: 10),
      decoration: Neumorphic.floating(
        theme: Get.theme,
      ),
      child: Column(children: [
        Row(children: [
          // @ Photo
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 8),
              child: Container(
                decoration: Neumorphic.floating(
                  theme: Get.theme,
                ),
                padding: EdgeInsets.all(4),
                child: ProfileAvatar(profile: card.profile),
              ),
            ),
          ),
          VerticalDivider(),
          Padding(padding: EdgeInsets.all(4)),
          // @ Content
          Container(
            margin: EdgeInsets.only(right: 8),
            child: Column(children: [
              // Name
              ProfileName(profile: card.profile, isHeader: false),

              // Phone/ Website
              Row(children: [
                card.platform.gradient(size: 20),
                // Hide PhoneNumber
                Padding(padding: EdgeInsets.all(10)),
                // card.contact.phoneNumber,
                // card.contact.webSite,
              ]),
            ]),
          ),
        ]),
        // Social Media
        Container(
          margin: EdgeInsets.only(top: 8, left: 40, right: 40, bottom: 8),
          child: Row(children: card.mapSocials((social) => social.media.gradient(size: 32)) as List<Widget>),
        ),
        Divider(),
        Padding(padding: EdgeInsets.all(4)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorButton.neutral(onPressed: () => SonrOverlay.back(), text: "Decline"),
            Padding(padding: EdgeInsets.all(8)),
            ColorButton.primary(
              onPressed: () async {
                SonrOverlay.back();
                if (!isReply) {
                  var result = await SonrOverlay.question(title: "Send Back", description: "Would you like to send your contact back?");
                  CardService.handleInviteResponse(true, invite!, sendBackContact: result);
                } else {
                  CardService.handleInviteResponse(true, invite!);
                }
              },
              text: "Accept",
              gradient: SonrGradient.Tertiary,
              icon: SonrIcons.Check,
            ),
          ],
        ),
      ]),
    );
  }
}

/// @ Flat Contact Invite/Reply from AuthInvite/AuthReply Proftobuf
class ContactFlatCard extends StatelessWidget {
  final double? scale;
  final Contact? contact;
  ContactFlatCard(this.contact, {this.scale, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420 * scale!,
      width: (Get.width - 64) * scale!,
      decoration: Neumorphic.floating(
        theme: Get.theme,
      ),
      child: Container(
        height: 75,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(padding: EdgeInsets.all(4)),
          // Build Profile Pic
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: Neumorphic.floating(theme: Get.theme, shape: BoxShape.circle),
                child: ProfileAvatar(
                  profile: contact!.profile,
                )),
          ),

          // Build Name
          contact!.fullName.gradient(value: SonrGradients.SolidStone),
          Divider(),
          Padding(padding: EdgeInsets.all(4)),

          // Quick Actions
          Container(
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ActionButton(
              onPressed: () {},
              label: "Mobile",
              icon: SonrIcons.Call.gradient(
                value: SonrGradients.CrystalRiver,
                size: 36,
              ),
              size: 72,
            ),
            Padding(padding: EdgeInsets.all(6)),
            ActionButton(
              onPressed: () {},
              label: "Text",
              icon: SonrIcons.Mail.gradient(
                value: SonrGradients.NightCall,
                size: 36,
              ),
              size: 72,
            ),
            Padding(padding: EdgeInsets.all(6)),
            ActionButton(
                onPressed: () {},
                label: "Video",
                size: 72,
                icon: SonrIcons.VideoCamera.gradient(
                  value: SonrGradients.OctoberSilence,
                  size: 36,
                )),
          ])),

          Divider(),
          Padding(padding: EdgeInsets.all(4)),

          // Brief Contact Card Info
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: contact!.mapSocials((social) => social.media.gradient(size: 35)) as List<Widget>)
        ]),
      ),
    );
  }
}
