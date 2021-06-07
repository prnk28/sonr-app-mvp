import 'dart:ui';
import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/modules/peer/profile_view.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_app/data/data.dart';

/// @ Transfer Contact Item Details
class ContactCardItemView extends StatelessWidget {
  final TransferCard card;
  ContactCardItemView(this.card, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      decoration: SonrTheme.cardDecoration,
      child: Hero(
        tag: card.id,
        child: Container(
          height: 75,
          decoration: BoxDecoration(
              image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.black26, BlendMode.luminosity),
            fit: BoxFit.cover,
            image: AssetController.randomCard.image,
          )),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(padding: EdgeInsets.all(4)),
            // Build Profile Pic
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                decoration: Neumorphic.indented(theme: Get.theme, shape: BoxShape.circle),
                padding: EdgeInsets.all(10),
                child: ProfileAvatar.fromContact(card.contact!),
              ),
            ),

            // Build Name
            ProfileName(profile: card.contact!.profile, isHeader: false),
            Divider(),
            Padding(padding: EdgeInsets.all(4)),

            // Quick Actions
            Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ActionButton(
                onPressed: () {},
                label: "Mobile",
                iconData: SonrIcons.Call,
                //              size: 72,
              ),
              Padding(padding: EdgeInsets.all(6)),
              ActionButton(onPressed: () {}, label: "Text", iconData: SonrIcons.Mail
                  //            size: 72,
                  ),
              Padding(padding: EdgeInsets.all(6)),
              ActionButton(
                  onPressed: () {},
                  label: "Video",
                  //            size: 72,
                  iconData: SonrIcons.VideoCamera),
            ])),

            Divider(),
            Padding(padding: EdgeInsets.all(4)),

            // Brief Contact Card Info
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: card.contact!.mapSocials((social) => social.media.gradient(size: 35)) as List<Widget>)
          ]),
        ),
      ),
    );
  }
}
