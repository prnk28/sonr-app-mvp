import 'dart:ui';
import 'package:get/get.dart';
import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

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
