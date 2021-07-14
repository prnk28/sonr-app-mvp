import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/modules/peer/peer.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:get/get.dart';

/// #### Flat Contact Invite/Reply from InviteRequest/InviteResponse Proftobuf
class ContactContent extends StatelessWidget {
  final double? scale;
  final Contact? contact;
  ContactContent(this.contact, {this.scale, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BoxContainer(
      height: 420 * scale!,
      width: (Get.width - 64) * scale!,
      child: Container(
        height: 75,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(padding: EdgeInsets.all(4)),
          // Build Profile Pic
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: CircleContainer(
                padding: EdgeInsets.all(10),
                child: ProfileAvatar(
                  profile: contact!.profile,
                )),
          ),

          // Build Name
          contact!.fullName.gradient(value: DesignGradients.SolidStone),
          Divider(),
          Padding(padding: EdgeInsets.all(4)),

          // Quick Actions
          Container(
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ActionButton(
              onPressed: () {},
              label: "Mobile",
              iconData: SimpleIcons.Call,
              //    size: 72,
            ),
            Padding(padding: EdgeInsets.all(6)),
            ActionButton(
              onPressed: () {},
              label: "Text",
              iconData: SimpleIcons.Mail,
              //    size: 72,
            ),
            Padding(padding: EdgeInsets.all(6)),
            ActionButton(
                onPressed: () {},
                label: "Video",
                //    size: 72,
                iconData: SimpleIcons.VideoCamera),
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

/// #### Contact Invite from InviteRequest Proftobuf
class ContactAuthView extends StatelessWidget {
  final InviteRequest? invite;
  final InviteResponse? reply;
  final bool isReply;
  ContactAuthView(this.isReply, {this.invite, this.reply});

  @override
  Widget build(BuildContext context) {
    Contact card;
    if (isReply) {
      card = reply!.transfer.contact;
    } else {
      card = invite!.contact;
    }
    return BoxContainer(
      height: context.heightTransformer(reducedBy: 35),
      width: context.widthTransformer(reducedBy: 10),
      child: Column(children: [
        Row(children: [
          // @ Photo
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 8),
              child: BoxContainer(
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
              ProfileFullName(profile: card.profile, isHeader: false),

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
        // Container(
        //   margin: EdgeInsets.only(top: 8, left: 40, right: 40, bottom: 8),
        //   child: Row(children: card.mapSocials((social) => social.media.gradient(size: 32)) as List<Widget>),
        // ),
        Divider(),
        Padding(padding: EdgeInsets.all(4)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorButton.neutral(onPressed: () => Get.back(), text: "Decline"),
            Padding(padding: EdgeInsets.all(8)),
            ColorButton.primary(
              onPressed: () async {
                Get.back();
                if (!isReply) {
                  var result = await AppRoute.question(title: "Send Back", description: "Would you like to send your contact back?");
                  ReceiverService.decide(true, sendBackContact: result);
                } else {
                  ReceiverService.decide(true);
                }
              },
              text: "Accept",
              icon: SimpleIcons.Check,
            ),
          ],
        ),
      ]),
    );
  }
}

/// #### Transfer Contact Item Details
class ContactItemView extends StatelessWidget {
  final TransferCard item;
  ContactItemView({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BoxContainer(
      height: 400,
      child: Hero(
        tag: item.id,
        child: Container(
          height: 75,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(padding: EdgeInsets.all(4)),
            // Build Profile Pic
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: CircleContainer(
                padding: EdgeInsets.all(10),
                child: ProfileAvatar.fromContact(item.contact!),
              ),
            ),

            // Build Name
            ProfileFullName(profile: item.contact!.profile, isHeader: false),
            Divider(),
            Padding(padding: EdgeInsets.all(4)),

            // Quick Actions
            Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ActionButton(
                onPressed: () {},
                label: "Mobile",
                iconData: SimpleIcons.Call,
                //              size: 72,
              ),
              Padding(padding: EdgeInsets.all(6)),
              ActionButton(onPressed: () {}, label: "Text", iconData: SimpleIcons.Mail
                  //            size: 72,
                  ),
              Padding(padding: EdgeInsets.all(6)),
              ActionButton(
                  onPressed: () {},
                  label: "Video",
                  //            size: 72,
                  iconData: SimpleIcons.VideoCamera),
            ])),

            Divider(),
            Padding(padding: EdgeInsets.all(4)),

            // Brief Contact Card Info
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: item.contact!.mapSocials((social) => social.media.gradient(size: 35)) as List<Widget>)
          ]),
        ),
      ),
    );
  }
}
