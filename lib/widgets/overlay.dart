import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:get/get.dart';

// ** Class Presents Overlay Widget Entry on Context ** //
class _SonrOverlayWidget {
  // Properties
  final BuildContext context;
  final Widget overlayWidget;
  final Duration duration;
  final Duration entryDuration;

  // References
  Function dismiss;
  OverlayEntry overlay, overlayBackground;

  // ** Constructer ** //
  _SonrOverlayWidget(
      {@required this.context,
      @required this.overlayWidget,
      this.duration = const Duration(milliseconds: 250),
      this.entryDuration = const Duration(milliseconds: 350)}) {
    dismiss = () {
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
                onTap: () => dismiss(),
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
      return _SonrBaseOverlayView(
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

// ** Class Builds Alert View Widget for Overlay ** //
class _SonrOverlayAlertView extends StatelessWidget {
  final int index; // Index of Overlay
  final String title;
  final String description;
  final String buttonText;

  // Constructer
  _SonrOverlayAlertView(this.index, this.title, this.description, this.buttonText);

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
                    onPressed: () => SonrOverlay.popAt(index),
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

// ** Class Builds Question View Widget for Overlay ** //
class _SonrOverlayQuestionView extends GetView<SonrOverlay> {
  final int index; // Index of Overlay
  final String title;
  final String description;
  final Function(bool) onDecision;
  final String acceptTitle;
  final String declineTitle;

  // Constructer
  _SonrOverlayQuestionView(this.index, this.title, this.description, this.onDecision, this.acceptTitle, this.declineTitle);

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

// ** Class Builds Base Animated Overlay View ** //
class _SonrBaseOverlayView extends StatefulWidget {
  final Widget child;
  final Duration duration;
  const _SonrBaseOverlayView({Key key, @required this.child, this.duration = const Duration(milliseconds: 1500)}) : super(key: key);
  @override
  _SonrBaseOverlayViewState createState() => _SonrBaseOverlayViewState();
}

class _SonrBaseOverlayViewState extends State<_SonrBaseOverlayView> with AnimationMixin {
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

// ** Class Controls Active Overlays ** //
class SonrOverlay extends GetxController {
  final overlays = <_SonrOverlayWidget>[].obs;
  final currentOverlay = Rx<_SonrOverlayWidget>();

  // References
  static bool get isOpen => Get.find<SonrOverlay>().overlays.length > 0;
  static int get count => Get.find<SonrOverlay>().overlays.length;

  // ^ Static Method Finds Overlay Controller and Opens View ^ //
  static open(BuildContext context, Widget view) {
    var overlay = _SonrOverlayWidget(context: context, overlayWidget: view);
    Get.find<SonrOverlay>().currentOverlay(overlay);
    Get.find<SonrOverlay>().overlays.add(overlay);
  }

  // ^ Static Method Finds Overlay Controller and Prompts Question ^ //
  static question(BuildContext context,
      {@required String title,
      @required String description,
      @required Function(bool) onDecision,
      String acceptTitle = "Yes!",
      String declineTitle = "No",
      bool closeOnResponse = false}) {
    // Set Current Overlay
    var questionOverlay = _SonrOverlayWidget(
        context: context,
        overlayWidget: _SonrOverlayQuestionView(
          count,
          title,
          description,
          onDecision,
          acceptTitle,
          declineTitle,
        ));

    // Add Overlay
    Get.find<SonrOverlay>().currentOverlay(questionOverlay);
    Get.find<SonrOverlay>().overlays.add(questionOverlay);
  }

  // ^ Static Method Finds Overlay Controller and Prompts Alert ^ //
  static alert(BuildContext context,
      {@required String title, @required String description, String buttonText = "Okay", bool closeOnResponse = false}) {
    // Set Current Overlay
    var alertOverlay = _SonrOverlayWidget(
        context: context,
        overlayWidget: _SonrOverlayAlertView(
          count,
          title,
          description,
          buttonText,
        ));

    // Add Overlay
    Get.find<SonrOverlay>().currentOverlay(alertOverlay);
    Get.find<SonrOverlay>().overlays.add(alertOverlay);
  }

  // ^ Static Method Pops Current Overlay ^ //
  static back() {
    if (isOpen) {
      // Pop Current Overlay
      if (Get.find<SonrOverlay>().currentOverlay.value != null) {
        Get.find<SonrOverlay>().currentOverlay.value.dismiss();
      }

      // Refresh List
      Get.find<SonrOverlay>().overlays.removeLast();
      Get.find<SonrOverlay>().overlays.refresh();
    } else {
      print("Overlay is not open");
    }
  }

  // ^ Static Method Finds Overlay Controller and Prompts Alert ^ //
  static pop({int backUntil = 1}) {
    if (isOpen) {
      // Validate PopCount is less than List Length
      if (backUntil > count) {
        backUntil = count;
      }

      // Reverse Iterate Count and Remove
      for (var i = 0; i <= count; i++) {
        Get.find<SonrOverlay>().overlays[i].dismiss();
        Get.find<SonrOverlay>().overlays.removeLast();
      }

      // Refresh List
      Get.find<SonrOverlay>().currentOverlay(Get.find<SonrOverlay>().overlays[count - 1]);
      Get.find<SonrOverlay>().overlays.refresh();
    } else {
      print("Overlay is not open");
    }
  }

  // ^ Static Method Finds Overlay Controller and Prompts Alert ^ //
  static popAt(int index) {
    if (isOpen) {
      // Validate PopCount is less than List Length
      if (index <= count - 1) {
        Get.find<SonrOverlay>().overlays[index].dismiss();
        Get.find<SonrOverlay>().overlays.removeAt(index);
      } else {
        print("Invalid Index");
      }

      // Refresh List
      Get.find<SonrOverlay>().currentOverlay(Get.find<SonrOverlay>().overlays[count - 1]);
      Get.find<SonrOverlay>().overlays.refresh();
    } else {
      print("Overlay is not open");
    }
  }

  // ^ Static Method Finds Overlay Controller and Prompts Alert ^ //
  static closeAll() {
    if (isOpen) {
      // Iterate through Overlays
      Get.find<SonrOverlay>().overlays.forEach((overlay) {
        overlay.dismiss();
      });

      // Clear List
      Get.find<SonrOverlay>().overlays.clear();
      Get.find<SonrOverlay>().currentOverlay(null);

      // Refresh List
      Get.find<SonrOverlay>().overlays.refresh();
    } else {
      print("Overlay is not open");
    }
  }
}
