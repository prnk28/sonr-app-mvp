import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/card/card_controller.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ General Invite Builds from Invite Protobuf ^ //
class CardInvite extends GetView<CardController> {
  final AuthInvite invite;
  CardInvite(this.invite) {
    controller.state(CardState.Invitation);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // File
      if (invite.payload.type == Payload_Type.FILE) {
        return _FileInvite(invite);
      }
      // Contact
      else if (invite.payload.type == Payload_Type.CONTACT) {
        return _ContactInvite(invite.payload.contact);
      }
      // Invalid Right Now
      else {
        print("Invalid File");
        return Container();
      }
    });
  }
}

// ^ Contact Invite from AuthInvite Proftobuf ^ //
class _ContactInvite extends GetView<CardController> {
  final Contact contact;
  _ContactInvite(this.contact);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
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
            ])));
  }
}

// ^ File Invite Builds from Invite Protobuf ^ //
class _FileInvite extends GetView<CardController> {
  final AuthInvite invite;
  _FileInvite(this.invite);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Check State of Card --> Invitation
      if (controller.state.value == CardState.Invitation) {
        return Container(
            padding: EdgeInsetsDirectional.only(start: 10, end: 10),
            height: Get.height / 3 + 20,
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Neumorphic(
                style: SonrBorderStyle(),
                child: Column(
                  children: [
                    // @ Top Right Close/Cancel Button
                    closeButton(() {
                      // Emit Event
                      controller.declineInvite();
                    }, padTop: 8, padRight: 8),

                    // @ Build Item from Metadata and Peer
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
                )));
      }
      // Check State of Card --> Transfer In Progress
      else if (controller.state.value == CardState.InProgress) {
        return AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: _FileInviteProgress(iconDataFromPayload(invite.payload)));
      }
      // Check State of Card --> Viewing/Complete
      else {
        return AnimatedSwitcher(duration: Duration(seconds: 1));
      }
    });
  }
}

// ^ File Invite Progress (Stateful Widget) from Invite Protobuf ^ //
class _FileInviteProgress extends StatefulWidget {
  // Required Properties
  final IconData iconData;
  final Duration waveDuration;
  final double boxHeight = Get.height / 3;
  final double boxWidth = Get.width;
  final Color waveColor;

  // Constructer
  _FileInviteProgress(
    this.iconData, {
    Key key,
    this.waveDuration = const Duration(seconds: 2),
    this.waveColor = Colors.blueAccent,
  })  : assert(null != iconData),
        assert(null != waveDuration),
        assert(null != boxWidth),
        assert(null != waveColor),
        super(key: key);

  @override
  _FileInviteProgressState createState() => _FileInviteProgressState();
}

// ^ Builds State from Progress of Transfer ^ //
class _FileInviteProgressState extends State<_FileInviteProgress>
    with TickerProviderStateMixin {
  final _iconKey = GlobalKey();
  AnimationController _waveController;
  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: widget.waveDuration,
    );
    _waveController.repeat();
  }

  @override
  void dispose() {
    _waveController?.stop();
    _waveController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<SonrService>().progress.value < 1.0) {
        return Stack(
          children: <Widget>[
            SizedBox(
              height: widget.boxHeight,
              width: widget.boxWidth,
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (BuildContext context, Widget child) {
                  return CustomPaint(
                    painter: WavePainter(
                      iconKey: _iconKey,
                      waveAnimation: _waveController,
                      percent: Get.find<SonrService>().progress.value,
                      boxHeight: widget.boxHeight,
                      waveColor: widget.waveColor,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: widget.boxHeight,
              width: widget.boxWidth,
              child: ShaderMask(
                blendMode: BlendMode.srcOut,
                shaderCallback: (bounds) => LinearGradient(
                  colors: [NeumorphicTheme.baseColor(context)],
                  stops: [0.0],
                ).createShader(bounds),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Icon(widget.iconData, key: _iconKey, size: 225),
                  ),
                ),
              ),
            )
          ],
        );
      }
      _waveController.stop();
      return Container();
    });
  }
}
