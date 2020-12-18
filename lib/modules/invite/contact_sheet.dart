import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonar_app/theme/theme.dart';

class ContactInviteSheet extends StatelessWidget {
  final Contact contact;
  final bool isReply;
  final SonrService sonr = Get.find();

  ContactInviteSheet(
    this.contact, {
    this.isReply = false,
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
        style: SonrBorderStyle(),
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Container(
            child: Column(children: [
          // @ Top Right Close/Cancel Button
          closeButton(() {
            // Emit Event
            sonr.respondPeer(false);

            // Pop Window
            Get.back();
          }),

          // @ Basic Contact Info - Make Expandable
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(padding: EdgeInsets.all(8)),
            Column(
              children: [
                boldText(contact.firstName),
                boldText(contact.lastName),
              ],
            )
          ]),

          // @ Send Back Button
          _buildSendBack(),

          // @ Save Button
          rectangleButton("Save", () {
            Get.back();
          }),
        ])));
  }

  Widget _buildSendBack() {
    if (!isReply) {
      // @ Sendback Is actions[0]
      return rectangleButton("Send Back", () {
        // Emit Event
        sonr.respondPeer(true);
        sonr.reset();
        Get.back();
      });
      // Remove Sendback if Necessary
    } else {
      return Container();
    }
  }
}
