import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'card_controller.dart';

class MediaCard extends GetWidget<TransferCardController> {
  // References
  final CardType type;
  final AuthInvite invite;
  final TransferCard card;
  final bool isNewItem;

  // ** Factory -> Invite Dialog View ** //
  factory MediaCard.invite(AuthInvite invite) {
    return MediaCard(CardType.Invite, invite: invite, card: invite.card);
  }

  // ** Factory -> Grid Item View ** //
  factory MediaCard.item(TransferCard card, {bool isNewItem = false}) {
    return MediaCard(CardType.GridItem, card: card, isNewItem: isNewItem);
  }

  // ** Constructer ** //
  const MediaCard(this.type, {Key key, this.invite, this.card, this.isNewItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CardType.Invite:
        return _MediaInviteView(card, controller, invite);
        break;
      case CardType.GridItem:
        return _MediaItemView(card, controller);
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
    return Container(
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
                      color: SonrColor.black.withOpacity(0.5),
                    ),
            ),

            // From Information
            Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              invite.from.profile.hasLastName()
                  ? SonrText.gradient(invite.from.profile.firstName + " " + invite.from.profile.lastName, FlutterGradientNames.premiumDark, size: 32)
                  : SonrText.gradient(invite.from.profile.firstName, FlutterGradientNames.premiumDark, size: 32),
              Row(children: [
                SonrText.gradient(card.properties.mime.type.toString().capitalizeFirst, FlutterGradientNames.plumBath, size: 22),
                SonrText.normal("   ${card.inviteSizeString}", size: 18)
              ]),
            ]),
          ]),
          Divider(),
          Container(
            width: card.preview.isNotEmpty ? Get.width - 50 : Get.width - 150,
            height: card.preview.isNotEmpty ? Get.height / 3 : Get.height / 5,
            child: card.preview.isNotEmpty ? SonrIcon.withPreview(card) : SonrIcon.withMime(card.properties.mime, size: 60),
          ),
          Divider(),
          Padding(padding: EdgeInsets.all(4)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            // Decline Button
            TextButton(
                onPressed: () => controller.declineInvite(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SonrText.semibold(invite.isRemote ? "Cancel" : "Decline", color: Colors.red[600], size: 18),
                )),
            // Accept Button
            Container(
              width: Get.width / 3,
              height: 50,
              child: SonrButton.stadium(
                onPressed: () => controller.acceptTransfer(card),
                icon: SonrIcon.gradient(Icons.check, FlutterGradientNames.newLife, size: 28),
                text: SonrText.semibold(invite.isRemote ? "Continue" : "Accept", size: 18, color: SonrColor.black.withOpacity(0.85)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

// ^ TransferCard Media Item Details ^ //
class _MediaItemView extends StatelessWidget {
  final TransferCard card;
  final TransferCardController controller;

  _MediaItemView(this.card, this.controller);
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        height: Get.height,
        child: GestureDetector(
          onTap: () {
            // Push to Page
            Get.to(_MediaCardExpanded(card), transition: Transition.fadeIn);
          },
          child: Neumorphic(
            style: SonrStyle.normal,
            margin: EdgeInsets.all(4),
            child: Hero(
              tag: card.id,
              child: Container(
                height: 75,
                decoration: card.metadata.mime.type == MIME_Type.image
                    ? BoxDecoration(
                        image: DecorationImage(
                        colorFilter: ColorFilter.mode(Colors.black12, BlendMode.luminosity),
                        fit: BoxFit.cover,
                        image: MemoryImage(card.metadata.thumbnail),
                      ))
                    : null,
                child: Stack(
                  children: <Widget>[
                    // Display Mime Type if Not Image
                    card.metadata.mime.type != MIME_Type.image
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
                                    child: SonrIcon.withMime(card.metadata.mime, size: 60)),
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
                          style: card.metadata.mime.type == MIME_Type.image ? SonrStyle.timeStamp : SonrStyle.timeStampDark,
                          child: SonrText.date(DateTime.fromMillisecondsSinceEpoch(card.received * 1000),
                              color: card.metadata.mime.type == MIME_Type.image ? SonrColor.black : SonrColor.currentNeumorphic),
                          padding: EdgeInsets.all(10),
                        ),
                      ),
                    ),

                    // Info Button
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SonrButton.circle(
                            color: UserService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
                            icon: SonrIcon.info,
                            onPressed: () => controller.showCardInfo(_MediaCardInfo(card)),
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
}

// ^ Widget for Expanded Media View
class _MediaCardExpanded extends StatelessWidget {
  final TransferCard card;
  const _MediaCardExpanded(this.card);
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
            tag: card.id,
            child: Material(
              color: Colors.transparent,
              child: PhotoView(imageProvider: MemoryImage(card.metadata.thumbnail)),
            ),
          ),
        ),
      ),
    );
  }
}

// ^ Overlay View for Media Info
class _MediaCardInfo extends StatelessWidget {
  final TransferCard card;
  _MediaCardInfo(this.card);

  @override
  Widget build(BuildContext context) {
    // Extract Data
    var metadata = card.metadata;
    var mimeType = card.metaMimeString;
    var size = card.metaSizeString;
    var hasExported = card.hasExportedString;

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
                children: [card.ownerPlatformIcon, card.ownerNameText]),

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
              SonrText.bold("Saved to Gallery ", size: 16),
              Spacer(),
              SonrText.medium("$hasExported", size: 16),
            ]),

            Padding(padding: EdgeInsets.all(4)),
            Divider(),

            // Save File to Device
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SonrButton.flat(
                onPressed: () async {
                  if (card.hasExported) {
                    Get.find<SQLService>().deleteCard(card.id);
                    SonrSnack.success("Deleted $mimeType from Sonr, it's still available in your gallery.");
                    SonrOverlay.back();
                  } else {
                    // Prompt Question
                    SonrOverlay.question(
                            entryLocation: SonrOffset.Bottom,
                            title: "Delete",
                            description: "Are you sure you want to delete this Card, it has not saved to your gallery yet.",
                            acceptTitle: "Continue",
                            declineTitle: "Cancel")
                        .then((result) {
                      // Handle Response
                      if (result) {
                        Get.find<SQLService>().deleteCard(card.id);
                        SonrSnack.success("Deleted $mimeType from Sonr.");
                        SonrOverlay.closeAll();
                      } else {
                        SonrOverlay.closeAll();
                      }
                    });
                  }
                },
                text: SonrText.medium("Delete", color: SonrColor.red),
                icon: SonrIcon.normal(Icons.delete_forever_rounded, size: 18),
              ),
              SonrButton.rectangle(
                onPressed: () {},
                text: SonrText.medium("Save"),
                icon: SonrIcon.normal(Icons.download_rounded, size: 18, color: UserService.isDarkMode.value ? Colors.white : SonrColor.black),
              ),
            ]),
          ]),
        ));
  }
}
