import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/profile/profile.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'overlay.dart';

// ^ Class Controls Active Overlays ** //
class SonrOverlay extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<SonrOverlay>();
  static SonrOverlay get to => Get.find<SonrOverlay>();

  // Fixed Properties
  final overlays = <_SonrFixedOverlayEntry>[].obs;
  final currentOverlay = Rx<_SonrFixedOverlayEntry>();

  // References
  static bool get isOpen => Get.find<SonrOverlay>().overlays.length > 0;
  static bool get isNotOpen => Get.find<SonrOverlay>().overlays.length == 0;
  static int get count => Get.find<SonrOverlay>().overlays.length;
  static SonrOverlay get _controller => Get.find<SonrOverlay>();

  // ^ Initialize Service Method ^ //
  Future<SonrOverlay> init() async {
    return this;
  }

  // ^ Method Finds Overlay Controller and Opens View ^ //
  static int show(Widget view,
      { // ^,
      Duration entryDuration = const Duration(milliseconds: 300),
      bool barrierDismissible: true,
      bool disableAnimation: false,
      Color backgroundColor,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
      Offset entryLocation = SonrOffset.Top}) {
    // Create Overlay
    var overlay = _SonrFixedOverlayEntry(entryLocation, entryDuration, barrierDismissible, view,
        disableAnimation: disableAnimation, backgroundColor: backgroundColor);

    // Add Overlay to List
    _controller.currentOverlay(overlay);
    _controller.overlays.add(overlay);
    return _controller.overlays.indexOf(overlay);
  }

  // ^ Method Finds Overlay Controller and Prompts Question ^ //
  static void edit(EditType type, Widget child) {
    // Feedback
    HapticFeedback.heavyImpact();
    // Create Overlay
    var editOverlay = _SonrFixedOverlayEntry(SonrOffset.Top, Duration(milliseconds: 300), true, child, disableAnimation: true);

    // Add Overlay to List
    _controller.currentOverlay(editOverlay);
    _controller.overlays.add(editOverlay);
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
      Offset entryLocation = SonrOffset.Top,
      Duration entryDuration = const Duration(milliseconds: 300)}) {
    // Create Future Completer
    var completer = new Completer<bool>();

    // Create Overlay
    var questionOverlay = _SonrFixedOverlayEntry(
        entryLocation,
        entryDuration,
        barrierDismissible,
        QuestionOverlayView(
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
  static Future<bool> alert(
      {@required String title,
      @required String description,
      String buttonText = "Okay",
      bool barrierDismissible: true,
      bool closeOnResponse = true,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
      Offset entryLocation = SonrOffset.Top,
      Duration entryDuration = const Duration(milliseconds: 300)}) {
    // Create Future Completer
    var completer = new Completer();

    // Create Overlay
    var alertOverlay = _SonrFixedOverlayEntry(
        entryLocation,
        entryDuration,
        barrierDismissible,
        AlertOverlayView(
          count,
          title,
          description,
          buttonText,
          closeOnResponse,
          () {
            completer.complete();
          },
        ));

    // Add Overlay to List
    _controller.currentOverlay(alertOverlay);
    _controller.overlays.add(alertOverlay);
    return completer.future;
  }

  // ^ Method Finds Overlay Controller and Prompts Invite ^ //
  static void invite(AuthInvite invite,
      {bool barrierDismissible: false,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
      Duration entryDuration = const Duration(milliseconds: 350)}) {
    if (!isOpen) {
      // Create Overlay
      var cardOverlay = _SonrFixedOverlayEntry(
        SonrOffset.fromDegrees(invite.from.position.facingAntipodal),
        entryDuration,
        barrierDismissible,
        InviteReplyOverlayView(count, false, invite: invite),
        backgroundColor: Colors.black54,
      );

      // Add Overlay to List
      _controller.currentOverlay(cardOverlay);
      _controller.overlays.add(cardOverlay);
    }
  }

  // ^ Method Finds Overlay Controller to Show Reply ^ //
  static void reply(AuthReply reply,
      {bool barrierDismissible: false,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
      Duration entryDuration = const Duration(milliseconds: 350)}) {
    if (!isOpen) {
      // Create Overlay
      var cardOverlay = _SonrFixedOverlayEntry(
          SonrOffset.fromDegrees(reply.from.position.facingAntipodal),
          entryDuration,
          barrierDismissible,
          InviteReplyOverlayView(
            count,
            true,
            reply: reply,
          ));

      // Add Overlay to List
      _controller.currentOverlay(cardOverlay);
      _controller.overlays.add(cardOverlay);
    }
  }

  // ^ Method Pops Current Overlay ^ //
  static void back() {
    if (isOpen) {
      // Pop Current Overlay
      if (_controller.currentOverlay.value != null) {
        _controller.currentOverlay.value.dismiss();
      }

      // Refresh List
      _controller.overlays.removeLast();
      _controller.overlays.refresh();
    }
  }

  // ^ Method Finds Overlay Controller and Prompts Alert ^ //
  static void closeAt(int index) {
    if (isOpen && index >= 0) {
      _controller.overlays[index].dismiss();
      _controller.overlays.removeAt(index);

      // Refresh List
      _controller.currentOverlay(_controller.overlays[count - 1]);
      _controller.overlays.refresh();
    }
  }

  // ^ Method Finds Overlay Controller and Prompts Alert ^ //
  static void closeAll() {
    if (isOpen) {
      // Iterate through Overlays
      _controller.overlays.forEach((overlay) {
        overlay.dismiss();
      });

      // Clear List
      _controller.overlays.clear();

      // Refresh List
      _controller.overlays.refresh();
    }
  }
}

// ^ Class Presents Overlay Widget Entry on Context ** //
class _SonrFixedOverlayEntry {
  // Properties
  final Offset entryLocation;
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

  // ^ Constructer ** //
  _SonrFixedOverlayEntry(this.entryLocation, this.entryDuration, this.barrierDismissible, this.overlayWidget,
      {this.blur = 5.0, this.backgroundColor, this.mainAxisAlignment = MainAxisAlignment.center, this.disableAnimation = false}) {
    dismiss = () {
      overlayBackground.remove();
      overlay.remove();
    };
    overlayBackground = OverlayEntry(builder: (context) {
      return Positioned.fill(
        child: Container(
          color: backgroundColor ?? Colors.transparent,
          child: GestureDetector(
            onTap: () => barrierDismissible ? SonrOverlay.back() : () {},
          ),
        ),
      );
    });
    overlay = OverlayEntry(builder: (context) {
      return BaseOverlayView(
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
