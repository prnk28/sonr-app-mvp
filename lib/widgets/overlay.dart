import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:get/get.dart';

class SonrOverlay {
  // Properties
  final BuildContext context;
  final Widget overlayWidget;
  final Duration duration;
  final Duration entryDuration;

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
  SonrOverlay(
      {@required this.context,
      @required this.overlayWidget,
      this.duration = const Duration(milliseconds: 250),
      this.entryDuration = const Duration(milliseconds: 350)}) {
    removeOverlay = () {
      overlayBackground.remove();
      overlay.remove();
    };
    overlayBackground = OverlayEntry(builder: (context) {
      return PlayAnimation<double>(
          tween: (0.0).tweenTo(5.0),
          duration: duration,
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
                        duration: duration,
                        builder: (context, child, value) {
                          return AnimatedOpacity(
                            opacity: value,
                            duration: duration,
                            child: Container(
                              color: SonrColor.overlayBackground,
                            ),
                          );
                        })),
              ),
            );
          });
    });
    overlay = OverlayEntry(builder: (context) {
      return _SonrOverlayView(
          duration: duration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [overlayWidget],
          ));
    });
    buildOverlay(context);
  }

  void buildOverlay(BuildContext context) {
    Overlay.of(context).insertAll([overlayBackground, overlay]);
  }
}

class _SonrOverlayView extends StatefulWidget {
  final Widget child;
  final Duration duration;
  const _SonrOverlayView({Key key, @required this.child, this.duration = const Duration(milliseconds: 1500)}) : super(key: key);
  @override
  _SonrOverlayViewState createState() => _SonrOverlayViewState();
}

class _SonrOverlayViewState extends State<_SonrOverlayView> with AnimationMixin {
  Animation<Offset> position;

  void initState() {
    position = Offset(0.0, -1.0).tweenTo(Offset.zero).animatedBy(controller);
    controller.duration = widget.duration;
    controller.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: position, child: widget.child);
  }

  void play() {
    controller.play();
  }
}
