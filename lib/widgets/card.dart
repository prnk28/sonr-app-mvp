import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sonar_app/data/model_card.dart';
import 'package:sonar_app/modules/home/home_controller.dart';
import 'package:sonar_app/service/device_service.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

enum CardState { None, Invitation, InProgress, Received, Viewing }

// * ------------------------ * //
// * ---- Card View --------- * //
// * ------------------------ * //
class SonrCard extends GetView<SonrCardController> {
  // Properties
  final Widget child;
  final Payload payloadType;
  final double bottom;

  const SonrCard(
      {Key key,
      @required this.child,
      @required this.payloadType,
      @required this.bottom});

  // @ Dialog for Invite Contact
  factory SonrCard.fromInviteContact(Contact contact) {
    final double contactbottom = 90;
    return SonrCard(
        child: _ContactInvite(contact),
        payloadType: Payload.CONTACT,
        bottom: contactbottom);
  }

  // @ Dialog for Invite File
  factory SonrCard.fromInviteMetadata(AuthInvite invite) {
    final double metaBottom = 180;
    return SonrCard(
        child: _FileInvite(invite.file, invite.from),
        payloadType: Payload.FILE,
        bottom: metaBottom);
  }

  // @ Dialog for Invite URL
  factory SonrCard.fromInviteUrl(String url, String firstName) {
    final double urlBottom = 360;
    return SonrCard(
        child: _URLInvite(url, firstName),
        payloadType: Payload.URL,
        bottom: urlBottom);
  }

  // @ Dialog for Replied Contact
  factory SonrCard.asReply(Contact c) {
    final double contactbottom = 90;
    return SonrCard(
        child: _ContactReply(c),
        payloadType: Payload.CONTACT,
        bottom: contactbottom);
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
        margin: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: bottom),
        borderRadius: BorderRadius.circular(40),
        backendColor: Colors.transparent,
        child: Neumorphic(
          style: NeumorphicStyle(color: K_BASE_COLOR),
          child: Container(child: child),
        ));
  }
}

// ^ Card Header Row ^ //
class _SonrCardHeader extends GetView<SonrCardController> {
  // Properties
  final String name;
  final Function onAccept;
  final bool hasAccept;
  final Payload type;

  // Constructer
  _SonrCardHeader(
      {@required this.type,
      @required this.name,
      this.hasAccept = true,
      this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight + 16 * 2,
      child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // @ Top Right Close/Cancel Button
            SonrButton.close(
              () {
                if (type != Payload.URL) {
                  controller.declineInvite();
                }
                Get.back();
              },
            ),

            Expanded(
              child: hasAccept
                  ? SonrText.invite(type.toString(), name)
                  : SonrText.header("Completed", size: 34),
            ),

            // @ Top Right Confirm Button
            hasAccept
                ? SonrButton.accept(() {
                    if (onAccept != null) {
                      onAccept();
                    }
                  })
                : Container()
          ]),
    );
  }
}

// ^ Contact Invite from AuthInvite Proftobuf ^ //
class _ContactInvite extends GetView<SonrCardController> {
  final Contact contact;
  _ContactInvite(this.contact);

  @override
  Widget build(BuildContext context) {
    // Display Info
    return Column(mainAxisSize: MainAxisSize.max, children: [
      // @ Header
      _SonrCardHeader(
          name: contact.firstName,
          type: Payload.CONTACT,
          onAccept: () {
            controller.acceptContact(contact, false);
            Get.back();
          }),
      Padding(padding: EdgeInsets.all(8)),

      // @ Basic Contact Info - Make Expandable
      SonrText.bold(contact.firstName),
      SonrText.bold(contact.lastName),

      // @ Send Back Button
      Align(
        alignment: Alignment.bottomCenter,
        child: SonrButton.rectangle(SonrText.normal("Send yours back"), () {
          // Emit Event
          controller.acceptContact(contact, true);
          Get.back();
        }),
      ),
    ]);
  }
}

// ^ Contact Invite from AuthInvite Proftobuf ^ //
class _ContactReply extends GetView<SonrCardController> {
  final Contact contact;
  _ContactReply(this.contact);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        // @ Header
        _SonrCardHeader(
          name: contact.firstName,
          type: Payload.CONTACT,
          onAccept: () {
            controller.acceptContact(contact, false);
            Get.back();
          },
        ),
        Padding(padding: EdgeInsets.all(8)),

        // @ Basic Contact Info - Make Expandable
        SonrText.bold(contact.firstName),
        SonrText.bold(contact.lastName),
      ]),
    );
  }
}

// ^ File Invite Builds from Invite Protobuf ^ //
class _FileInvite extends GetView<SonrCardController> {
  final Metadata metadata;
  final Peer from;
  _FileInvite(this.metadata, this.from);

  @override
  Widget build(BuildContext context) {
    // @ Display Info
    return Obx(() {
      Widget child;
      double height;

      // Check State of Card --> Invitation
      if (controller.state.value == CardState.Invitation) {
        child = Column(
          mainAxisSize: MainAxisSize.max,
          key: UniqueKey(),
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // @ Header
            _SonrCardHeader(
                name: from.firstName,
                type: Payload.FILE,
                onAccept: () {
                  controller.acceptFile();
                }),
            Padding(padding: EdgeInsets.all(8)),

            // @ Build Item from Metadata and Peer
            Expanded(child: SonrIcon.meta(IconType.Thumbnail, metadata)),
            SonrText.normal(metadata.mime.type.toString().capitalizeFirst,
                size: 22),
          ],
        );
        height = 500;
      }
      // @ Check State of Card --> Transfer In Progress
      else if (controller.state.value == CardState.InProgress) {
        child = _FileInviteProgress(
            SonrIcon.meta(IconType.Thumbnail, metadata).data);
        height = 300;
      }
      // @ Check State of Card --> Completed Transfer
      else if (controller.state.value == CardState.Received) {
        child = _FileInviteComplete(controller.receivedFile);
        height = 500;
      }

      return AnimatedContainer(
          duration: Duration(seconds: 1), child: child, height: height);
    });
  }
}

// ^ Contact Invite from AuthInvite Proftobuf ^ //
class _URLInvite extends GetView<SonrCardController> {
  final String name;
  final String url;
  _URLInvite(this.url, this.name);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      // @ Header
      Expanded(
        child: _SonrCardHeader(
            name: name,
            type: Payload.URL,
            onAccept: () {
              Get.back();
              Get.find<DeviceService>().launchURL(url);
            }),
      ),
      Padding(padding: EdgeInsets.all(8)),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // @ Sonr Icon
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SonrIcon.share(isUrl: true),
          ),

          // @ Indent View
          Expanded(
            child: Neumorphic(
                style: NeumorphicStyle(
                  depth: -8,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                ),
                margin: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SonrText.url(url),
                )),
          ),
        ],
      ),
    ]);
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
            alignment: Alignment.center,
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
    return Column(mainAxisSize: MainAxisSize.max, children: [
      // @ Header
      Expanded(
        child: _SonrCardHeader(
          name: "",
          type: Payload.FILE,
          hasAccept: false,
        ),
      ),
      Padding(padding: EdgeInsets.all(8)),
      SlideDownAnimatedSwitcher(
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
      ),
    ]);
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
