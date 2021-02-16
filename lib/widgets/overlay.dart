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

  factory SonrOverlay.question(
      {@required BuildContext context, @required String title, @required String description, @required Function(bool) onDecision}) {
    return SonrOverlay(
        context: context,
        overlayWidget: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Neumorphic(
              margin: EdgeInsets.only(left: 6, right: 6),
              style: SonrStyle.overlay,
              padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 20),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SonrHeaderBar.closeAccept(
                  title: SonrText.header(title),
                  onAccept: () {
                    Get.back(closeOverlays: true);
                  },
                  onCancel: () {
                    onDecision(false);
                    Get.back(closeOverlays: true);
                  },
                ),
                Divider(),
                SonrText.description(description)
              ])),
        ));
  }

  factory SonrOverlay.alert({@required BuildContext context, @required String title, @required String description, String buttonText = "Okay"}) {
    return SonrOverlay(
        context: context,
        overlayWidget: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Neumorphic(
              margin: EdgeInsets.only(left: 6, right: 6),
              style: SonrStyle.overlay,
              padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 20),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SonrHeaderBar.title(
                  title: SonrText.header(title),
                ),
                Divider(),
                SonrText.description(description),
                SonrButton.stadium(
                    onPressed: () {
                      Get.back(closeOverlays: true);
                    },
                    text: SonrText.normal(buttonText))
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
    overlayBackground = OverlayEntry(builder: (context) {
      return PlayAnimation<double>(
          tween: (0.0).tweenTo(5.0),
          duration: 250.milliseconds,
          curve: Curves.easeIn,
          builder: (context, child, value) {
            return Positioned.fill(
              child: GestureDetector(
                onTap: () => removeOverlay(),
                child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: value,
                      sigmaY: value,
                    ),
                    child: PlayAnimation<double>(
                        curve: Curves.easeIn,
                        tween: (0.0).tweenTo(1.0),
                        duration: 250.milliseconds,
                        builder: (context, child, value) {
                          return AnimatedOpacity(
                            opacity: value,
                            duration: 250.milliseconds,
                            child: Container(
                              color: SonrColor.overlayBackground,
                            ),
                          );
                        })),
              ),
            );
          });
    });
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
