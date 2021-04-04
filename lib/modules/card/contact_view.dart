import 'dart:ui';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

class ContactCard extends StatelessWidget {
  // References
  final CardType type;
  final AuthInvite invite;
  final AuthReply reply;
  final TransferCard card;
  final bool isNewItem;
  final Contact contact;
  final double scale;

  // ** Factory -> Invite Dialog View ** //
  factory ContactCard.invite(AuthInvite invite) {
    return ContactCard(CardType.Invite, invite: invite, card: invite.card);
  }

  // ** Factory -> Invite Dialog View ** //
  factory ContactCard.flat(Contact contact, {double scale = 1.0, Key key}) {
    return ContactCard(CardType.InviteFlat, contact: contact, scale: scale, key: key);
  }

  // ** Factory -> Invite Dialog View ** //
  factory ContactCard.reply(AuthReply reply) {
    return ContactCard(CardType.Reply, reply: reply, card: reply.card);
  }

  // ** Factory -> Grid Item View ** //
  factory ContactCard.item(TransferCard card, {bool isNewItem = false}) {
    return ContactCard(CardType.GridItem, card: card, isNewItem: isNewItem);
  }

  // ** Constructer ** //
  const ContactCard(this.type, {Key key, this.contact, this.invite, this.reply, this.card, this.isNewItem, this.scale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CardType.Invite:
        return _ContactInviteView(card, invite, false);
        break;
      case CardType.InviteFlat:
        return _ContactFlatView(contact, scale);
        break;
      case CardType.Reply:
        return _ContactInviteView(card, invite, true);
        break;
      case CardType.GridItem:
        return _ContactItemView(card);
        break;
      default:
        return Container();
        break;
    }
  }
}

// ^ Flat Contact Invite/Reply from AuthInvite/AuthReply Proftobuf ^ //
class _ContactFlatView extends StatelessWidget {
  final double scale;
  final Contact contact;
  _ContactFlatView(this.contact, this.scale, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420 * scale,
      width: (Get.width - 64) * scale,
      child: NeumorphicBackground(
        backendColor: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Neumorphic(
          style: SonrStyle.normal,
          margin: EdgeInsets.all(4),
          child: Container(
            height: 75,
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                    child: contact.profilePicture),
              ),

              // Build Name
              contact.fullName,
              Divider(),
              Padding(padding: EdgeInsets.all(4)),

              // Quick Actions
              Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: 78,
                    height: 78,
                    child: ShapeButton.circle(
                        depth: 4,
                        onPressed: () {},
                        text: SonrText.medium("Mobile", size: 12, color: Colors.black45),
                        icon: SonrIcon.gradient(Icons.phone, FlutterGradientNames.highFlight, size: 36),
                        iconPosition: WidgetPosition.Top),
                  ),
                  Padding(padding: EdgeInsets.all(6)),
                  SizedBox(
                    width: 78,
                    height: 78,
                    child: ShapeButton.circle(
                        depth: 4,
                        onPressed: () {},
                        text: SonrText.medium("Text", size: 12, color: Colors.black45),
                        icon: SonrIcon.gradient(Icons.mail, FlutterGradientNames.teenParty, size: 36),
                        iconPosition: WidgetPosition.Top),
                  ),
                  Padding(padding: EdgeInsets.all(6)),
                  SizedBox(
                      width: 78,
                      height: 78,
                      child: ShapeButton.circle(
                          depth: 4,
                          onPressed: () {},
                          text: SonrText.medium("Video", size: 12, color: Colors.black45),
                          icon: SonrIcon.gradient(Icons.video_call_rounded, FlutterGradientNames.deepBlue, size: 36),
                          iconPosition: WidgetPosition.Top)),
                ]),
              ),

              Divider(),
              Padding(padding: EdgeInsets.all(4)),

              // Brief Contact Card Info
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List<Widget>.generate(contact.socials.length, (index) {
                    return contact.socials[index].provider.icon(IconType.Gradient, size: 35);
                  }))
            ]),
          ),
        ),
      ),
    );
  }
}

// ^ Contact Invite from AuthInvite Proftobuf ^ //
class _ContactInviteView extends StatelessWidget {
  final TransferCard card;
  final AuthInvite invite;
  final bool isReply;
  _ContactInviteView(this.card, this.invite, this.isReply);

  @override
  Widget build(BuildContext context) {
    return GetX<ContactCardController>(
      init: ContactCardController(card, invite: invite),
      builder: (controller) {
        return Neumorphic(
          style: SonrStyle.normal,
          child: Column(children: [
            Row(children: [
              // @ Photo
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 8),
                  child: Neumorphic(
                    padding: EdgeInsets.all(4),
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.circle(),
                      depth: -10,
                    ),
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
                    card.platform.icon(IconType.Neumorphic, color: Colors.grey[700], size: 20),
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
                return card.contact.socials[index].provider.icon(IconType.Gradient, size: 32);
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
                  onPressed: () {
                    SonrOverlay.back();
                    if (!isReply) {
                      controller.promptSendBack();
                    } else {
                      controller.accept(sendBackContact: false);
                    }
                  },
                  text: "Accept",
                  gradient: SonrPalette.tertiary(),
                  icon: SonrIcon.gradient(Icons.check, FlutterGradientNames.newLife, size: 28),
                ),
              ],
            ),
          ]),
        );
      },
    );
  }
}

// ^ TransferCard Contact Item Details ^ //
class _ContactItemView extends StatelessWidget {
  final TransferCard card;

  _ContactItemView(this.card);
  @override
  Widget build(BuildContext context) {
    Contact contact = card.contact;
    return GetX<ContactCardController>(
      init: ContactCardController(card),
      builder: (controller) {
        return Card(
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            elevation: 2,
            child: Container(
              height: 420,
              width: Get.width - 64,
              child: GestureDetector(
                onTap: () {
                  // Push to Page
                  Get.to(_ContactCardExpanded(card), transition: Transition.fadeIn);
                },
                child: Neumorphic(
                  style: SonrStyle.normal,
                  margin: EdgeInsets.all(4),
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
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                              child: contact.profilePicture),
                        ),

                        // Build Name
                        contact.fullName,
                        Divider(),
                        Padding(padding: EdgeInsets.all(4)),

                        // Quick Actions
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          SizedBox(
                            width: 78,
                            height: 78,
                            child: ShapeButton.circle(
                                depth: 4,
                                onPressed: () {},
                                text: SonrText.medium("Mobile", size: 12, color: Colors.black45),
                                icon: SonrIcon.gradient(Icons.phone, FlutterGradientNames.highFlight, size: 36),
                                iconPosition: WidgetPosition.Top),
                          ),
                          Padding(padding: EdgeInsets.all(6)),
                          SizedBox(
                            width: 78,
                            height: 78,
                            child: ShapeButton.circle(
                                depth: 4,
                                onPressed: () {},
                                text: SonrText.medium("Text", size: 12, color: Colors.black45),
                                icon: SonrIcon.gradient(Icons.mail, FlutterGradientNames.teenParty, size: 36),
                                iconPosition: WidgetPosition.Top),
                          ),
                          Padding(padding: EdgeInsets.all(6)),
                          SizedBox(
                              width: 78,
                              height: 78,
                              child: ShapeButton.circle(
                                  depth: 4,
                                  onPressed: () {},
                                  text: SonrText.medium("Video", size: 12, color: Colors.black45),
                                  icon: SonrIcon.gradient(Icons.video_call_rounded, FlutterGradientNames.deepBlue, size: 36),
                                  iconPosition: WidgetPosition.Top)),
                        ]),

                        Divider(),
                        Padding(padding: EdgeInsets.all(4)),

                        // Brief Contact Card Info
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List<Widget>.generate(contact.socials.length, (index) {
                              return contact.socials[index].provider.icon(IconType.Gradient, size: 35);
                            }))
                      ]),
                    ),
                  ),
                ),
              ),
            ));
      },
    );
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

class ContactCardController extends GetxController {
  final AuthInvite invite;
  final TransferCard card;

  ContactCardController(this.card, {this.invite});

  // ^ Accept Contact Invite Request ^ //
  accept({bool sendBackContact = false, bool closeOverlay = false}) {
    // Save Card
    Get.find<SQLService>().storeCard(card);

    // Check if Send Back
    if (sendBackContact) {
      SonrService.respond(true);
    }

    // Return to HomeScreen
    Get.back();

    // Present Home Controller
    if (Get.currentRoute != "/transfer") {
      Get.offNamed('/home/received');
    }
  }

  // ^ Decline Invite Request ^ //
  decline() {
    // Check if accepted
    SonrService.respond(false);
    SonrOverlay.back();
  }

  // ^ Accept Transfer Invite Request ^ //
  promptSendBack() async {
    var result = await SonrOverlay.question(title: "Send Back", description: "Would you like to send your contact back?");
    accept(sendBackContact: result, closeOverlay: true);
  }

  // ^ Method to Present Card Overlay Info
  showInfo(Widget infoWidget) {
    SonrOverlay.show(infoWidget, disableAnimation: true, barrierDismissible: true);
  }
}
