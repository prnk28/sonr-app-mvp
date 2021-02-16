import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:sonr_app/modules/home/home_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

import 'card_controller.dart';

class ContactCard extends GetWidget<TransferCardController> {
  // References
  final CardType type;
  final AuthInvite invite;
  final AuthReply reply;
  final TransferCard card;

  // ** Factory -> Invite Dialog View ** //
  factory ContactCard.invite({@required AuthInvite invite}) {
    return ContactCard(CardType.Invite, invite: invite, card: invite.card);
  }

  // ** Factory -> Invite Dialog View ** //
  factory ContactCard.reply({@required AuthReply reply}) {
    return ContactCard(CardType.Reply, reply: reply, card: reply.card);
  }

  // ** Factory -> Grid Item View ** //
  factory ContactCard.item({@required TransferCard card}) {
    return ContactCard(CardType.GridItem, card: card);
  }

  // ** Constructer ** //
  const ContactCard(this.type, {Key key, this.invite, this.reply, this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CardType.Invite:
        return _ContactInviteView(card, controller, false);
        break;
      case CardType.Reply:
        return _ContactInviteView(card, controller, true);
        break;
      case CardType.GridItem:
        return Neumorphic(
          style: SonrStyle.normal,
          margin: EdgeInsets.all(4),
          child: GestureDetector(
            onTap: () {
              // Close Share Menu
              Get.find<HomeController>().toggleShareExpand(options: ToggleForced(false));

              // Push to Page
              Get.to(_ContactCardExpanded(card), transition: Transition.fadeIn);
            },
            child: Hero(
              tag: card.id,
              child: Container(
                height: 75,
                decoration: card.payload == Payload.MEDIA && card.metadata.mime.type == MIME_Type.image
                    ? BoxDecoration(
                        image: DecorationImage(
                        colorFilter: ColorFilter.mode(Colors.black26, BlendMode.luminosity),
                        fit: BoxFit.cover,
                        image: MemoryImage(card.metadata.thumbnail),
                      ))
                    : null,
                child: _ContactItemView(card),
              ),
            ),
          ),
        );
        break;
      default:
        return Container();
        break;
    }
  }
}

// ^ Contact Invite from AuthInvite Proftobuf ^ //
class _ContactInviteView extends StatelessWidget {
  final TransferCardController controller;
  final TransferCard card;
  final bool isReply;
  _ContactInviteView(this.card, this.controller, this.isReply);

  @override
  Widget build(BuildContext context) {
    // Display Info
    return Column(mainAxisSize: MainAxisSize.max, children: [
      // @ Header
      Divider(),
      SonrHeaderBar.closeAccept(
        title: SonrText.invite(Payload.CONTACT.toString(), card.contact.firstName),
        onAccept: () {
          if (!isReply) {
            SonrDialog.small(Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // @ Footer
              SonrHeaderBar.closeAccept(
                title: SonrText.header("Send Back?", size: 32),
                onAccept: () {
                  controller.acceptContact(card, true);
                  Get.back(closeOverlays: true);
                },
                onCancel: () {
                  controller.acceptContact(card, false);
                  Get.back(closeOverlays: true);
                },
              ),
              Divider(),
              Container(
                  child: SonrText.normal("Would you like to send your contact card back to ${card.contact.firstName}"),
                  margin: EdgeInsets.symmetric(horizontal: 4))
            ]));
          } else {
            controller.acceptContact(card, false);
          }
        },
        onCancel: () {
          Get.back();
        },
      ),

      // @ Basic Contact Info - Make Expandable
      SonrText.bold(card.contact.firstName),
      SonrText.bold(card.contact.lastName),
    ]);
  }
}

// ^ TransferCard Contact Item Details ^ //
class _ContactItemView extends StatelessWidget {
  final TransferCard card;

  _ContactItemView(this.card);
  @override
  Widget build(BuildContext context) {
    Contact contact = card.contact;
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(padding: EdgeInsets.all(4)),
      // Build Profile Pic
      Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Neumorphic(
          padding: EdgeInsets.all(10),
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
            depth: -10,
          ),
          child: contact.hasPicture()
              ? Image.memory(Uint8List.fromList(contact.picture))
              : Icon(
                  Icons.insert_emoticon,
                  size: 120,
                  color: Colors.black.withOpacity(0.5),
                ),
        ),
      ),

      // Build Name
      contact.hasLastName()
          ? SonrText.gradient(contact.firstName + " " + contact.lastName, FlutterGradientNames.solidStone, size: 32)
          : SonrText.gradient(contact.firstName, FlutterGradientNames.solidStone, size: 32),

      Divider(),
      Padding(padding: EdgeInsets.all(4)),

      // Quick Actions
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          width: 78,
          height: 78,
          child: SonrButton.circle(
              depth: 4,
              onPressed: () {},
              text: SonrText.normal("Mobile", size: 12, color: Colors.black45),
              icon: SonrIcon.gradient(Icons.phone, FlutterGradientNames.highFlight, size: 36),
              iconPosition: WidgetPosition.Top),
        ),
        Padding(padding: EdgeInsets.all(6)),
        SizedBox(
          width: 78,
          height: 78,
          child: SonrButton.circle(
              depth: 4,
              onPressed: () {},
              text: SonrText.normal("Text", size: 12, color: Colors.black45),
              icon: SonrIcon.gradient(Icons.mail, FlutterGradientNames.teenParty, size: 36),
              iconPosition: WidgetPosition.Top),
        ),
        Padding(padding: EdgeInsets.all(6)),
        SizedBox(
            width: 78,
            height: 78,
            child: SonrButton.circle(
                depth: 4,
                onPressed: () {},
                text: SonrText.normal("Video", size: 12, color: Colors.black45),
                icon: SonrIcon.gradient(Icons.video_call_rounded, FlutterGradientNames.deepBlue, size: 36),
                iconPosition: WidgetPosition.Top)),
      ]),

      Divider(),
      Padding(padding: EdgeInsets.all(4)),

      // Brief Contact Card Info
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List<Widget>.generate(contact.socials.length, (index) {
            return SonrIcon.social(IconType.Gradient, contact.socials[index].provider, size: 35);
          }))
    ]);
  }
}

// ^ Widget for Expanded Contact Card View
class _ContactCardExpanded extends StatelessWidget {
  final TransferCard card;
  const _ContactCardExpanded(this.card);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: Get.back,
      child: SizedBox(
        width: Get.width,
        child: GestureDetector(
          onTap: () {
            Get.back(closeOverlays: true);
          },
          child: Hero(
            tag: card.id,
            child: Material(
              color: Colors.transparent,
              child: Container(color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}
