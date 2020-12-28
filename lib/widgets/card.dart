import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sonar_app/data/model_card.dart';
import 'package:sonar_app/modules/home/home_controller.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

enum CardState { None, Invitation, InProgress, Received, Viewing }

// * ------------------------ * //
// * ---- Card View --------- * //
// * ------------------------ * //
class SonrCard extends GetView<SonrCardController> {
  final AuthInvite invite;
  final Contact contact;
  final bool isInvite;

  SonrCard(this.isInvite, {this.invite, this.contact});

  factory SonrCard.fromInvite(AuthInvite inv) => SonrCard(true, invite: inv);

  factory SonrCard.fromReplyAsContact(Contact c) => SonrCard(false, contact: c);

  @override
  Widget build(BuildContext context) {
    // @ Invite View
    if (isInvite) {
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
                  SonrButton.close(() {
                    // Emit Event
                    controller.declineInvite();

                    // Pop Window
                    Get.back();
                  }, padTop: 8, padRight: 8),

                  // @ Invite View
                  Padding(padding: EdgeInsets.all(8)),
                  inviteView
                ]),
              )));
    }
    // @ Reply View
    else {
      assert(contact != null);

      // Display Info
      return Column(children: [
        // Basic Contact Info - Make Expandable
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(padding: EdgeInsets.all(8)),
          Column(
            children: [
              SonrText.bold(contact.firstName),
              SonrText.bold(contact.lastName),
            ],
          )
        ]),

        // Save Button
        SonrButton.rectangle(SonrText.normal("Keep"), () {
          controller.acceptContact(contact, false);
          Get.back();
        }),
      ]);
    }
  }
}

// ^ Contact Invite from AuthInvite Proftobuf ^ //
class _ContactInvite extends GetView<SonrCardController> {
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
            SonrButton.rectangle(SonrText.normal("Keep and send yours"), () {
              // Emit Event
              controller.acceptContact(contact, true);
              Get.back();
            }),
            Padding(padding: EdgeInsets.all(6)),
            // @ Save Button
            SonrButton.rectangle(SonrText.normal("Keep"), () {
              controller.acceptContact(contact, false);
              Get.back();
            }),
          ])
    ]);
  }
}

// ^ File Invite Builds from Invite Protobuf ^ //
class _FileInvite extends GetView<SonrCardController> {
  final AuthInvite invite;
  _FileInvite(this.invite);

  @override
  Widget build(BuildContext context) {
    // @ Initialize Preview
    SonrIcon preview = SonrIcon.file(IconType.Thumbnail, invite.payload);

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
            SonrButton.rectangle(SonrText.normal("Accept"), () {
              controller.acceptFile();
            }, icon: SonrIcon.success),
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
                      child: Icon(iconData, key: iconKey, size: 250),
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

// ^ File Received View ^ //
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
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(File(meta.path))))),
      ),
    );
  }
}

// * ------------------------------ * //
// * ---- Card Controller --------- * //
// * ------------------------------ * //
class SonrCardController extends GetxController {
  // Properties
  final state = CardState.None.obs;
  bool accepted = false;
  Metadata receivedFile;

  // ^ Update State to be Invitation ^ //
  setInvited() {
    state(CardState.Invitation);
  }

  // ^ Accept File Invite Request ^ //
  acceptFile() {
    state(CardState.InProgress);
    Get.find<SonrService>().respond(true);
    accepted = true;
  }

  // ^ Accept Contact Invite Request ^ //
  acceptContact(Contact c, bool sb) {
    // Check if Send Back
    if (sb) {
      Get.find<SonrService>().respond(true);
    }

    // Save Contact
    Get.find<SonrService>().saveContact(c);

    // Create Contact Card
    var card = CardModel.fromContact(c);
    accepted = true;

    // Add to Cards Display Last Card
    Get.find<HomeController>().addCard(card);
  }

  // ^ Decline Invite Request ^ //
  declineInvite() {
    // Check if accepted
    if (!accepted) {
      Get.find<SonrService>().respond(false);
    }

    Get.back();
    state(CardState.None);
  }

  // ^ Set File after Transfer^ //
  received(Metadata meta) {
    state(CardState.Received);
    receivedFile = meta;

    // Create Metadata Card
    var card = CardModel.fromMetadata(meta);

    // Add to Cards Display Last Card
    Get.find<HomeController>().addCard(card);
  }
}
