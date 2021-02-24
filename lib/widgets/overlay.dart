import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sonr_app/modules/card/card_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:get/get.dart';
import 'package:sonr_core/sonr_core.dart';

import 'form.dart';

// @ Overlay Entry Location Enum - Top is Default
enum OverlayEntryLocation {
  Top,
  Bottom,
  Left,
  Right,
}

// ** Class Controls Active Overlays ** //
class SonrOverlay extends GetxController {
  // Fixed Properties
  final overlays = <_SonrFixedOverlayEntry>[].obs;
  final currentOverlay = Rx<_SonrFixedOverlayEntry>();

  // References
  static bool get isOpen => Get.find<SonrOverlay>().overlays.length > 0;
  static int get count => Get.find<SonrOverlay>().overlays.length;
  static SonrOverlay get _controller => Get.find<SonrOverlay>();

  // ^ Method Finds Overlay Controller and Opens View ^ //
  static show(Widget view,
      {Duration backgroundDuration = const Duration(milliseconds: 200),
      Duration entryDuration = const Duration(milliseconds: 300),
      bool barrierDismissible: true,
      bool disableAnimation: false,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
      OverlayEntryLocation entryLocation = OverlayEntryLocation.Top}) {
    // Create Overlay
    var overlay =
        _SonrFixedOverlayEntry(entryLocation, backgroundDuration, entryDuration, barrierDismissible, view, disableAnimation: disableAnimation);

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
    var questionOverlay = _SonrFixedOverlayEntry(
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
    var alertOverlay = _SonrFixedOverlayEntry(
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
    var cardOverlay = _SonrFixedOverlayEntry(
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
    var cardOverlay = _SonrFixedOverlayEntry(
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
  static closeAll() {
    if (isOpen) {
      // Iterate through Overlays
      _controller.overlays.forEach((overlay) {
        overlay.dismiss();
      });

      // Clear List
      _controller.overlays.clear();
      _controller.currentOverlay.nil();

      // Refresh List
      _controller.overlays.refresh();
    } else {
      print("Overlay is not open");
    }
  }
}

// ** Class Controls Active Overlays ** //
class SonrPositionedOverlay extends GetxController {
  // Positioned Properties
  final overlays = <_SonrPositionedOverlayEntry>[].obs;
  final currentOverlay = Rx<_SonrPositionedOverlayEntry>();

  // References
  static bool get isOpen => Get.find<SonrPositionedOverlay>().overlays.length > 0;
  static int get count => Get.find<SonrPositionedOverlay>().overlays.length;
  static SonrPositionedOverlay get _controller => Get.find<SonrPositionedOverlay>();

  // ^ Opens View at Position with Size ^ //
  static open(Widget view, Size size, Offset position,
      {bool barrierDismissible = true,
      Duration entryDuration = const Duration(milliseconds: 200),
      OverlayEntryLocation entryLocation = OverlayEntryLocation.Top}) {
    // Create Overlay
    var overlay = _SonrPositionedOverlayEntry(size, position, view, barrierDismissible);

    // Add Overlay to List
    _controller.currentOverlay(overlay);
    _controller.overlays.add(overlay);
  }

  static dropdown(List<SonrDropdownItem> items, GlobalKey key, ValueChanged<int> onChanged,
      {Duration entryDuration = const Duration(milliseconds: 200),
      OverlayEntryLocation entryLocation = OverlayEntryLocation.Top,
      double height,
      double width,
      EdgeInsets margin}) {
    // Get Position
    RenderBox renderBox = key.currentContext.findRenderObject();
    var size = renderBox.size;
    var position = renderBox.localToGlobal(Offset.zero);

    // Create Overlay
    var overlay = _SonrPositionedOverlayEntry(
        size, position, _DropdownOverlayView(count, items, key, onChanged, height: height, width: width, margin: margin), true);

    // Add Overlay to List
    _controller.currentOverlay(overlay);
    _controller.overlays.add(overlay);
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
}

// ** Class Presents Overlay Widget Entry on Context ** //
class _SonrFixedOverlayEntry {
  // Properties
  final OverlayEntryLocation entryLocation;
  final Duration backgroundDuration;
  final Duration entryDuration;
  final Widget overlayWidget;
  final double blur;
  final Color backgroundColor;
  final bool barrierDismissible;
  final bool disableAnimation;
  final MainAxisAlignment mainAxisAlignment;

  // References
  Function dismiss;
  OverlayEntry overlay, overlayBackground;

  // ** Constructer ** //
  _SonrFixedOverlayEntry(this.entryLocation, this.backgroundDuration, this.entryDuration, this.barrierDismissible, this.overlayWidget,
      {this.blur = 5.0,
      this.backgroundColor = SonrColor.overlayBackground,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.disableAnimation = false}) {
    dismiss = () {
      overlayBackground.remove();
      overlay.remove();
    };
    overlayBackground = OverlayEntry(builder: (context) {
      return Positioned.fill(
        child: GestureDetector(
          onTap: () => barrierDismissible ? SonrOverlay.back() : () {},
          child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blur,
                sigmaY: blur,
              ),
              child: Container(
                color: backgroundColor,
              )),
        ),
      );
    });
    overlay = OverlayEntry(builder: (context) {
      return _BaseOverlayView(
          Column(
            mainAxisAlignment: mainAxisAlignment,
            children: [overlayWidget],
          ),
          entryDuration,
          entryLocation,
          disableAnimation);
    });
    buildOverlay();
  }

  void buildOverlay() {
    Navigator.of(Get.context).overlay.insertAll([overlayBackground, overlay]);
  }
}

// ** Class Presents Positioned Overlay Widget Entry on Context ** //
class _SonrPositionedOverlayEntry {
  // Properties
  final Widget widget;
  final bool barrierDismissible;
  final Size size;
  final Offset position;

  // References
  Function dismiss;
  OverlayEntry overlay, overlayBackground;

  // ** Constructer ** //
  _SonrPositionedOverlayEntry(this.size, this.position, this.widget, this.barrierDismissible) {
    dismiss = () {
      overlayBackground.remove();
      overlay.remove();
    };
    overlayBackground = OverlayEntry(builder: (context) {
      return Positioned.fill(
        child: GestureDetector(
          onTap: () => barrierDismissible ? SonrPositionedOverlay.back() : () {},
        ),
      );
    });
    overlay = OverlayEntry(
      builder: (context) {
        return Positioned(top: position.dy + size.height, left: position.dx, width: size.width, child: widget);
      },
    );
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
  final bool disableAnimation;
  const _BaseOverlayView(this.child, this.duration, this.entryLocation, this.disableAnimation);
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
    return widget.disableAnimation
        ? widget.child
        : SlideTransition(
            position: position,
            child: widget.child,
          );
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
                        SonrOverlay.back();
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

// ** Class Builds Dropdown View Widget for Positioned Overlay ** //
class _DropdownOverlayView extends StatelessWidget {
  final int index; // Index of Overlay
  final List<SonrDropdownItem> items;
  final GlobalKey parentKey;
  final ValueChanged<int> onChanged;
  final double height;
  final double width;
  final EdgeInsets margin;

  // Constructer
  _DropdownOverlayView(this.index, this.items, this.parentKey, this.onChanged, {this.height, this.width, this.margin});

  @override
  Widget build(BuildContext context) {
    RenderBox renderBox = parentKey.currentContext.findRenderObject();
    var size = renderBox.size;
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        height: height ?? (items.length * size.height) / 1.5 + 20,
        width: width ?? size.width,
        child: Neumorphic(
          margin: margin ?? EdgeInsets.symmetric(horizontal: 12),
          style: SonrStyle.dropDownBox,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: NeumorphicButton(
                  style: SonrStyle.flat,
                  padding: EdgeInsets.all(10),
                  onPressed: () {
                    onChanged(index);
                    SonrPositionedOverlay.back();
                  },
                  child: Stack(children: [items[index]]),
                ),
              );
            },
          ),
        ),
      ),
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
                        SonrOverlay.back();
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
                        SonrOverlay.back();
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
