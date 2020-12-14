import 'package:sonar_app/ui/ui.dart';
import 'package:flutter/widgets.dart';
import 'package:sonar_app/controller/controller.dart';
import 'package:sonr_core/sonr_core.dart';
import 'progress.dart';

part 'contact.dart';
part 'file.dart';

class InviteSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReceiveController>(
        id: "ReceiveSheet",
        builder: (receive) {
          // ^ Check Auth Status for Accept ^
          if (receive.accepted) {
            return Container(
                decoration: windowDecoration(context),
                height: Get.height / 3 + 20,
                child: Center(
                    child: LiquidFill(
                        iconData: iconDataFromKind(
                            receive.invite.payload.file.mime.type))));
          }

          // ^ Authentication Modal ^
          return Container(
              decoration: windowDecoration(context),
              height: Get.height / 3 + 20,
              child: Column(
                children: [
                  // @ Top Right Close/Cancel Button
                  GestureDetector(
                    onTap: () {
                      // Emit Event
                      receive.respondPeer(false);

                      // Pop Window
                      Get.back();
                    },
                    child: getCloseButton(),
                  ),

                  // Build Item from Metadata and Peer
                  _buildAuthInviteView(receive.invite),
                  Padding(padding: EdgeInsets.only(top: 8)),

                  // Build Auth Action
                  _buildActions(receive), // FlatButton// Container
                ],
              ));
        });
  }

  Widget _buildAuthInviteView(AuthInvite invite) {
    // @ Payload is a File
    if (invite.payload.type == Payload_Type.FILE) {
      return FileInviteView(invite.payload.file, invite.from);
    }
    // @ Payload Is Contact
    else if (invite.payload.type == Payload_Type.CONTACT) {
      return ContactInviteView(invite.payload.contact);
    }
    return Container();
  }

  Widget _buildActions(ReceiveController receive) {
    // Build Auth Action
    return NeumorphicButton(
        onPressed: () {
          // Emit Event
          receive.respondPeer(true);
        },
        style: NeumorphicStyle(
            depth: 8,
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8))),
        padding: const EdgeInsets.all(12.0),
        child: Text("Accept", style: smallTextStyle()));
  }
}
