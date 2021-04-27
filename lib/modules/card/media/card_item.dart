import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'details_view.dart';

// ^ TransferCard Media Item Details ^ //
class MediaCardItemView extends StatefulWidget {
  final TransferCardItem card;

  MediaCardItemView(this.card);

  @override
  _MediaCardItemViewState createState() => _MediaCardItemViewState();
}

class _MediaCardItemViewState extends State<MediaCardItemView> {
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
      decoration: Neumorph.floating(),
      child: GestureDetector(
        onTap: () {
          // Push to Page
          Get.to(MediaDetailsView(widget.card, mediaFile), transition: Transition.fadeIn);
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
                  child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrColor.AccentNavy.withOpacity(0.75)),
                      child: widget.card.dateText),
                ),

                // Info Button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ActionButton(
                        icon: SonrIcons.About.grey,
                        onPressed: () {
                          SonrOverlay.show(_MediaInfoView(widget.card), disableAnimation: true, barrierDismissible: true);
                        },
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
                child: widget.card.metadata.mime.type.gradient(size: 60)),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}


// ^ Overlay View for Media Info
class _MediaInfoView extends StatelessWidget {
  final TransferCardItem card;
  _MediaInfoView(this.card);

  @override
  Widget build(BuildContext context) {
    // Extract Data
    var metadata = card.metadata;
    var mimeType = card.metadata.mime.asString;
    var size = card.metadata.sizeString;

    // Build Overlay View
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: Neumorph.floating(),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // File Type
            "$mimeType From".h3,

            // Owner
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [card.owner.platform.gradient(), card.owner.nameText]),

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
                defaultIcon: SonrIcons.Trash,
                defaultText: "Delete",
                confirmIcon: SonrIcons.Check,
                confirmText: "Confirm?",
              ),
            ]),
          ]),
        ));
  }
}
