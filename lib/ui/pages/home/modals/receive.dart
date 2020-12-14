import 'package:sonar_app/ui/ui.dart';
import 'package:flutter/widgets.dart';
import 'package:sonar_app/controller/controller.dart';
import 'package:sonr_core/sonr_core.dart';
import 'liquid_fill.dart';

class ReceiveSheet extends StatelessWidget {
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
                            receive.invite().payload.file.mime.type))));
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
                  _buildItem(context, receive.invite.value),
                  Padding(padding: EdgeInsets.only(top: 8)),

                  // Build Auth Action
                  NeumorphicButton(
                      onPressed: () {
                        // Emit Event
                        receive.respondPeer(true);
                      },
                      style: NeumorphicStyle(
                          depth: 8,
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(8))),
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Accept",
                          style: smallTextStyle())), // FlatButton// Container
                ],
              ));
        });
  }
}

Row _buildItem(BuildContext context, AuthInvite state) {
  // Get Data
  var from = state.from;
  var metadata = state.payload.file;
  var contact = state.payload.contact;

  // Preview Widget
  Widget preview;
  switch (metadata.mime.type) {
    case MIME_Type.audio:
      preview = Icon(Icons.audiotrack, size: 100);
      break;
    case MIME_Type.image:
      if (metadata.thumbnail != null) {
        preview = ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            child: FittedBox(
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: 1, minHeight: 1, maxWidth: 200), // here
                    child: Image.memory(metadata.thumbnail))));
      } else {
        preview = Icon(Icons.image, size: 100);
      }
      break;
    case MIME_Type.video:
      preview = Icon(Icons.video_collection, size: 100);
      break;
    case MIME_Type.text:
      preview = Icon(Icons.sort_by_alpha, size: 100);
      break;
    default:
      preview = Icon(Icons.device_unknown, size: 100);
      break;
  }

  // Build View
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    preview,
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
  ]); // FlatButton// Container
}
