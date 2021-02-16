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
  factory SonrOverlay.fromMetaCardInfo({@required BuildContext context, @required TransferCard card}) {
    // Extract Data
    var metadata = card.metadata;
    var mimeType = metadata.mime.type.toString().capitalizeFirst;
    var size = SonrText.convertSizeToText(metadata.size);
    var hasExported = SonrText.convertBoolToText(card.hasExported);

    // Build Overlay View
    return SonrOverlay(
      context: context,
      overlayWidget: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Neumorphic(
          margin: EdgeInsets.only(left: 6, right: 6),
          style: SonrStyle.overlay,
          padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // File Type
            SonrText.header("$mimeType From"),

            // Owner
            Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              SonrIcon.platform(IconType.Normal, card.platform, color: Colors.grey[600], size: 18),
              SonrText.bold(" ${card.firstName} ${card.lastName}", size: 16, color: Colors.grey[600])
            ]),

            Divider(),
            Padding(padding: EdgeInsets.all(4)),

            // File Name
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SonrText.bold("Name ", size: 16),
              Spacer(),
              Container(
                alignment: Alignment.centerRight,
                child: SonrText.normal("${metadata.name}", size: 16),
                width: Get.width - 220,
                height: 22,
              ),
            ]),

            // File Size
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SonrText.bold("Size ", size: 16),
              Spacer(),
              SonrText.normal("$size", size: 16),
            ]),

            // File Mime Value
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SonrText.bold("Kind ", size: 16),
              Spacer(),
              SonrText.normal("${metadata.mime.value}", size: 16),
            ]),

            // File Exported
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SonrText.bold("Saved to Gallery ", size: 16),
              Spacer(),
              SonrText.normal("$hasExported", size: 16),
            ]),

            Padding(padding: EdgeInsets.all(4)),
            Divider(),

            // Save File to Device
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SonrButton.rectangle(
                isDisabled: true,
                onPressed: () {},
                text: SonrText.normal("Delete"),
                icon: SonrIcon.normal(Icons.delete_forever_rounded, size: 18),
              ),
              SonrButton.rectangle(
                onPressed: () {},
                text: SonrText.normal("Save"),
                icon: SonrIcon.normal(Icons.download_rounded, size: 18, color: Colors.black),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

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
