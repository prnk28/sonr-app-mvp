import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sonr_app/modules/card/card_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:get/get.dart';
import 'package:sonr_core/sonr_core.dart';

// @ Overlay Entry Location Enum - Top is Default
enum OverlayEntryLocation {
  Top,
  Bottom,
  Left,
  Right,
}

// ** Class Controls Active Overlays ** //
class SonrOverlay extends GetxController {
  final overlays = <_SonrOverlayEntry>[].obs;
  final currentOverlay = Rx<_SonrOverlayEntry>();

  // References
  static bool get isOpen => Get.find<SonrOverlay>().overlays.length > 0;
  static int get count => Get.find<SonrOverlay>().overlays.length;
  static SonrOverlay get _controller => Get.find<SonrOverlay>();

  // ^ Method Finds Overlay Controller and Opens View ^ //
  static open(Widget view,
      {Duration backgroundDuration = const Duration(milliseconds: 200),
      Duration entryDuration = const Duration(milliseconds: 300),
      bool barrierDismissible: true,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
      OverlayEntryLocation entryLocation = OverlayEntryLocation.Top}) {
    // Create Overlay

    var overlay = _SonrOverlayEntry(entryLocation, backgroundDuration, entryDuration, barrierDismissible, view);

    // Add Overlay to List
    _controller.currentOverlay(overlay);
    _controller.overlays.add(overlay);
    return Container();
  }

  // ^ Method Finds Overlay Controller and Prompts Question ^ //
  static Future<bool> question(
      {@required String title,
      @required String description,
      String acceptTitle = "Yes!",
      String declineTitle = "No",
      bool barrierDismissible: true,
      bool closeOnResponse = true,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
      OverlayEntryLocation entryLocation = OverlayEntryLocation.Top,
      Duration backgroundDuration = const Duration(milliseconds: 200),
      Duration entryDuration = const Duration(milliseconds: 300)}) {
    // Create Future Completer
    var completer = new Completer<bool>();

    // Create Overlay
    var questionOverlay = _SonrOverlayEntry(
        entryLocation,
        backgroundDuration,
        entryDuration,
        barrierDismissible,
        _QuestionOverlayView(
          count,
          title,
          description,
          (result) {
            completer.complete(result);
          },
          acceptTitle,
          declineTitle,
          closeOnResponse,
        ));

    // Add Overlay to List
    _controller.currentOverlay(questionOverlay);
    _controller.overlays.add(questionOverlay);
    return completer.future;
  }

  // ^ Method Finds Overlay Controller and Prompts Alert ^ //
  static alert(
      {@required String title,
      @required String description,
      String buttonText = "Okay",
      bool barrierDismissible: true,
      bool closeOnResponse = true,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
      OverlayEntryLocation entryLocation = OverlayEntryLocation.Top,
      Duration backgroundDuration = const Duration(milliseconds: 200),
      Duration entryDuration = const Duration(milliseconds: 300)}) {
    // Create Overlay
    var alertOverlay = _SonrOverlayEntry(
        entryLocation,
        backgroundDuration,
        entryDuration,
        barrierDismissible,
        _AlertOverlayView(
          count,
          title,
          description,
          buttonText,
          closeOnResponse,
        ));

    // Add Overlay to List
    _controller.currentOverlay(alertOverlay);
    _controller.overlays.add(alertOverlay);
  }

  // ^ Method Finds Overlay Controller and Prompts Invite ^ //
  static invite(AuthInvite invite,
      {OverlayEntryLocation entryLocation = OverlayEntryLocation.Left,
      bool barrierDismissible: false,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
      Duration backgroundDuration = const Duration(milliseconds: 250),
      Duration entryDuration = const Duration(milliseconds: 350)}) {
    // Create Overlay
    var cardOverlay = _SonrOverlayEntry(
      entryLocation,
      backgroundDuration,
      entryDuration,
      barrierDismissible,
      _InviteReplyOverlayView(count, false, invite: invite),
    );

    // Add Overlay to List
    _controller.currentOverlay(cardOverlay);
    _controller.overlays.add(cardOverlay);
  }

  // ^ Method Finds Overlay Controller and Prompts Invite ^ //
  static reply(AuthReply reply,
      {OverlayEntryLocation entryLocation = OverlayEntryLocation.Left,
      bool barrierDismissible: false,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
      Duration backgroundDuration = const Duration(milliseconds: 250),
      Duration entryDuration = const Duration(milliseconds: 350)}) {
    // Create Overlay
    var cardOverlay = _SonrOverlayEntry(
        entryLocation,
        backgroundDuration,
        entryDuration,
        barrierDismissible,
        _InviteReplyOverlayView(
          count,
          true,
          reply: reply,
        ));

    // Add Overlay to List
    _controller.currentOverlay(cardOverlay);
    _controller.overlays.add(cardOverlay);
  }

  // ^ Method Pops Current Overlay ^ //
  static back() {
    if (isOpen) {
      // Pop Current Overlay
      if (_controller.currentOverlay.value != null) {
        _controller.currentOverlay.value.dismiss();
      }

      // Refresh List
      _controller.overlays.removeLast();
      _controller.overlays.refresh();
    } else {
      print("Overlay is not open");
    }
  }

  // ^ Method Finds Overlay Controller and Prompts Alert ^ //
  static pop({int backUntil = 1}) {
    if (isOpen) {
      // Validate PopCount is less than List Length
      if (backUntil > count) {
        backUntil = count;
      }

      // Reverse Iterate Count and Remove
      for (var i = 0; i <= count; i++) {
        _controller.overlays[i].dismiss();
        _controller.overlays.removeLast();
      }

      // Refresh List
      _controller.currentOverlay(_controller.overlays[count - 1]);
      _controller.overlays.refresh();
    } else {
      print("Overlay is not open");
    }
  }

  // ^ Method Finds Overlay Controller and Prompts Alert ^ //
  static popAt(int index) {
    if (isOpen) {
      // Validate PopCount is less than List Length
      if (index <= count - 1) {
        _controller.overlays[index].dismiss();
        _controller.overlays.removeAt(index);
      } else {
        print("Invalid Index");
      }

      // Refresh List
      _controller.currentOverlay(_controller.overlays[count - 1]);
      _controller.overlays.refresh();
    } else {
      print("Overlay is not open");
    }
  }

  // ^ Method Finds Overlay Controller and Prompts Alert ^ //
  static closeAll() {
    if (isOpen) {
      // Iterate through Overlays
      _controller.overlays.forEach((overlay) {
        overlay.dismiss();
      });

      // Clear List
      _controller.overlays.clear();
      _controller.currentOverlay(null);

      // Refresh List
      _controller.overlays.refresh();
    } else {
      print("Overlay is not open");
    }
  }
}

// ** Class Presents Overlay Widget Entry on Context ** //
class _SonrOverlayEntry {
  // Properties
  final OverlayEntryLocation entryLocation;
  final Duration backgroundDuration;
  final Duration entryDuration;
  final Widget overlayWidget;
  final double blur;
  final Color backgroundColor;
  final bool barrierDismissible;
  final MainAxisAlignment mainAxisAlignment;

  // References
  Function dismiss;
  OverlayEntry overlay, overlayBackground;

  // ** Constructer ** //
  _SonrOverlayEntry(this.entryLocation, this.backgroundDuration, this.entryDuration, this.barrierDismissible, this.overlayWidget,
      {this.blur = 5.0, this.backgroundColor = SonrColor.overlayBackground, this.mainAxisAlignment = MainAxisAlignment.center}) {
    dismiss = () {
      overlayBackground.remove();
      overlay.remove();
    };
    overlayBackground = OverlayEntry(builder: (context) {
      return PlayAnimation<double>(
          tween: (0.0).tweenTo(blur),
          duration: backgroundDuration,
          curve: Curves.easeIn,
          builder: (context, child, value) {
            return Positioned.fill(
              child: GestureDetector(
                onTap: () => barrierDismissible ? SonrOverlay.back() : () {},
                child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: value,
                      sigmaY: value,
                    ),
                    child: PlayAnimation<double>(
                        curve: Curves.easeIn,
                        tween: (0.0).tweenTo(1.0),
                        duration: backgroundDuration,
                        builder: (context, child, value) {
                          return AnimatedOpacity(
                            opacity: value,
                            duration: backgroundDuration,
                            child: Container(
                              color: backgroundColor,
                            ),
                          );
                        })),
              ),
            );
          });
    });
    overlay = OverlayEntry(builder: (context) {
      return _BaseOverlayView(
          Column(
            mainAxisAlignment: mainAxisAlignment,
            children: [overlayWidget],
          ),
          entryDuration,
          entryLocation);
    });
    buildOverlay();
  }

  void buildOverlay() {
    Navigator.of(Get.context).overlay.insertAll([overlayBackground, overlay]);
  }
}

// ** Class Builds Base Animated Overlay View ** //
class _BaseOverlayView extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final OverlayEntryLocation entryLocation;
  const _BaseOverlayView(this.child, this.duration, this.entryLocation);
  @override
  _BaseOverlayViewState createState() => _BaseOverlayViewState();
}

class _BaseOverlayViewState extends State<_BaseOverlayView> with AnimationMixin {
  Animation<Offset> position;

  void initState() {
    position = tweenForEntryLocation(widget.entryLocation);
    controller.duration = widget.duration;
    controller.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: position, child: widget.child);
  }

  // ^ Method to Retreive Animation by Location - Default is Top ^ //
  Animation<Offset> tweenForEntryLocation(OverlayEntryLocation entryLocation) {
    switch (entryLocation) {
      case OverlayEntryLocation.Bottom:
        return Offset(0.0, 1.0).tweenTo(Offset.zero).animatedBy(controller);
        break;
      case OverlayEntryLocation.Left:
        return Offset(-1.0, 0.0).tweenTo(Offset.zero).animatedBy(controller);
        break;
      case OverlayEntryLocation.Right:
        return Offset(1.0, 0.0).tweenTo(Offset.zero).animatedBy(controller);
        break;
      default:
        return Offset(0.0, -1.0).tweenTo(Offset.zero).animatedBy(controller);
        break;
    }
  }
}

// ** Class Builds Alert View Widget for Overlay ** //
class _AlertOverlayView extends StatelessWidget {
  final int index; // Index of Overlay
  final String title;
  final String description;
  final String buttonText;
  final bool closeOnResponse;

  // Constructer
  _AlertOverlayView(this.index, this.title, this.description, this.buttonText, this.closeOnResponse);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Neumorphic(
          margin: EdgeInsets.only(left: 6, right: 6),
          style: SonrStyle.overlay,
          padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 20),
          child: Container(
            margin: EdgeInsets.all(8),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SonrText.header(title),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SonrText.normal(description, size: 18),
              ),
              Padding(padding: EdgeInsets.all(4)),
              Divider(),
              Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                // Accept Button
                Container(
                  width: Get.width / 3,
                  child: SonrButton.stadium(
                    onPressed: () {
                      if (closeOnResponse) {
                        SonrOverlay.popAt(index);
                      }
                    },
                    icon: SonrIcon.accept,
                    text: SonrText.semibold(buttonText, size: 18),
                  ),
                ),
              ]),
            ]),
          )),
    );
  }
}

// ** Class Builds Alert View Widget for Overlay ** //
class _InviteReplyOverlayView extends StatelessWidget {
  final int index; // Index of Overlay
  final AuthInvite invite;
  final AuthReply reply;
  final bool isReply;

  // Constructer
  _InviteReplyOverlayView(this.index, this.isReply, {this.invite, this.reply});

  @override
  Widget build(BuildContext context) {
    // Check Payload
    Widget view;
    // Invite Provided - Get View from Payload
    if (!isReply) {
      if (invite.payload == Payload.MEDIA) {
        view = MediaCard.invite(invite);
      } else if (invite.payload == Payload.CONTACT) {
        view = ContactCard.invite(invite);
      } else if (invite.payload == Payload.URL) {
        view = URLCard.invite(invite);
      } else {
        view = FileCard.invite(invite);
      }
    }

    // Reply Provided
    else {
      view = ContactCard.reply(reply);
    }

    // Build View
    return NeumorphicBackground(
        margin: EdgeInsets.symmetric(horizontal: 20),
        borderRadius: BorderRadius.circular(30),
        backendColor: Colors.transparent,
        child: Neumorphic(
          style: NeumorphicStyle(color: SonrColor.base),
          child: view,
        ));
  }
}

// ** Class Builds Question View Widget for Overlay ** //
class _QuestionOverlayView extends GetView<SonrOverlay> {
  final int index; // Index of Overlay
  final String title;
  final String description;
  final Function(bool) onDecision;
  final String acceptTitle;
  final String declineTitle;
  final bool closeOnResponse;

  // Constructer
  _QuestionOverlayView(this.index, this.title, this.description, this.onDecision, this.acceptTitle, this.declineTitle, this.closeOnResponse);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Neumorphic(
          margin: EdgeInsets.only(left: 6, right: 6),
          style: SonrStyle.overlay,
          padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 20),
          child: Container(
            margin: EdgeInsets.all(8),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SonrText.header(title),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SonrText.normal(description, size: 18),
              ),
              Padding(padding: EdgeInsets.all(4)),
              Divider(),
              Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                // Decline Button
                TextButton(
                    onPressed: () {
                      onDecision(false);
                      if (closeOnResponse) {
                        SonrOverlay.popAt(index);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SonrText.semibold(declineTitle, color: Colors.redAccent),
                    )),
                Padding(padding: EdgeInsets.all(2)),
                // Accept Button
                Container(
                  width: Get.width / 2.75,
                  child: SonrButton.stadium(
                    onPressed: () {
                      onDecision(true);
                      if (closeOnResponse) {
                        SonrOverlay.popAt(index);
                      }
                    },
                    icon: SonrIcon.accept,
                    text: SonrText.semibold(acceptTitle),
                  ),
                ),
              ]),
            ]),
          )),
    );
  }
}
