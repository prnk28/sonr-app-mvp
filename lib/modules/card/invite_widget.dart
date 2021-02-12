import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sonr_app/modules/home/home_controller.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/service/sql_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

enum CardType { None, Invite, InProgress, Reply, Received, Item }

class InviteCardView extends GetWidget<TransferCardController> {
  // References
  final AuthInvite invite;
  final AuthReply reply;
  final TransferCard card;
  final bool isReply;

  // ** Constructer ** //
  const InviteCardView({Key key, this.invite, this.reply, this.card, this.isReply}) : super(key: key);

  // @ Factory for Invite Protobuf Data
  factory InviteCardView.fromInvite(AuthInvite invite) {
    return InviteCardView(invite: invite, card: invite.card, isReply: false);
  }

  // @ Factory for Reply Protobuf Data
  factory InviteCardView.fromReply(AuthReply reply) {
    return InviteCardView(reply: reply, card: reply.card, isReply: true);
  }

  @override
  Widget build(BuildContext context) {
    controller.invited();
    if (invite.payload == Payload.MEDIA) {
      return _FileInviteView(card, controller);
    } else if (invite.payload == Payload.CONTACT) {
      return _ContactInviteView(card, controller, isReply);
    } else {
      return _URLInviteView(card, controller);
    }
  }
}

// ^ Contact Invite from AuthInvite Proftobuf ^ //
class _ContactInviteView extends StatelessWidget {
  final TransferCardController controller;
  final TransferCard card;
  final bool isReply;
  _ContactInviteView(this.card, this.controller, this.isReply);

  @override
  Widget build(BuildContext context) {
    // Display Info
    return Column(mainAxisSize: MainAxisSize.max, children: [
      // @ Basic Contact Info - Make Expandable
      SonrText.bold(card.contact.firstName),
      SonrText.bold(card.contact.lastName),

      // @ Footer
      Divider(),
      SonrHeaderBar.closeAccept(
        title: SonrText.invite(Payload.CONTACT.toString(), card.contact.firstName),
        onAccept: () {
          if (!isReply) {
            SonrDialog.small(Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // @ Footer
              SonrHeaderBar.closeAccept(
                title: SonrText.header("Send Back?", size: 32),
                onAccept: () {
                  controller.acceptContact(card, true);
                  Get.back(closeOverlays: true);
                },
                onCancel: () {
                  controller.acceptContact(card, false);
                  Get.back(closeOverlays: true);
                },
              ),
              Divider(),
              Container(
                  child: SonrText.normal("Would you like to send your contact card back to ${card.contact.firstName}"),
                  margin: EdgeInsets.symmetric(horizontal: 4))
            ]));
          } else {
            controller.acceptContact(card, false);
          }
        },
        onCancel: () {
          Get.back();
        },
      ),
    ]);
  }
}

// ^ URL Invite from AuthInvite Proftobuf ^ //
class _URLInviteView extends StatelessWidget {
  final TransferCardController controller;
  final TransferCard card;
  _URLInviteView(this.card, this.controller);

  @override
  Widget build(BuildContext context) {
    final name = card.firstName;
    final url = card.url;

    return Column(mainAxisSize: MainAxisSize.max, children: [
      // @ Header
      SonrHeaderBar.closeAccept(
        title: SonrText.invite(Payload.URL.toString(), name),
        onAccept: () {
          Get.back();
          Get.find<DeviceService>().launchURL(url);
        },
        onCancel: () {
          Get.back();
        },
      ),
      Divider(),

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
                style: SonrStyle.indented,
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

// ^ File Invite Builds from Invite Protobuf ^ //
class _FileInviteView extends StatelessWidget {
  final TransferCard card;
  final TransferCardController controller;
  _FileInviteView(this.card, this.controller);

  @override
  Widget build(BuildContext context) {
    // @ Display Info
    return Obx(() {
      // Check State of Card --> Invitation
      if (controller.state.value == CardType.Invite) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          key: UniqueKey(),
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // @ Build Item from Metadata and Peer
            Expanded(child: SonrIcon.preview(IconType.Thumbnail, card)),
            SonrText.normal(card.properties.mime.type.toString().capitalizeFirst, size: 22),

            // @ Footer
            Divider(),
            SonrHeaderBar.closeAccept(
              title: SonrText.invite(card.payload.toString(), card.firstName),
              onAccept: () {
                controller.acceptFile();
              },
              onCancel: () {
                controller.declineInvite();
                Get.back();
              },
            ),
          ],
        );
      }
      // @ Check State of Card --> Transfer In Progress
      else if (controller.state.value == CardType.InProgress) {
        return _FileInviteProgress(SonrIcon.preview(IconType.Thumbnail, card).data);
      }
      return Container();
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
    return Obx(() {
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
    });
  }
}

// * ------------------------------ * //
// * ---- Card Controller --------- * //
// * ------------------------------ * //
class TransferCardController extends GetxController {
  // Properties
  final state = CardType.None.obs;

  // References
  bool _accepted = false;
  TransferCard card;
  int index;

  // ^ Sets TransferCard Data for this Widget ^
  initialize(TransferCard card, int index) {
    this.card = card;
    this.index = index;
  }

  // ^ Sets Card for Invited Data for this Widget ^
  invited() {
    state(CardType.Invite);
  }

  // ^ Accept File Invite Request ^ //
  acceptFile() {
    state(CardType.InProgress);
    Get.find<SonrService>().respond(true);
    _accepted = true;
  }

  // ^ Accept Contact Invite Request ^ //
  acceptContact(TransferCard c, bool sb) {
    // Check if Send Back
    if (sb) {
      Get.find<SonrService>().respond(true);
    }

    // Save Card
    Get.find<SQLService>().storeCard(c);

    // Add to Cards Display Last Card
    Get.find<HomeController>().addCard(c);
  }

  // ^ Decline Invite Request ^ //
  declineInvite() {
    // Check if accepted
    if (!_accepted) {
      Get.find<SonrService>().respond(false);
    }

    Get.back();
    state(CardType.None);
  }

  // ^ Expands Transfer Card into Hero ^ //
  openCard() {}
}
