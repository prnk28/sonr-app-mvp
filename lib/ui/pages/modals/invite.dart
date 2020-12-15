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
          // ^ Authentication Modal ^
          // @ Payload is a File
          if (receive.invite.payload.type == Payload_Type.FILE) {
            return FileInviteView(receive.invite);
          }
          // @ Payload Is Contact
          else if (receive.invite.payload.type == Payload_Type.CONTACT) {
            return ContactInviteView(
              receive.invite.payload.contact,
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
