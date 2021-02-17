import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:sonr_app/modules/home/home_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

import 'card_controller.dart';

class FileCard extends GetWidget<TransferCardController> {
  // References
  final CardType type;
  final AuthInvite invite;
  final TransferCard card;

  // ** Factory -> Invite Dialog View ** //
  factory FileCard.invite(AuthInvite invite) {
    return FileCard(CardType.Invite, invite: invite, card: invite.card);
  }

  // ** Factory -> Grid Item View ** //
  factory FileCard.item(TransferCard card) {
    return FileCard(CardType.GridItem, card: card);
  }

  // ** Constructer ** //
  const FileCard(this.type, {Key key, this.invite, this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CardType.Invite:
        return _FileInviteView(card, controller, invite);
        break;
      case CardType.GridItem:
        return Neumorphic(
          style: SonrStyle.normal,
          margin: EdgeInsets.all(4),
          child: GestureDetector(
            onTap: () {
              // Close Share Menu
              Get.find<HomeController>().toggleShareExpand(options: ToggleForced(false));

              // Push to Page
              Get.to(_FileCardExpanded(card), transition: Transition.fadeIn);
            },
            child: Hero(
              tag: card.id,
              child: Container(
                height: 75,
                decoration: card.payload == Payload.MEDIA && card.metadata.mime.type == MIME_Type.image
                    ? BoxDecoration(
                        image: DecorationImage(
                        colorFilter: ColorFilter.mode(Colors.black26, BlendMode.luminosity),
                        fit: BoxFit.cover,
                        image: MemoryImage(card.metadata.thumbnail),
                      ))
                    : null,
                child: _FileItemView(card, controller),
              ),
            ),
          ),
        );
      default:
        return Container();
        break;
    }
  }
}

// ^ File Invite Builds from Invite Protobuf ^ //
class _FileInviteView extends StatelessWidget {
  final TransferCard card;
  final AuthInvite invite;
  final TransferCardController controller;
  _FileInviteView(this.card, this.controller, this.invite);

  @override
  Widget build(BuildContext context) {
    // Extract Data
    var size = SonrText.convertSizeToText(card.properties.size);

    // Build View
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        key: UniqueKey(),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [
            // Build Profile Pic
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 8),
                child: Neumorphic(
                  padding: EdgeInsets.all(4),
                  style: NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.circle(),
                    depth: -10,
                  ),
                  child: invite.from.profile.hasPicture()
                      ? Image.memory(Uint8List.fromList(invite.from.profile.picture))
                      : Icon(
                          Icons.insert_emoticon,
                          size: 100,
                          color: Colors.black.withOpacity(0.5),
                        ),
                ),
              ),
            ),
            // Create Spacing
            Padding(padding: EdgeInsets.all(6)),
            // From Information
            Column(children: [
              invite.from.profile.hasLastName()
                  ? SonrText.gradient(invite.from.profile.firstName + " " + invite.from.profile.lastName, FlutterGradientNames.premiumDark, size: 38)
                  : SonrText.gradient(invite.from.profile.firstName, FlutterGradientNames.premiumDark, size: 38),
              Row(children: [
                SonrText.gradient(card.properties.mime.type.toString().capitalizeFirst, FlutterGradientNames.plumBath, size: 22),
                SonrText.normal("   $size", size: 18)
              ]),
            ]),
          ]),
          Divider(),
          Container(
            width: Get.width - 50,
            height: Get.height / 3,
            child: Neumorphic(
                padding: EdgeInsets.all(8),
                style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                  depth: -10,
                ),
                child: SonrIcon.payload(
                  IconType.Gradient,
                  invite.payload,
                  gradient: SonrColor.payloadGradient(invite.payload),
                  size: (Get.height / 3),
                )),
          ),
          Padding(padding: EdgeInsets.all(4)),
          // Accept Button
          Container(
            width: Get.width / 2.75,
            child: SonrButton.stadium(
              onPressed: () {
                controller.acceptTransfer(card);
              },
              icon: SonrIcon.accept,
              text: SonrText.medium("Accept", size: 18, color: Colors.black.withOpacity(0.85)),
            ),
          ),
          Padding(padding: EdgeInsets.all(2)),
          // Decline Button
          TextButton(
              onPressed: () {
                controller.declineInvite();
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SonrText.medium("Decline", color: Colors.redAccent, size: 18),
              )),
        ],
      ),
    );
  }
}

// ^ TransferCard Media Item Details ^ //
class _FileItemView extends StatelessWidget {
  final TransferCard card;
  final TransferCardController controller;

  _FileItemView(this.card, this.controller);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Time Stamp
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Neumorphic(
              style: SonrStyle.timeStamp,
              child: SonrText.date(DateTime.fromMillisecondsSinceEpoch(card.received * 1000)),
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
                icon: SonrIcon.info,
                onPressed: () => controller.showCardInfo(_FileCardInfo(card)),
                shadowLightColor: Colors.black38,
              )),
        ),
      ],
    );
  }
}

// ^ Widget for Expanded File View
class _FileCardExpanded extends StatelessWidget {
  final TransferCard card;
  const _FileCardExpanded(this.card);
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
              child: Container(color: Colors.green),
            ),
          ),
        ),
      ),
    );
  }
}

// ^ Overlay View for File Info
class _FileCardInfo extends StatelessWidget {
  final TransferCard card;
  _FileCardInfo(this.card);

  @override
  Widget build(BuildContext context) {
    // Extract Data
    var metadata = card.metadata;
    var mimeType = metadata.mime.type.toString().capitalizeFirst;
    var size = SonrText.convertSizeToText(metadata.size);
    var hasExported = SonrText.convertBoolToText(card.hasExported);

    // Build Overlay View
    return Padding(
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
                child: SonrText.medium("${metadata.name}", size: 16),
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
              SonrButton.rectangle(
                isDisabled: true,
                onPressed: () {},
                text: SonrText.medium("Delete"),
                icon: SonrIcon.normal(Icons.delete_forever_rounded, size: 18),
              ),
              SonrButton.rectangle(
                onPressed: () {},
                text: SonrText.medium("Save"),
                icon: SonrIcon.normal(Icons.download_rounded, size: 18, color: Colors.black),
              ),
            ]),
          ]),
        ));
  }
}
