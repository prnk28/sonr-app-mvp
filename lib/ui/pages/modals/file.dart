part of 'invite.dart';

class FileInviteView extends StatelessWidget {
  final AuthInvite invite;

  const FileInviteView(
    this.invite, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract Data
    var metadata = invite.payload.file;
    var from = invite.from;
    ReceiveController controller = Get.find();

    // Build View
    return Container(
        decoration: windowDecoration(context),
        height: Get.height / 3 + 20,
        child: Column(
          children: [
            // @ Top Right Close/Cancel Button
            GestureDetector(
              onTap: () {
                // Emit Event
                controller.respondPeer(false);

                // Pop Window
                Get.back();
              },
              child: getWindowCloseButton(),
            ),

            // Build Item from Metadata and Peer
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _getPreview(metadata),
              Padding(padding: EdgeInsets.all(8)),
              Column(
                children: [
                  Text(from.firstName, style: headerTextStyle()),
                  Text(from.device.platform,
                      style: TextStyle(
                          fontFamily: "Raleway",
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          color: Colors.black54))
                ],
              ),
            ]),
            Padding(padding: EdgeInsets.only(top: 8)),

            // Build Auth Action
            NeumorphicButton(
                onPressed: () {
                  // Emit Event
                  controller.respondPeer(true);
                },
                style: NeumorphicStyle(
                    depth: 8,
                    shape: NeumorphicShape.concave,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(8))),
                padding: const EdgeInsets.all(12.0),
                child: Text("Accept",
                    style: smallTextStyle())), // FlatButton// Container
          ],
        ));
    // FlatButton// Container
  }

  Widget _getPreview(Metadata metadata) {
    switch (metadata.mime.type) {
      case MIME_Type.audio:
        return Icon(Icons.audiotrack, size: 100);
        break;
      case MIME_Type.image:
        if (metadata.thumbnail != null) {
          return ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: 1, minHeight: 1, maxWidth: 200), // here
                      child: Image.memory(metadata.thumbnail))));
        } else {
          return Icon(Icons.image, size: 100);
        }
        break;
      case MIME_Type.video:
        return Icon(Icons.video_collection, size: 100);
        break;
      case MIME_Type.text:
        return Icon(Icons.sort_by_alpha, size: 100);
        break;
      default:
        return Icon(Icons.device_unknown, size: 100);
        break;
    }
    return Container();
  }
}
