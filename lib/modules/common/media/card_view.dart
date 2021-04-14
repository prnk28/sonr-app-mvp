import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'media.dart';

class MediaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

// ^ TransferCard Media Item Details ^ //
class MediaCardView extends StatefulWidget {
  final TransferCardItem card;

  MediaCardView(this.card);

  @override
  _MediaCardViewState createState() => _MediaCardViewState();
}

class _MediaCardViewState extends State<MediaCardView> {
  File mediaFile;
  bool hasLoaded = false;

  @override
  void initState() {
    loadMediaFile();
    super.initState();
  }

  loadMediaFile() async {
    mediaFile = await MediaService.loadFileFromMetadata(widget.card.metadata);
    setState(() {
      hasLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      width: Get.width - 64,
      decoration: Neumorphism.floating(),
      child: GestureDetector(
        onTap: () {
          // Push to Page
          Get.to(_MediaCardExpanded(widget.card, mediaFile), transition: Transition.fadeIn);
        },
        child: Hero(
          tag: widget.card.received,
          child: Container(
            height: 75,
            decoration: hasLoaded ? _buildImageDecoration() : BoxDecoration(),
            child: Stack(
              children: <Widget>[
                // Display Mime Type if Not Image
                _buildChildView(),

                // Time Stamp
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Neumorphic(
                      style: widget.card.metadata.mime.type == MIME_Type.image ? SonrStyle.timeStamp : SonrStyle.timeStampDark,
                      child: widget.card.dateText,
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                ),

                // Info Button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShapeButton.circle(
                        color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
                        icon: SonrIcon.info,
                        onPressed: () {
                          SonrOverlay.show(_MediaCardInfo(widget.card), disableAnimation: true, barrierDismissible: true);
                        },
                        shadowLightColor: Colors.black38,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // @ Build Card for Image Type
  Decoration _buildImageDecoration() {
    return widget.card.metadata.mime.type == MIME_Type.image
        ? BoxDecoration(
            image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.black12, BlendMode.luminosity),
            fit: BoxFit.cover,
            image: FileImage(mediaFile),
          ))
        : null;
  }

  // @ Build Card for Video Type
  Widget _buildChildView() {
    if (widget.card.metadata.mime.type == MIME_Type.video && mediaFile.path != null) {
      return BetterPlayer.file(mediaFile.path,
          betterPlayerConfiguration: BetterPlayerConfiguration(
            controlsConfiguration: BetterPlayerControlsConfiguration(),
            allowedScreenSleep: false,
            autoPlay: true,
            looping: true,
            aspectRatio: 9 / 16,
          ));
    } else if (widget.card.metadata.mime.type != MIME_Type.image) {
      return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: Get.width - 200,
            height: Get.height / 5,
            child: Neumorphic(
                padding: EdgeInsets.all(8),
                style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                  depth: -10,
                ),
                child: SonrIcon.withMime(widget.card.metadata.mime, size: 60)),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

// ^ Widget for Expanded Media View
class _MediaCardExpanded extends StatelessWidget {
  final TransferCardItem card;
  final File mediaFile;
  const _MediaCardExpanded(this.card, this.mediaFile);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: Get.back,
      child: SizedBox(
        width: Get.width,
        child: GestureDetector(
          onTap: () {
            Get.back(closeOverlays: true);
          },
          child: Hero(
            tag: card.received,
            child: Material(
              color: Colors.transparent,
              child: PhotoView(imageProvider: FileImage(mediaFile)),
            ),
          ),
        ),
      ),
    );
  }
}

// ^ Overlay View for Media Info
class _MediaCardInfo extends StatelessWidget {
  final TransferCardItem card;
  _MediaCardInfo(this.card);

  @override
  Widget build(BuildContext context) {
    // Extract Data
    var metadata = card.metadata;
    var mimeType = card.metadata.mime.asString;
    var size = card.metadata.sizeString;

    // Build Overlay View
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: GlassContainer(
          blurRadius: 26,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // File Type
            "$mimeType From".h3,

            // Owner
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [card.owner.platformIcon, card.owner.nameText]),

            Divider(),
            Padding(padding: EdgeInsets.all(4)),

            // File Name
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              "Name ".h6,
              Spacer(),
              Container(
                alignment: Alignment.centerRight,
                child: "${card.metadata.name}".p,
                width: Get.width - 220,
                height: 22,
              ),
            ]),

            // File Size
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              "Size ".h6,
              Spacer(),
              "$size".p,
            ]),

            // File Mime Value
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              "Kind ".h6,
              Spacer(),
              "${metadata.mime.value}".p,
            ]),

            // File Exported
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              "ID ".h6,
              Spacer(),
              "${metadata.id}".p,
            ]),

            Padding(padding: EdgeInsets.all(4)),
            Divider(),

            // Save File to Device
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ConfirmButton.delete(
                onConfirmed: () {
                  SonrOverlay.back();
                  CardService.deleteCard(card);
                },
                defaultIcon: SonrIcon.normal(Icons.delete_forever_rounded, size: 18),
                defaultText: "Delete",
                confirmIcon: SonrIcon.success,
                confirmText: "Confirm?",
              ),
            ]),
          ]),
        ));
  }
}
