part of 'invite.dart';

class ContactInviteView extends StatelessWidget {
  final Contact contact;
  final void Function() onSave;
  final void Function() onSendBack;

  const ContactInviteView(this.contact, {Key key, this.onSave, this.onSendBack})
      : super(key: key);
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
              height: Get.height / 3 + 50,
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
                      onSave();
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
    // @ Sendback Is actions[0]
    var sendback = NeumorphicButton(
        onPressed: () {
          // Emit Event
          onSendBack();
        },
        style: NeumorphicStyle(
            depth: 8,
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8))),
        padding: const EdgeInsets.all(12.0),
        child: Text("Send Back", style: smallTextStyle()));

    // Remove Sendback if Necessary
    if (this.onSendBack == null) {
      return Container();
    }

    return sendback;
  }
}
