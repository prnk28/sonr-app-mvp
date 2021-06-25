import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:get/get.dart';


/// @ Flat Contact Invite/Reply from InviteRequest/InviteResponse Proftobuf
class ContactContent extends StatelessWidget {
  final double? scale;
  final Contact? contact;
  ContactContent(this.contact, {this.scale, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BoxContainer(
      height: 420 * scale!,
      width: (Get.width - 64) * scale!,
      child: Container(
        height: 75,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(padding: EdgeInsets.all(4)),
          // Build Profile Pic
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: CircleContainer(
                padding: EdgeInsets.all(10),
                child: ProfileAvatar(
                  profile: contact!.profile,
                )),
          ),

          // Build Name
          contact!.fullName.gradient(value: SonrGradients.SolidStone),
          Divider(),
          Padding(padding: EdgeInsets.all(4)),

          // Quick Actions
          Container(
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ActionButton(
              onPressed: () {},
              label: "Mobile",
              iconData: SonrIcons.Call,
              //    size: 72,
            ),
            Padding(padding: EdgeInsets.all(6)),
            ActionButton(
              onPressed: () {},
              label: "Text",
              iconData: SonrIcons.Mail,
              //    size: 72,
            ),
            Padding(padding: EdgeInsets.all(6)),
            ActionButton(
                onPressed: () {},
                label: "Video",
                //    size: 72,
                iconData: SonrIcons.VideoCamera),
          ])),

          Divider(),
          Padding(padding: EdgeInsets.all(4)),

          // Brief Contact Card Info
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: contact!.mapSocials((social) => social.media.gradient(size: 35)) as List<Widget>)
        ]),
      ),
    );
  }
}
