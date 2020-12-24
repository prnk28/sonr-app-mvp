import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sonar_app/modules/card/card_controller.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ General Invite Builds from Invite Protobuf ^ //
class CardInvite extends GetView<CardController> {
  final AuthInvite invite;
  CardInvite(this.invite);

  @override
  Widget build(BuildContext context) {
    // Initialize
    Widget inviteView;

    // File
    if (invite.payload.type == Payload_Type.FILE) {
      inviteView = _FileInvite(invite);
    }
    // Contact
    else if (invite.payload.type == Payload_Type.CONTACT) {
      inviteView = _ContactInvite(invite.payload.contact);
    }
    // Invalid Right Now
    else {
      print("Invalid File");
      inviteView = Container();
    }

    return NeumorphicBackground(
        margin: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 200),
        borderRadius: BorderRadius.circular(40),
        backendColor: Colors.transparent,
        child: Neumorphic(
            style: NeumorphicStyle(color: K_BASE_COLOR),
            child: Container(
              child: Column(children: [
                // @ Top Right Close/Cancel Button
                closeButton(() {
                  // Emit Event
                  controller.declineInvite();

                  // Pop Window
                  Get.back();
                }, padTop: 8, padLeft: 8),

                // @ Invite View
                Padding(padding: EdgeInsets.all(8)),
                inviteView
              ]),
            )));
  }
}

// ^ Contact Invite from AuthInvite Proftobuf ^ //
class _ContactInvite extends GetView<CardController> {
  final Contact contact;
  _ContactInvite(this.contact);

  @override
  Widget build(BuildContext context) {
    // Display Info
    return Column(children: [
      // @ Basic Contact Info - Make Expandable
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(padding: EdgeInsets.all(8)),
        Column(
          children: [
            SonrText.bold(contact.firstName),
            SonrText.bold(contact.lastName),
          ],
        )
      ]),

      Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // @ Send Back Button
            rectangleButton("Keep and send yours", () {
              // Emit Event
              controller.acceptContact(contact, true);
              Get.back();
            }),
            Padding(padding: EdgeInsets.all(6)),
            // @ Save Button
            rectangleButton("Keep", () {
              controller.acceptContact(contact, false);
              Get.back();
            }),
          ])
    ]);
  }
}

// ^ File Invite Builds from Invite Protobuf ^ //
class _FileInvite extends GetView<CardController> {
  final AuthInvite invite;
  _FileInvite(this.invite);

  @override
  Widget build(BuildContext context) {
    // @ Initialize Preview
    SonrIcon preview =
        SonrIcon.metaFromPayload(IconType.Thumbnail, invite.payload);

    // @ Display Info
    return Obx(() {
      // Check State of Card --> Invitation
      if (controller.state.value == CardState.Invitation) {
        return Column(
          key: UniqueKey(),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Build Item from Metadata and Peer
            preview,
            Padding(padding: EdgeInsets.all(8)),
            Column(
              children: [
                SonrText.bold(
                    invite.payload.file.mime.type.toString() +
                        " from " +
                        invite.from.firstName,
                    size: 32),
                SonrText.normal("on " + invite.from.device.platform, size: 22),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 8)),

            // @ Build Auth Action
            rectangleButton("Accept", () {
              controller.acceptFile();
            }),
          ],
        );
      }
      // @ Check State of Card --> Transfer In Progress
      else if (controller.state.value == CardState.InProgress) {
        return _FileInviteProgress(preview.data);
      }
      // @ Check State of Card --> Completed Transfer
      else if (controller.state.value == CardState.Received) {
        return _FileInviteComplete(controller.receivedFile);
      } else {
        return Container();
      }
    });
  }
}

// ^ File Invite Progress (Hook Widget) from SonrService Progress ^ //
class _FileInviteProgress extends HookWidget {
  // Required Properties
  final IconData iconData;
  final double boxHeight = Get.height / 3;
  final double boxWidth = Get.width;
  final Gradient color = randomProgressGradient();

  // Constructer
  _FileInviteProgress(this.iconData) : super(key: GlobalKey());

  @override
  Widget build(BuildContext context) {
    // Hook Controller
    final controller = useAnimationController(duration: Duration(seconds: 1));
    final iconKey = GlobalKey();
    controller.repeat();

    // Reactive to Progress
    return SlideUpAnimatedSwitcher(
      child: Obx(() {
        if (Get.find<SonrService>().progress.value < 1.0) {
          return Stack(
            key: UniqueKey(),
            children: <Widget>[
              SizedBox(
                height: boxHeight,
                width: boxWidth,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget child) {
                    return CustomPaint(
                      painter: WavePainter(
                        iconKey: iconKey,
                        waveAnimation: controller,
                        percent: Get.find<SonrService>().progress.value,
                        boxHeight: boxHeight,
                        gradient: color,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: boxHeight,
                width: boxWidth,
                child: ShaderMask(
                  blendMode: BlendMode.srcOut,
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [K_BASE_COLOR],
                    stops: [0.0],
                  ).createShader(bounds),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Icon(iconData, key: iconKey, size: 325),
                    ),
                  ),
                ),
              )
            ],
          );
        }
        controller.stop();
        controller.dispose();
        return Container();
      }),
    );
  }
}

// ^ Media Popup View ^ //
class _FileInviteComplete extends StatelessWidget {
  final Metadata meta;

  const _FileInviteComplete(this.meta, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // @ Non-Image Type
    return SlideDownAnimatedSwitcher(
      child: Container(
        key: UniqueKey(),
        margin: EdgeInsets.only(left: 20, right: 20, top: 45, bottom: 65),
        child: FittedBox(
            alignment: Alignment.center,
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 1,
                  minHeight: 1,
                ),
                child: Container(child: Image.file(File(meta.path))))),
      ),
    );
  }
}