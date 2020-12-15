import 'package:sonar_app/ui/ui.dart';
import 'package:flutter/widgets.dart';
import 'package:sonar_app/controller/controller.dart';
import 'package:sonr_core/sonr_core.dart';
import 'progress.dart';

part 'contact.dart';
part 'file.dart';

class InviteSheet extends StatelessWidget {
  final bool forceContact;

  const InviteSheet({Key key, this.forceContact = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReceiveController>(
        id: "ReceiveSheet",
        builder: (receive) {
          // ^ Check Auth Status for Accept ^
          if (receive.status == Status.Busy) {
            return Container(
                decoration: windowDecoration(context),
                height: Get.height / 3 + 20,
                child: Center(
                    child: ProgressView(
                        iconData:
                            iconDataFromPayload(receive.invite.payload))));
          }

          // ^ Authentication Modal ^
          // @ Payload is a File
          if (receive.invite.payload.type == Payload_Type.FILE) {
            return FileInviteView(receive.invite);
          }
          // @ Payload Is Contact
          else if (receive.invite.payload.type == Payload_Type.CONTACT) {
            return ContactInviteView(
              receive.invite.payload.contact,
              onSendBack: () {
                receive.respondPeer(true);
              },
              onSave: () {
                receive.respondPeer(true);
              },
            );
          } else {
            return Container();
          }
        });
  }
}
