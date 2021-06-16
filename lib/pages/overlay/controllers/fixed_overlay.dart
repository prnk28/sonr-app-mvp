import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/style.dart';
import '../overlay.dart';

/// @ Class Controls Active Overlays ** //
class SonrOverlay extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<SonrOverlay>();
  static SonrOverlay get to => Get.find<SonrOverlay>();

  // Fixed Properties
  final overlays = <_SonrFixedOverlayEntry>[].obs;
  final currentOverlay = Rx<_SonrFixedOverlayEntry?>(null);

  // References
  static bool get isOpen => Get.find<SonrOverlay>().overlays.length > 0;
  static bool get isNotOpen => Get.find<SonrOverlay>().overlays.length == 0;
  static int get count => Get.find<SonrOverlay>().overlays.length;
  static SonrOverlay get _controller => Get.find<SonrOverlay>();

  /// @ Initialize Service Method
  Future<SonrOverlay> init() async {
    return this;
  }

  /// @ Method Finds Overlay Controller and Opens View
  static int show(Widget view,
      {bool barrierDismissible = true,
      Duration entryDuration = const Duration(milliseconds: 300),
      bool disableAnimation = false,
      Color backgroundColor = Colors.black54,
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

  /// @ Method Finds Overlay Controller and Prompts Alert
  static void closeAt(int index) {
    if (isOpen && index >= 0) {
      _controller.overlays[index].dismiss();
      _controller.overlays.removeAt(index);

      // Refresh List
      _controller.currentOverlay(_controller.overlays[count - 1]);
      _controller.overlays.refresh();
    }
  }

  /// @ Method Finds Overlay Controller and Prompts Alert
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

/// @ Class Presents Overlay Widget Entry on Context ** //
class _SonrFixedOverlayEntry {
  // Properties
  final Offset entryLocation;
  final Duration entryDuration;
  final Widget overlayWidget;
  final double blur;
  final Color? backgroundColor;
  final bool barrierDismissible;
  final bool disableAnimation;
  final MainAxisAlignment mainAxisAlignment;

  // References
  late Function dismiss;
  OverlayEntry? overlay, overlayBackground;

  /// @ Constructer ** //
  _SonrFixedOverlayEntry(this.entryLocation, this.entryDuration, this.barrierDismissible, this.overlayWidget,
      {this.blur = 5.0, this.backgroundColor, this.mainAxisAlignment = MainAxisAlignment.center, this.disableAnimation = false}) {
    dismiss = () {
      overlayBackground!.remove();
      overlay!.remove();
    };
    overlayBackground = OverlayEntry(builder: (context) {
      return Positioned.fill(
        child: BlurredBackground(
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
    Navigator.of(Get.context!).overlay!.insertAll([overlayBackground!, overlay!]);
  }
}
