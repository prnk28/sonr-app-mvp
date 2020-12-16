import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/models/models.dart';

class ContactInviteView extends StatelessWidget {
  final Contact contact;
  final bool isReply;
  final SonrService sonrService = Get.find();

  ContactInviteView(
    this.contact, {
    this.isReply = false,
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Build View
    return DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: NeumorphicTheme.baseColor(context),
              ),
              child: Column(children: [
                // @ Top Right Close/Cancel Button
                GestureDetector(
                  onTap: () {
                    // Pop Window
                    Get.back();
                  },
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                          padding: EdgeInsets.only(top: 10, right: 15),
                          child: Icon(
                            Icons.close_rounded,
                            size: 35,
                            color: Colors.grey[700],
                          ))),
                ),

                // @ Basic Contact Info - Make Expandable
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(padding: EdgeInsets.all(8)),
                  Column(
                    children: [
                      Text(contact.firstName, style: _mediumTextStyle()),
                      Text(contact.lastName, style: _mediumTextStyle())
                    ],
                  )
                ]),

                // @ Send Back Button
                _buildSendBack(),

                // @ Save Button
                NeumorphicButton(
                    onPressed: () {
                      // Emit Event
                      Get.back();
                    },
                    style: NeumorphicStyle(
                        depth: 8,
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(8))),
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Save", style: _smallTextStyle())),
              ]));
        });
  }

  Widget _buildSendBack() {
    if (!isReply) {
      // @ Sendback Is actions[0]
      return NeumorphicButton(
          onPressed: () {
            // Emit Event
            sonrService.respondPeer(true);
            Get.back();
          },
          style: NeumorphicStyle(
              depth: 8,
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8))),
          padding: const EdgeInsets.all(12.0),
          child: Text("Send Back", style: _smallTextStyle()));

      // Remove Sendback if Necessary
    } else {
      return Container();
    }
  }

  // Medium Text
  TextStyle _mediumTextStyle({Color setColor}) {
    return TextStyle(
        fontFamily: "Raleway",
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: setColor ?? Colors.black54);
  }

  // Small Text
  TextStyle _smallTextStyle({Color setColor}) {
    return TextStyle(
        fontFamily: "Raleway",
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: setColor ?? Colors.black54);
  }
}
