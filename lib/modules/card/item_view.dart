import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/home/home_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'expanded_view.dart';

// * ------------------------ * //
// * ---- Card View --------- * //
// * ------------------------ * //
class ItemCardView extends StatelessWidget {
  // Properties

  // References
  final AuthInvite invite;
  final AuthReply reply;
  final TransferCard card;
  final int index;

  // ** Constructer ** //
  ItemCardView({Key key, this.invite, this.reply, this.card, this.index});

  // @ Factory for SQL TransferCard Data
  factory ItemCardView.fromItem(TransferCard card, int index) {
    return ItemCardView(card: card, index: index);
  }

  @override
  Widget build(BuildContext context) {
    // * Completed Card * //
    // Initialize Views
    final viewForPayload = {Payload.MEDIA: _FileItemView(card), Payload.CONTACT: _ContactItemView(card)};

    // Create View
    return Neumorphic(
      style: SonrStyle.cardItem,
      margin: EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () {
          // Close Share Menu
          Get.find<HomeController>().toggleShareExpand(options: ToggleForced(false));

          // Push to Page
          Get.to(ExpandedView(card: card), transition: Transition.fadeIn);
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
            child: viewForPayload[card.payload],
          ),
        ),
      ),
    );
  }
}

// ^ TransferCard File Item Details ^ //
class _FileItemView extends StatelessWidget {
  final TransferCard card;

  _FileItemView(this.card);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Time Stamp
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Neumorphic(
              style: SonrStyle.timeStamp,
              child: SonrText.date(DateTime.fromMillisecondsSinceEpoch(card.received * 1000)),
              padding: EdgeInsets.all(10),
            ),
          ),
        ),

        // Info Button
        Align(
          alignment: Alignment.topRight,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SonrButton.circle(
                  icon: SonrIcon.info,
                  onPressed: () => SonrOverlay.fromMetaCardInfo(card: card, context: context),
                  shadowLightColor: Colors.black38)),
        ),
      ],
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
