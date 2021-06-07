import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/style.dart';
import '../overlay.dart';

/// @ Class Controls Active Overlays ** //
class SonrPositionedOverlay extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<SonrPositionedOverlay>();
  static SonrPositionedOverlay get to => Get.find<SonrPositionedOverlay>();

  // Positioned Properties
  final overlays = <_SonrPositionedOverlayEntry>[].obs;
  final currentOverlay = Rx<_SonrPositionedOverlayEntry?>(null);

  // References
  static bool get isOpen => Get.find<SonrPositionedOverlay>().overlays.length == 0;
  static int get count => Get.find<SonrPositionedOverlay>().overlays.length;
  static SonrPositionedOverlay get _controller => Get.find<SonrPositionedOverlay>();

  Future<SonrPositionedOverlay> init() async {
    return this;
  }

  /// @ Opens View at Position with Size
  static void open(
    Widget view,
    Size size,
    Offset position, {
    bool barrierDismissible = true,
    Duration entryDuration = const Duration(milliseconds: 200),
    Offset entryLocation = SonrOffset.Top,
  }) {
    // Create Overlay
    var overlay = _SonrPositionedOverlayEntry(size, position, view, barrierDismissible);

    // Add Overlay to List
    _controller.currentOverlay(overlay);
    _controller.overlays.add(overlay);
  }

  static void dropdown(List<SonrDropdownItem> items, GlobalKey key, Function(int idx) onChanged,
      {Duration entryDuration = const Duration(milliseconds: 600),
      Offset entryLocation = SonrOffset.Top,
      double? height,
      double? width,
      EdgeInsets? margin}) {
    // Get Position
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var position = renderBox.localToGlobal(Offset.zero);

    // Create Overlay
    var overlay = _SonrPositionedOverlayEntry(
        size, position, DropdownOverlayView(count, items, key, onChanged, height: height, width: width, margin: margin), true);

    // Add Overlay to List
    _controller.currentOverlay(overlay);
    _controller.overlays.add(overlay);
  }

  /// @ Method Pops Current Overlay
  static void back() {
    if (isOpen) {
      // Pop Current Overlay
      if (_controller.currentOverlay.value != null) {
        _controller.currentOverlay.value!.dismiss();
      }

      // Refresh List
      _controller.overlays.removeLast();
      _controller.overlays.refresh();
    }
  }
}

/// @ Class Presents Positioned Overlay Widget Entry on Context ** //
class _SonrPositionedOverlayEntry {
  // Properties
  final Widget widget;
  final bool barrierDismissible;
  final Size size;
  final Offset position;

  // References
  late Function dismiss;
  OverlayEntry? overlay, overlayBackground;

  /// @ Constructer ** //
  _SonrPositionedOverlayEntry(this.size, this.position, this.widget, this.barrierDismissible) {
    dismiss = () {
      overlayBackground!.remove();
      overlay!.remove();
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
    Navigator.of(Get.context!).overlay!.insertAll([overlayBackground!, overlay!]);
  }
}
