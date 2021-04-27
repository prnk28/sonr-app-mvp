import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_app/data/data.dart';

// ^ Flat Contact Invite/Reply from AuthInvite/AuthReply Proftobuf ^ //
class ContactFlatCard extends StatelessWidget {
  final double scale;
  final Contact contact;
  ContactFlatCard(this.contact, {this.scale, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420 * scale,
      width: (Get.width - 64) * scale,
      decoration: Neumorph.floating(),
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
              ActionButton(
                onPressed: () {},
                label: "Mobile",
                icon: SonrIcons.Call.gradientNamed(
                  name: FlutterGradientNames.highFlight,
                  size: 36,
                ),
                size: 72,
              ),
              Padding(padding: EdgeInsets.all(6)),
              ActionButton(
                onPressed: () {},
                label: "Text",
                icon: SonrIcons.Mail.gradientNamed(name: FlutterGradientNames.teenParty, size: 36),
                size: 72,
              ),
              Padding(padding: EdgeInsets.all(6)),
              ActionButton(
                onPressed: () {},
                label: "Video",
                size: 72,
                icon: SonrIcons.VideoCamera.gradientNamed(name: FlutterGradientNames.deepBlue, size: 36),
              ),
            ]),
          ),
          Divider(),
          Padding(padding: EdgeInsets.all(4)),

          // Brief Contact Card Info
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List<Widget>.generate(contact.socials.length, (index) {
                return contact.socials[index].provider.gradient(size: 35);
              }))
        ]),
      ),
    );
  }
}
