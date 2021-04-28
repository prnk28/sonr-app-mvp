import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:sonr_app/data/data.dart';

// ^ Contact Invite from AuthInvite Proftobuf ^ //
class ContactAuthView extends StatelessWidget {
  final AuthInvite invite;
  final AuthReply reply;
  final bool isReply;
  ContactAuthView(this.isReply, {this.invite, this.reply});

  @override
  Widget build(BuildContext context) {
    TransferCard card;
    if (isReply) {
      card = reply.card;
    } else {
      card = invite.card;
    }
    return Container(
      height: context.heightTransformer(reducedBy: 35),
      width: context.widthTransformer(reducedBy: 10),
      decoration: Neumorph.floating(),
      child: Column(children: [
        Row(children: [
          // @ Photo
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 8),
              child: Container(
                decoration: Neumorph.floating(),
                padding: EdgeInsets.all(4),
                child: card.contact.profilePicture,
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
              card.contact.headerName,

              // Phone/ Website
              Row(children: [
                card.owner.platform.gradient(size: 20),
                // Hide PhoneNumber
                Padding(padding: EdgeInsets.all(10)),
                card.contact.phoneNumber,
                card.contact.webSite,
              ]),
            ]),
          ),
        ]),
        // Social Media
        Container(
          margin: EdgeInsets.only(top: 8, left: 40, right: 40, bottom: 8),
          child: Row(
              children: List.generate(card.contact.socials.length, (index) {
            return card.contact.socials[index].provider.gradient(size: 32);
          })),
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
                  CardService.handleInviteResponse(true, invite, card, sendBackContact: result);
                } else {
                  CardService.handleInviteResponse(true, invite, card, sendBackContact: false);
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
