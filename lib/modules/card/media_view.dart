import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'card_controller.dart';

class MediaCard extends GetWidget<TransferCardController> {
  // References
  final CardType type;
  final AuthInvite invite;
  final TransferCard card;
  final TransferCardItem cardItem;

  // ** Factory -> Invite Dialog View ** //
  factory MediaCard.invite(AuthInvite invite) {
    return MediaCard(CardType.Invite, invite: invite, card: invite.card);
  }

  // ** Factory -> Grid Item View ** //
  factory MediaCard.item(TransferCardItem card) {
    return MediaCard(CardType.GridItem, cardItem: card);
  }

  // ** Constructer ** //
  const MediaCard(this.type, {Key key, this.invite, this.card, this.cardItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CardType.Invite:
        return _MediaInviteView(card, controller, invite);
        break;
      case CardType.GridItem:
        return _MediaItemView(cardItem, controller);
      default:
        return Container();
        break;
    }
  }
}

// ^ File Invite Builds from Invite Protobuf ^ //
class _MediaInviteView extends StatelessWidget {
  final TransferCard card;
  final AuthInvite invite;
  final TransferCardController controller;
  _MediaInviteView(this.card, this.controller, this.invite);

  @override
  Widget build(BuildContext context) {
    // Build View
    return Neumorphic(
      style: SonrStyle.normal,
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        key: UniqueKey(),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // @ Header
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // Build Profile Pic
            Container(
              child: invite.from.profile.hasPicture()
                  ? Image.memory(Uint8List.fromList(invite.from.profile.picture))
                  : Icon(
                      Icons.insert_emoticon,
                      size: 60,
                      color: SonrColor.Black.withOpacity(0.5),
                    ),
            ),

            // From Information
            Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              invite.from.profile.hasLastName()
                  ? SonrText.gradient(invite.from.profile.firstName + " " + invite.from.profile.lastName, FlutterGradientNames.premiumDark, size: 32)
                  : SonrText.gradient(invite.from.profile.firstName, FlutterGradientNames.premiumDark, size: 32),
              Row(children: [
                SonrText.gradient(card.metadata.mime.type.toString().capitalizeFirst, FlutterGradientNames.plumBath, size: 22),
                SonrText.normal("   ${card.inviteSizeString}", size: 18)
              ]),
            ]),
          ]),
          Divider(),
          Container(
            width: card.preview.isNotEmpty ? Get.width - 50 : Get.width - 150,
            height: card.preview.isNotEmpty ? Get.height / 3 : Get.height / 5,
            child: card.preview.isNotEmpty ? SonrIcon.withPreview(card) : SonrIcon.withMime(card.metadata.mime, size: 60),
          ),
          Divider(),
          Padding(padding: EdgeInsets.all(4)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorButton.neutral(onPressed: () => CardService.handleInviteResponse(false, invite, card), text: "Decline"),
              Padding(padding: EdgeInsets.all(8)),
              ColorButton.primary(
                onPressed: () => CardService.handleInviteResponse(true, invite, card),
                text: "Accept",
                gradient: SonrPalette.tertiary(),
                icon: SonrIcon.gradient(Icons.check, FlutterGradientNames.newLife, size: 28),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ^ TransferCard Media Item Details ^ //
class _MediaItemView extends StatefulWidget {
  final TransferCardItem card;
  final TransferCardController controller;

  _MediaItemView(this.card, this.controller);

  @override
  _MediaItemViewState createState() => _MediaItemViewState();
}

class _MediaItemViewState extends State<_MediaItemView> {
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
    print(widget.card.toString());
    return Card(
      shadowColor: Colors.transparent,
      color: Colors.transparent,
      elevation: 2,
      child: Container(
        height: 420,
        width: Get.width - 64,
        child: GestureDetector(
          onTap: () {
            // Push to Page
            Get.to(_MediaCardExpanded(widget.card, mediaFile), transition: Transition.fadeIn);
          },
          child: Neumorphic(
            style: SonrStyle.normal,
            margin: EdgeInsets.all(4),
            child: Hero(
              tag: widget.card.received,
              child: Container(
                height: 75,
                decoration: hasLoaded ? _buildImageDecoration() : BoxDecoration(),
                child: Stack(
                  children: <Widget>[
                    // Display Mime Type if Not Image
                    widget.card.metadata.mime.type != MIME_Type.image
                        ? Align(
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
                          )
                        : Container(),

                    // Time Stamp
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Neumorphic(
                          style: widget.card.metadata.mime.type == MIME_Type.image ? SonrStyle.timeStamp : SonrStyle.timeStampDark,
                          child: SonrText.date(widget.card.received,
                              color: widget.card.metadata.mime.type == MIME_Type.image ? SonrColor.Black : SonrColor.currentNeumorphic),
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
                            onPressed: () => widget.controller.showCardInfo(_MediaCardInfo(widget.card)),
                            shadowLightColor: Colors.black38,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

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
            SonrText.header("$mimeType From"),

            // Owner
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [card.owner.platformIcon, card.owner.nameText]),

            Divider(),
            Padding(padding: EdgeInsets.all(4)),

            // File Name
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SonrText.bold("Name ", size: 16),
              Spacer(),
              Container(
                alignment: Alignment.centerRight,
                child: SonrText.medium("${card.metadata.name}", size: 16),
                width: Get.width - 220,
                height: 22,
              ),
            ]),

            // File Size
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SonrText.bold("Size ", size: 16),
              Spacer(),
              SonrText.medium("$size", size: 16),
            ]),

            // File Mime Value
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SonrText.bold("Kind ", size: 16),
              Spacer(),
              SonrText.medium("${metadata.mime.value}", size: 16),
            ]),

            // File Exported
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SonrText.bold("ID ", size: 16),
              Spacer(),
              SonrText.medium("${metadata.id}", size: 16),
            ]),

            Padding(padding: EdgeInsets.all(4)),
            Divider(),

            // Save File to Device
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ShapeButton.flat(
                onPressed: () async {
                  CardService.deleteCard(card);
                  SonrSnack.success("Deleted $mimeType from Sonr, it's still available in your gallery.");
                  SonrOverlay.back();
                },
                text: SonrText.medium("Delete", color: SonrPalette.Red),
                icon: SonrIcon.normal(Icons.delete_forever_rounded, size: 18),
              ),
              ShapeButton.rectangle(
                onPressed: () {},
                text: SonrText.medium("Save"),
                icon: SonrIcon.normal(Icons.download_rounded, size: 18, color: UserService.isDarkMode ? Colors.white : SonrColor.Black),
              ),
            ]),
          ]),
        ));
  }
}
