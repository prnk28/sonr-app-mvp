import 'package:get/get.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'card_controller.dart';

class URLCard extends GetWidget<TransferCardController> {
  // References
  final CardType type;
  final AuthInvite invite;
  final TransferCard card;

  // ** Factory -> Invite Dialog View ** //
  factory URLCard.invite(AuthInvite invite) {
    return URLCard(CardType.Invite, invite: invite, card: invite.card);
  }

  // ** Factory -> Grid Item View ** //
  factory URLCard.item(TransferCard card) {
    return URLCard(CardType.GridItem, card: card);
  }

  // ** Constructer ** //
  const URLCard(this.type, {Key key, this.invite, this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CardType.Invite:
        return _URLInviteView(card, controller);
        break;
      case CardType.GridItem:
        return Neumorphic(
          style: SonrStyle.normal,
          margin: EdgeInsets.all(4),
          child: GestureDetector(
            onTap: () {
              // Push to Page
              Get.to(_URLCardExpanded(card), transition: Transition.fadeIn);
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
                child: Container(),
              ),
            ),
          ),
        );
      default:
        return Container();
        break;
    }
  }
}

// ^ URL Invite from AuthInvite Proftobuf ^ //
class _URLInviteView extends StatelessWidget {
  final TransferCardController controller;
  final TransferCard card;
  _URLInviteView(this.card, this.controller);

  @override
  Widget build(BuildContext context) {
    final name = card.firstName;
    final url = card.url;

    return Container(
      padding: EdgeInsets.only(top: 6),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        // @ Header
        SonrHeaderBar.closeAccept(
          title: SonrText.invite(Payload.URL.toString(), name),
          onAccept: () {
            SonrOverlay.back();
            Get.find<DeviceService>().launchURL(url);
          },
          onCancel: () {
            SonrOverlay.back();
          },
        ),
        Divider(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // @ Sonr Icon
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SonrIcon.url,
            ),

            // @ Indent View
            Expanded(
              child: Neumorphic(
                  style: SonrStyle.indented,
                  margin: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SonrText.url(url),
                  )),
            ),
          ],
        ),
      ]),
    );
  }
}

// ^ Widget for Expanded Media View
class _URLCardExpanded extends StatelessWidget {
  final TransferCard card;
  const _URLCardExpanded(this.card);
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
              child: Container(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
