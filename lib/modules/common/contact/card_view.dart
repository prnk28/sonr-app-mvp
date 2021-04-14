import 'dart:ui';
import 'package:get/get.dart';
import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_app/data/data.dart';
import 'contact.dart';

// ^ TransferCard Contact Item Details ^ //
class ContactCardView extends StatelessWidget {
  final TransferCardItem card;
  ContactCardView(this.card);
  @override
  Widget build(BuildContext context) {
    Contact contact = card.contact;
    return Container(
      height: 420,
      width: Get.width - 64,
      decoration: Neumorphism.floating(),
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
              child: Container(decoration: Neumorphism.indented(shape: BoxShape.circle), padding: EdgeInsets.all(10), child: contact.profilePicture),
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
                    text: "Mobile".p_Grey,
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
                    text: "Text".p_Grey,
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
                      text: "Video".p_Grey,
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
    );
  }
}
