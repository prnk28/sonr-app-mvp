import 'package:sonr_app/data/database/database.dart';
import 'package:sonr_app/modules/peer/profile_view.dart';
import 'package:sonr_app/data/database/service.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_app/data/data.dart';

/// @ Transfer Contact Item Details
class ContactCardItemView extends StatelessWidget {
  final TransferCard card;
  ContactCardItemView(this.card, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BoxContainer(
      height: 420,
      child: Hero(
        tag: card.id,
        child: Container(
          height: 75,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(padding: EdgeInsets.all(4)),
            // Build Profile Pic
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: CircleContainer(
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
