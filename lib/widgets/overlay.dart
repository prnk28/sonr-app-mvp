import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart';

class SonrOverlay {
  // Properties
  final BuildContext context;
  final Widget overlayWidget;
  final Function builder;

  // References
  Function removeOverlay;
  OverlayEntry overlay, overlayBackground;

  // ^ Builds Overlay based on Metadata from Transfer Card ^ //
  factory SonrOverlay.fromMetaCard({@required BuildContext context, @required TransferCard card}) {
    // Extract Data
    var metadata = card.metadata;
    var mimeType = metadata.mime.type.toString().capitalizeFirst;
    var platform = card.platform.toString();
    var size = SonrText.convertSizeToText(metadata.size);
    var hasExported = SonrText.convertBoolToText(true);

    // Build Overlay View
    return SonrOverlay(
      context: context,
      overlayWidget: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Neumorphic(
          style: SonrStyle.overlay,
          padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 40),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // File Type
            SonrText.header("$mimeType From"),

            // Owner
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SonrText.bold("${card.firstName} ${card.lastName}", size: 16),
              SonrText.normal(" on $platform device"),
            ]),

            Divider(),

            // File Name
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SonrText.bold("Name ", size: 16),
              Spacer(),
              SonrText.normal("${metadata.name}", size: 16),
            ]),

            // File Size
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SonrText.bold("Size ", size: 16),
              Spacer(),
              SonrText.normal("$size", size: 16),
            ]),

            // File Exported
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SonrText.bold("Saved to Gallery ", size: 16),
              Spacer(),
              SonrText.normal("$hasExported", size: 16),
            ]),

            Divider(),

            // File Mime Value
            SonrText.normal("${metadata.mime.value}", size: 16),
          ]),
        ),
      ),
    );
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
              color: Colors.black.withOpacity(0.4),
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
