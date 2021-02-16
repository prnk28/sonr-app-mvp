import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:get/get.dart';

class SonrOverlay {
  // Properties
  final BuildContext context;
  final Widget overlayWidget;
  final Function builder;

  // References
  Function removeOverlay;
  OverlayEntry overlay, overlayBackground;

  factory SonrOverlay.question({@required BuildContext context, @required String title, @required description, @required Function(bool) onDecision}) {
    return SonrOverlay(
        context: context,
        overlayWidget: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Neumorphic(
              margin: EdgeInsets.only(left: 6, right: 6),
              style: SonrStyle.overlay,
              padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 20),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                // @ Footer
                Divider(),
                SonrHeaderBar.closeAccept(
                  onAccept: () {
                    onDecision(true);
                  },
                  onCancel: () {
                    onDecision(false);
                    Get.back();
                  },
                ),
              ])),
        ));
  }

  // ** Constructer ** //
  SonrOverlay({@required this.context, this.overlayWidget, this.builder}) {
    assert((overlayWidget != null && builder == null) || (overlayWidget == null && builder != null));
    removeOverlay = () {
      overlayBackground.remove();
      overlay.remove();
    };
    overlayBackground = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: () => removeOverlay(),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(
              color: K_OVERLAY_COLOR,
            ),
          ),
        ),
      ),
    );
    if (overlayWidget != null)
      overlay = OverlayEntry(
        builder: (context) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [overlayWidget]),
      );
    else
      overlay = OverlayEntry(
        builder: (context) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [builder(removeOverlay)]),
      );
    buildOverlay(context);
  }

  void buildOverlay(BuildContext context) {
    Overlay.of(context).insertAll([overlayBackground, overlay]);
  }
}
