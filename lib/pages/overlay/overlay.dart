import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'fixed_overlay.dart';
import 'positioned_overlay.dart';
export 'fixed_overlay.dart';
export 'flat_overlay.dart';
export 'positioned_overlay.dart';
export 'progress_overlay.dart';

// ^ Class Builds Base Animated Overlay View ** //
class BaseOverlayView extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset entryLocation;
  final bool disableAnimation;
  const BaseOverlayView(this.child, this.duration, this.entryLocation, this.disableAnimation);
  @override
  _BaseOverlayViewState createState() => _BaseOverlayViewState();
}

class _BaseOverlayViewState extends State<BaseOverlayView> with TickerProviderStateMixin {
  Animation<Offset> position;

  void initState() {
    AnimationController controller = AnimationController(vsync: this, duration: widget.duration);
    position = widget.entryLocation.tweenTo(Offset.zero).animatedBy(controller);
    controller.forward();
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
}

// ^ Class Builds Alert View Widget for Overlay ** //
class AlertOverlayView extends StatelessWidget {
  final int index; // Index of Overlay
  final String title;
  final String description;
  final String buttonText;
  final bool closeOnResponse;
  final Function onPressed;

  // Constructer
  AlertOverlayView(this.index, this.title, this.description, this.buttonText, this.closeOnResponse, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Neumorph.floating(),
      // backendColor: Colors.transparent,
      margin: EdgeInsets.all(30),
      // borderRadius: BorderRadius.circular(20),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        title.h2,
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: description.p,
        ),
        Padding(padding: EdgeInsets.all(4)),
        Divider(),
        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          // Accept Button
          Container(
            width: Get.width / 3,
            child: ColorButton.primary(
              onPressed: () {
                onPressed();
                if (closeOnResponse) {
                  SonrOverlay.back();
                }
              },
              icon: SonrIcons.Check,
              text: buttonText,
            ),
          ),
        ]),
      ]),
    );
  }
}

// ^ Class Builds Dropdown View Widget for Positioned Overlay ** //
class DropdownOverlayView extends StatelessWidget {
  final int index; // Index of Overlay
  final List<SonrDropdownItem> items;
  final GlobalKey parentKey;
  final Function(int idx) onChanged;
  final double height;
  final double width;
  final EdgeInsets margin;

  // Constructer
  DropdownOverlayView(this.index, this.items, this.parentKey, this.onChanged, {this.height = 20, this.width = 20, this.margin});

  @override
  Widget build(BuildContext context) {
    RenderBox renderBox = parentKey.currentContext.findRenderObject();
    var size = renderBox.size;
    return Stack(children: [
      Container(
        padding: EdgeInsets.only(right: 45),
        alignment: Alignment.topRight,
        child: ClipPath(
          clipper: ArrowClipper(),
          child: Container(
            width: 17,
            height: 17,
            color: UserService.isDarkMode ? SonrColor.Black : SonrColor.White,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          height: (items.length * size.height) / 1.5 + height,
          width: size.width + width,
          child: Container(
            margin: margin ?? EdgeInsets.symmetric(horizontal: 6),
            decoration: Neumorph.floating(radius: 0),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      onChanged(index);
                      SonrPositionedOverlay.back();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Stack(children: [items[index]]),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      )
    ]);
  }
}

// ^ Class Builds Question View Widget for Overlay ** //
class QuestionOverlayView extends GetView<SonrOverlay> {
  final int index; // Index of Overlay
  final String title;
  final String description;
  final Function(bool) onDecision;
  final String acceptTitle;
  final String declineTitle;
  final bool closeOnResponse;

  // Constructer
  QuestionOverlayView(this.index, this.title, this.description, this.onDecision, this.acceptTitle, this.declineTitle, this.closeOnResponse);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Neumorph.floating(),
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: Get.height / 3 + 50,
      child: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          title.h4,
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: description.p_Grey,
          ),
          Padding(padding: EdgeInsets.all(4)),
          Divider(),
          Padding(padding: EdgeInsets.all(4)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            // Decline Button
            TextButton(
                onPressed: () {
                  onDecision(false);
                  if (closeOnResponse) {
                    SonrOverlay.back();
                  }
                },
                child: declineTitle.h6_Red),
            // Accept Button
            Container(
              width: Get.width / 2.5,
              height: 50,
              child: ColorButton.primary(
                onPressed: () {
                  onDecision(true);
                  if (closeOnResponse) {
                    SonrOverlay.back();
                  }
                },
                icon: SonrIcons.Check,
                text: acceptTitle,
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}