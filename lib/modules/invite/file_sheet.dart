import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonar_app/modules/invite/progress_view.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/sonr_core.dart';

class FileInviteSheet extends StatelessWidget {
  final AuthInvite invite;

  const FileInviteSheet(
    this.invite, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // @ Extract Data
    var metadata = invite.payload.file;
    var from = invite.from;
    SonrService sonr = Get.find();

    return Obx(() {
      // @ In Transfer
      if (sonr.status() == Status.Busy) {
        return Container(
            decoration: SonrWindowDecoration(context),
            height: Get.height / 3 + 20,
            child: Center(
                child: ProgressView(
                    iconData: iconDataFromPayload(sonr.invite.payload))));
      }
      // @ Pending
      else if (sonr.status() == Status.Pending) {
        // Build AuthView
        return Container(
            decoration: SonrWindowDecoration(context),
            height: Get.height / 3 + 20,
            child: Column(
              children: [
                // @ Top Right Close/Cancel Button
                GestureDetector(
                    onTap: () {
                      // Emit Event
                      sonr.respondPeer(false);

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
                            )))),

                // Build Item from Metadata and Peer
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _getPreview(metadata),
                  Padding(padding: EdgeInsets.all(8)),
                  Column(
                    children: [
                      Text(from.firstName, style: _mediumTextStyle()),
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
                      sonr.respondPeer(true);
                    },
                    style: NeumorphicStyle(
                        depth: 8,
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(8))),
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Accept",
                        style: _smallTextStyle())), // FlatButton// Container
              ],
            ));
      }
      // @ Error
      else {
        return Container();
      }
    });
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

  // ^ Retreive File Preview ^ //
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
  }
}
