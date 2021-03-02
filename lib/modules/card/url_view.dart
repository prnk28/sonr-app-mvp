import 'package:get/get.dart';
import 'package:sonr_app/core/core.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/core/core.dart';
import 'package:sonr_core/sonr_core.dart';
import 'card_controller.dart';

class URLCard extends GetWidget<TransferCardController> {
  // References
  final CardType type;
  final AuthInvite invite;
  final TransferCard card;
  final bool isNewItem;

  // ** Factory -> Invite Dialog View ** //
  factory URLCard.invite(AuthInvite invite) {
    return URLCard(CardType.Invite, invite: invite, card: invite.card);
  }

  // ** Factory -> Grid Item View ** //
  factory URLCard.item(TransferCard card, {bool isNewItem = false}) {
    return URLCard(CardType.GridItem, card: card, isNewItem: isNewItem);
  }

  // ** Constructer ** //
  const URLCard(this.type, {Key key, this.invite, this.card, this.isNewItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CardType.Invite:
        return _URLInviteView(card, controller, invite);
        break;
      case CardType.GridItem:
        return _URLItemView(card);
      default:
        return Container();
        break;
    }
  }
}

// ^ Widget for Expanded Media View
class _URLItemView extends StatelessWidget {
  final TransferCard card;
  const _URLItemView(this.card);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.find<DeviceService>().launchURL(card.url.link),
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
            child: Container(),
          ),
        ),
      ),
    );
  }
}

// ^ URL Invite from AuthInvite Proftobuf ^ //
class _URLInviteView extends StatelessWidget {
  final TransferCardController controller;
  final TransferCard card;
  final AuthInvite invite;
  _URLInviteView(this.card, this.controller, this.invite);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 6),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        // @ Header
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Build Profile Pic
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8, right: 8),
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
                      size: 60,
                      color: Colors.black.withOpacity(0.5),
                    ),
            ),
          ),

          // From Information
          Column(mainAxisSize: MainAxisSize.min, children: [
            invite.from.profile.hasLastName()
                ? SonrText.gradient(invite.from.profile.firstName + " " + invite.from.profile.lastName, FlutterGradientNames.premiumDark, size: 32)
                : SonrText.gradient(invite.from.profile.firstName, FlutterGradientNames.premiumDark, size: 32),
            Center(child: SonrText.gradient("Website Link", FlutterGradientNames.magicRay, size: 22)),
          ]),
        ]),
        Divider(),

        // @ URL Information
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container(child: _buildURLView(card.url))),
          ],
        ),

        // @ Actions
        Divider(),
        Padding(padding: EdgeInsets.all(4)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          // Decline Button
          TextButton(
              onPressed: () => SonrOverlay.back(),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SonrText.medium("Dismiss", color: Colors.grey[600], size: 18),
              )),
          // Accept Button
          Container(
            width: Get.width / 3,
            height: 50,
            child: SonrButton.stadium(
              onPressed: () => Get.find<DeviceService>().launchURL(card.url.link),
              icon: SonrIcon.gradient(Icons.open_in_browser_rounded, FlutterGradientNames.aquaGuidance, size: 28),
              text: SonrText.semibold("Open", size: 18, color: Colors.black.withOpacity(0.85)),
            ),
          ),
        ]),
        Padding(padding: EdgeInsets.only(top: 14))
      ]),
    );
  }

  // ^ Method to Build View from Data ^ //
  Widget _buildURLView(URLLink data) {
    // Check open graph images
    if (data.images.length > 0) {
      return Column(children: [
        // @ Social Image
        Image.network(data.images.first.url),

        // @ URL Info
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SonrText.header(data.title, size: 22),
              SonrText.normal(data.description, size: 16),
            ],
          ),
        ),

        // @ Link Preview
        GestureDetector(
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: data.link));
            SonrSnack.alert(title: "Copied!", message: "URL copied to clipboard", icon: Icon(Icons.copy, color: Colors.white));
          },
          child: Neumorphic(
              style: SonrStyle.indented,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                // URL Icon
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 8),
                  child: SonrIcon.url,
                ),

                // Link Preview
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SonrText.url(card.url.link),
                  ),
                )
              ])),
        )
      ]);
    }

    // Check twitter data
    if (data.hasTwitter()) {
      return Column(children: [
        // @ Social Image
        Image.network(data.twitter.image),

        // @ URL Info
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SonrText.header(data.title, size: 22),
              SonrText.normal(data.description, size: 16),
            ],
          ),
        ),

        // @ Link Preview
        GestureDetector(
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: data.link));
            SonrSnack.alert(title: "Copied!", message: "URL copied to clipboard", icon: Icon(Icons.copy, color: Colors.white));
          },
          child: Neumorphic(
              style: SonrStyle.indented,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                // URL Icon
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 8),
                  child: SonrIcon.url,
                ),

                // Link Preview
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SonrText.url(card.url.link),
                  ),
                )
              ])),
        )
      ]);
    }

    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(new ClipboardData(text: data.link));
        SonrSnack.alert(title: "Copied!", message: "URL copied to clipboard", icon: Icon(Icons.copy, color: Colors.white));
      },
      child: Neumorphic(
        style: SonrStyle.indented,
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SonrText.url(card.url.link),
        ),
      ),
    );
  }
}
