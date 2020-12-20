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

    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 45, bottom: 65),
        child: Neumorphic(
            style: SonrBorderStyle(),
            child: Column(children: [
              // @ Top Right Close/Cancel Button
              closeButton(() {
                // Emit Event
                controller.declineInvite();

                // Pop Window
                Get.back();
              }, padTop: 8, padRight: 8),

              // @ Invite View
              Padding(padding: EdgeInsets.all(8)),
              inviteView
            ])));
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
            boldText(contact.firstName),
            boldText(contact.lastName),
          ],
        )
      ]),

      // @ Send Back Button
      rectangleButton("Send Back", () {
        // Emit Event
        controller.acceptContact(contact, true);
        Get.back();
      }),

      // @ Save Button
      rectangleButton("Save", () {
        controller.acceptContact(contact, false);
        Get.back();
      }),
    ]);
  }
}

// ^ File Invite Builds from Invite Protobuf ^ //
class _FileInvite extends GetView<CardController> {
  final AuthInvite invite;
  _FileInvite(this.invite);

  @override
  Widget build(BuildContext context) {
    // Display Info
    return Obx(() {
      // Check State of Card --> Invitation
      if (controller.state.value == CardState.Invitation) {
        return Column(
          children: [
            // Build Item from Metadata and Peer
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              iconWithPreview(invite.payload.file),
              Padding(padding: EdgeInsets.all(8)),
              Column(
                children: [
                  boldText(invite.from.firstName, size: 32),
                  normalText(invite.from.device.platform, size: 22),
                ],
              ),
            ]),
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
        return AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: _FileInviteProgress(iconDataFromPayload(invite.payload)));
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
  final Color waveColor = Colors.blueAccent;
  final controller = useAnimationController(duration: Duration(seconds: 2));

  // Constructer
  _FileInviteProgress(this.iconData) : super(key: GlobalKey());

  @override
  Widget build(BuildContext context) {
    // Reactive to Sonr Service
    return Obx(() {
      if (Get.find<SonrService>().progress.value < 1.0) {
        return Stack(
          children: <Widget>[
            SizedBox(
              height: boxHeight,
              width: boxWidth,
              child: AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget child) {
                  return CustomPaint(
                    painter: WavePainter(
                      iconKey: key,
                      waveAnimation: controller,
                      percent: Get.find<SonrService>().progress.value,
                      boxHeight: boxHeight,
                      waveColor: waveColor,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: boxHeight,
              width: boxWidth,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Icon(iconData, key: key, size: 225),
                ),
              ),
            ),
          ],
        );
      }
      controller.stop();
      return Container();
    });
  }
}
