part of 'invite.dart';

class ContactInviteView extends StatelessWidget {
  final Contact contact;
  final bool isReply;
  final ReceiveController controller = Get.find();

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
              decoration: windowDecoration(context),
              child: Column(children: [
                // @ Top Right Close/Cancel Button
                GestureDetector(
                  onTap: () {
                    // Pop Window
                    Get.back();
                  },
                  child: getWindowCloseButton(),
                ),

                // @ Basic Contact Info - Make Expandable
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(padding: EdgeInsets.all(8)),
                  Column(
                    children: [
                      Text(contact.firstName, style: mediumTextStyle()),
                      Text(contact.lastName, style: mediumTextStyle())
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
                    child: Text("Save", style: smallTextStyle())),
              ]));
        });
  }

  Widget _buildSendBack() {
    if (!isReply) {
      // @ Sendback Is actions[0]
      return NeumorphicButton(
          onPressed: () {
            // Emit Event
            controller.respondPeer(true);
          },
          style: NeumorphicStyle(
              depth: 8,
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8))),
          padding: const EdgeInsets.all(12.0),
          child: Text("Send Back", style: smallTextStyle()));

      // Remove Sendback if Necessary
    } else {
      return Container();
    }
  }
}
