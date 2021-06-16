import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sonr_app/style.dart';
import 'views/positioned_overlay.dart';
export 'controllers/fixed_overlay.dart';
export 'controllers/flat_overlay.dart';
export 'views/positioned_overlay.dart';

/// @ Class Builds Base Animated Overlay View ** //
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
  late Animation<Offset> position;
  late AnimationController controller;
  void initState() {
    controller = AnimationController(vsync: this, duration: widget.duration);
    position = widget.entryLocation.tweenTo(Offset.zero).animatedBy(controller);
    controller.forward();
    super.initState();
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: BlurredBackground(
          child: widget.disableAnimation
              ? widget.child
              : SlideTransition(
                  position: position,
                  child: widget.child,
                ),
        ));
  }
}

/// @ Class Builds Dropdown View Widget for Positioned Overlay ** //
class DropdownOverlayView extends StatelessWidget {
  final int index; // Index of Overlay
  final List<SonrDropdownItem> items;
  final GlobalKey parentKey;
  final Function(int idx) onChanged;
  final double? height;
  final double? width;
  final EdgeInsets? margin;

  // Constructer
  DropdownOverlayView(this.index, this.items, this.parentKey, this.onChanged, {this.height = 20, this.width = 20, this.margin});

  @override
  Widget build(BuildContext context) {
    RenderBox renderBox = parentKey.currentContext!.findRenderObject() as RenderBox;
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
          height: (items.length * size.height) / 1.5 + height!,
          width: size.width + width!,
          child: BoxContainer(
            margin: margin ?? EdgeInsets.symmetric(horizontal: 6),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      onChanged(index);
                      PosOverlay.back();
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
