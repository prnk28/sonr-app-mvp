import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sonr_app/modules/home/home_controller.dart';
import 'package:sonr_app/modules/home/home_screen.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/service/sql_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

enum CardType { None, Invite, InProgress, Reply, Received, Item }
const K_CARD_MARGIN = {
  Payload.CONTACT: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 90),
  Payload.MEDIA: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 180),
  Payload.URL: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 450)
};

// * ------------------------ * //
// * ---- Card View --------- * //
// * ------------------------ * //
class SonrCard extends GetWidget<TransferCardController> {
  // Properties
  final CardType type;

  // References
  final AuthInvite invite;
  final AuthReply reply;
  final TransferCard card;
  final int index;

  // ** Constructer ** //
  SonrCard({
    Key key,
    @required this.type,
    this.invite,
    this.reply,
    this.card,
    this.index,
  });

  // @ Factory for Invite Protobuf Data
  factory SonrCard.fromInvite(AuthInvite invite) {
    return SonrCard(invite: invite, type: CardType.Invite, card: invite.card);
  }

  // @ Factory for Reply Protobuf Data
  factory SonrCard.fromReply(AuthReply reply) {
    return SonrCard(reply: reply, type: CardType.Reply, card: reply.card);
  }

  // @ Factory for SQL TransferCard Data
  factory SonrCard.fromItem(TransferCard card, int index) {
    return SonrCard(type: CardType.Item, card: card, index: index);
  }

  @override
  Widget build(BuildContext context) {
    // * Completed Card * //
    if (type == CardType.Item) {
      // Initialize TransferItem Controller
      controller.initialize(card, index);

      // Return View
      return Obx(() {
        // @ Current Card is in Focus
        if (controller.isFocused.value) {
          return PlayAnimation<double>(
            tween: (0.85).tweenTo(0.95),
            duration: 200.milliseconds,
            builder: (context, child, value) {
              return Transform.scale(
                scale: value,
                child: _CardItemView(card, controller),
              );
            },
          );
        }

        if (controller.hasLeftFocus.value) {
          return PlayAnimation<double>(
            tween: (0.95).tweenTo(0.85),
            duration: 200.milliseconds,
            builder: (context, child, value) {
              return Transform.scale(
                scale: value,
                child: _CardItemView(card, controller),
              );
            },
          );
        }

        // @ Current Card is Out of Focus
        return Transform.scale(
          scale: 0.85,
          child: _CardItemView(card, controller),
        );
      });
    }

    // * Invited Card * //
    else if (type == CardType.Invite) {
      controller.invited();
      return _CardDialogView(invite.card, invite.payload, controller, false);
    }

    // * Replied Card * //
    else if (type == CardType.Reply) {
      return _CardDialogView(reply.card, reply.payload, controller, true);
    } else {
      print("Error with Card Type");
      return Container();
    }
  }
}

// ^ BASE: TransferCard Item View ^ //
class _CardItemView extends StatelessWidget {
  final TransferCard card;
  final TransferCardController controller;
  final bool beginGlow;

  _CardItemView(this.card, this.controller, {this.beginGlow = false});
  @override
  Widget build(BuildContext context) {
    // Initialize Views
    final viewForPayload = {Payload.MEDIA: _FileItemView(card), Payload.CONTACT: _ContactItemView(card)};

    // Create View
    return Neumorphic(
      style: SonrStyle.cardItem,
      margin: EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () {
          controller.openCard();
        },
        child: Hero(
          tag: card.id,
          child: Container(
            height: 75,
            decoration: card.payload == Payload.MEDIA
                ? BoxDecoration(
                    image: DecorationImage(
                    colorFilter: ColorFilter.mode(Colors.black26, BlendMode.luminosity),
                    fit: BoxFit.cover,
                    image: MemoryImage(card.metadata.thumbnail),
                  ))
                : null,
            child: viewForPayload[card.payload],
          ),
        ),
      ),
    );
  }
}

// ^ BASE: Card Invite/Reply/Progress View ^ //
class _CardDialogView extends StatelessWidget {
  final Payload payload;
  final TransferCard card;
  final TransferCardController controller;
  final bool isReply;

  const _CardDialogView(this.card, this.payload, this.controller, this.isReply);
  @override
  Widget build(BuildContext context) {
    // Initialize Views
    final viewForPayload = {
      Payload.MEDIA: _FileInviteView(card, controller),
      Payload.CONTACT: _ContactInviteView(card, controller, isReply),
      Payload.URL: _URLInviteView(card, controller)
    };

    return NeumorphicBackground(
        margin: K_CARD_MARGIN[payload],
        borderRadius: BorderRadius.circular(40),
        backendColor: Colors.transparent,
        child: Neumorphic(
          style: NeumorphicStyle(color: K_BASE_COLOR),
          child: AnimatedContainer(
            duration: 1.seconds,
            child: viewForPayload[payload],
          ),
        ));
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
      // @ Header
      SonrHeaderBar.closeAccept(
        title: SonrText.invite(Payload.CONTACT.toString(), card.contact.firstName),
        onAccept: () {
          controller.acceptContact(card, false);
          Get.back();
        },
        onCancel: () {
          Get.back();
        },
      ),
      Padding(padding: EdgeInsets.all(8)),

      // @ Basic Contact Info - Make Expandable
      SonrText.bold(card.contact.firstName),
      SonrText.bold(card.contact.lastName),

      // @ Send Back Button
      !isReply
          ? Align(
              alignment: Alignment.bottomCenter,
              child: SonrButton.rectangle(
                  text: SonrText.normal("Send yours back"),
                  onPressed: () {
                    // Emit Event
                    controller.acceptContact(card, true);
                    Get.back();
                  }))
          : Container()
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
      Widget child;

      // Check State of Card --> Invitation
      if (controller.state.value == CardType.Invite) {
        child = Column(
          mainAxisSize: MainAxisSize.max,
          key: UniqueKey(),
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // @ Header
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
            Padding(padding: EdgeInsets.all(8)),

            // @ Build Item from Metadata and Peer
            Expanded(child: SonrIcon.preview(IconType.Thumbnail, card)),
            SonrText.normal(card.properties.mime.type.toString().capitalizeFirst, size: 22),
          ],
        );
      }
      // @ Check State of Card --> Transfer In Progress
      else if (controller.state.value == CardType.InProgress) {
        child = _FileInviteProgress(SonrIcon.preview(IconType.Thumbnail, card).data);
      }

      return AnimatedContainer(duration: Duration(seconds: 1), child: child);
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
    return SonrAnimatedWidget(
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

// ^ TransferCard File Item Details ^ //
class _FileItemView extends StatelessWidget {
  final TransferCard card;

  _FileItemView(this.card);
  @override
  Widget build(BuildContext context) {
    DateTime received = DateTime.fromMillisecondsSinceEpoch(card.received * 1000);
    return Stack(
      children: <Widget>[
        // Time Stamp
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Neumorphic(
              style: SonrStyle.timeStamp,
              child: SonrText.date(received),
              padding: EdgeInsets.all(10),
            ),
          ),
        ),

        // Info Button
        Align(
          alignment: Alignment.topRight,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SonrButton.circle(
                  icon: SonrIcon.info, onPressed: () => SonrOverlay.fromMetaCard(card: card, context: context), shadowLightColor: Colors.black38)),
        ),
      ],
    );
  }
}

// ^ TransferCard Contact Item Details ^ //
class _ContactItemView extends StatelessWidget {
  final TransferCard card;

  _ContactItemView(this.card);
  @override
  Widget build(BuildContext context) {
    Contact contact = card.contact;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SonrText.normal(contact.firstName),
      SonrText.normal(contact.lastName),
    ]);
  }
}

// * ------------------------------ * //
// * ---- Card Controller --------- * //
// * ------------------------------ * //
class TransferCardController extends GetxController {
  // Properties
  final state = CardType.None.obs;
  final isFocused = false.obs;
  final hasLeftFocus = false.obs;

  // References
  bool _initialized = false;
  bool _accepted = false;
  TransferCard card;
  int index;

  // ^  Check if Focused ^
  TransferCardController() {
    Get.find<HomeController>().pageIndex.listen((currIdx) {
      if (_initialized) {
        // Check if No Longer Focused
        if (isFocused.value) {
          // Set to Scale Down
          hasLeftFocus(index == currIdx);

          // Reset after Delay
          Future.delayed(200.milliseconds, () {
            hasLeftFocus(false);
          });
        }

        // Update Focused
        isFocused(index == currIdx);
      }
    });
  }

  // ^ Sets TransferCard Data for this Widget ^
  initialize(TransferCard card, int index) {
    this.card = card;
    this.index = index;
    _initialized = true;
    isFocused(index == 0);
  }

  // ^ Sets Card for Invited Data for this Widget ^
  invited() {
    state(CardType.Invite);
    HapticFeedback.heavyImpact();
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
  openCard() {
    if (isFocused.value) {
      // Close Share Menu
      Get.find<HomeController>().toggleShareExpand(options: ToggleForced(false));

      // Push to Page
      Get.to(ExpandedView(card: card), transition: Transition.fadeIn);
    }
  }
}
