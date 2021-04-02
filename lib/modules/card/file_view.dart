import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'card_controller.dart';

class FileCard extends GetWidget<TransferCardController> {
  // References
  final CardType type;
  final AuthInvite invite;
  final TransferCard card;
  final bool isNewItem;

  // ** Factory -> Invite Dialog View ** //
  factory FileCard.invite(AuthInvite invite) {
    return FileCard(CardType.Invite, invite: invite, card: invite.card);
  }

  // ** Factory -> Grid Item View ** //
  factory FileCard.item(TransferCard card, {bool isNewItem = false}) {
    return FileCard(CardType.GridItem, card: card, isNewItem: isNewItem);
  }

  // ** Constructer ** //
  const FileCard(this.type, {Key key, this.invite, this.card, this.isNewItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CardType.Invite:
        return _FileInviteView(card, controller, invite);
        break;
      case CardType.GridItem:
        return _FileItemView(card, controller);
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
                          color: SonrColor.Black.withOpacity(0.5),
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
                SonrText.gradient(card.payload.toString().capitalizeFirst, FlutterGradientNames.plumBath, size: 22),
                SonrText.normal("   ${card.properties.size.sizeText()}", size: 18)
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
                child: RiveContainer(type: RiveBoard.Documents, width: Get.width - 150, height: Get.height / 3)),
          ),
          Divider(),
          Padding(padding: EdgeInsets.all(4)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorButton.neutral(onPressed: () => controller.declineInvite(), text: "Decline"),
              Padding(padding: EdgeInsets.all(8)),
              ColorButton.primary(
                onPressed: () => controller.acceptTransfer(card),
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
class _FileItemView extends StatelessWidget {
  final TransferCard card;
  final TransferCardController controller;

  _FileItemView(this.card, this.controller);
  @override
  Widget build(BuildContext context) {
    return Card(
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        elevation: 2,
        child: Container(
          height: 420,
          width: Get.width - 64,
          child: GestureDetector(
            onTap: () {
              OpenFile.open(card.metadata.path);
            },
            child: Neumorphic(
              style: SonrStyle.normal,
              margin: EdgeInsets.all(4),
              child: Hero(
                tag: card.id,
                child: Container(
                  height: 75,
                  child: Stack(
                    children: <Widget>[
                      // Time Stamp
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Neumorphic(
                            style: SonrStyle.timeStampDark,
                            child: SonrText.date(DateTime.fromMillisecondsSinceEpoch(card.received * 1000), color: Colors.white),
                            padding: EdgeInsets.all(10),
                          ),
                        ),
                      ),

                      // File Icon
                      Align(
                          alignment: Alignment.center,
                          child: Neumorphic(
                              padding: EdgeInsets.all(20),
                              style: SonrStyle.indented,
                              child: Container(child: card.payload.icon(IconType.NeumorphicGradient, size: (Get.height / 4))))),

                      // Info Button
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ShapeButton.circle(
                              icon: SonrIcon.info,
                              onPressed: () => controller.showCardInfo(_FileCardInfo(card)),
                              shadowLightColor: Colors.black38,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
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
    var payload = card.payloadString;
    var size = card.metaSizeString;

    // Build Overlay View
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Neumorphic(
          margin: EdgeInsets.only(left: 6, right: 6),
          style: SonrStyle.overlay,
          padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // File Type
            SonrText.header("$payload From"),

            // Owner
            Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              card.platform.icon(IconType.Normal, color: Colors.grey[600], size: 18),
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

            Padding(padding: EdgeInsets.all(4)),
            Divider(),

            // Save File to Device
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ShapeButton.rectangle(
                isDisabled: true,
                onPressed: () {
                  // Prompt Question
                  SonrOverlay.question(
                          entryLocation: SonrOffset.Bottom,
                          title: "Delete",
                          description: "Are you sure you want to delete this Card?",
                          acceptTitle: "Continue",
                          declineTitle: "Cancel")
                      .then((result) {
                    // Handle Response
                    if (result) {
                      Get.find<SQLService>().deleteCard(card.id);
                      SonrSnack.success("Deleted File from Sonr.");
                      SonrOverlay.closeAll();
                    } else {
                      SonrOverlay.closeAll();
                    }
                  });
                },
                text: SonrText.medium("Delete"),
                icon: SonrIcon.normal(Icons.delete_forever_rounded, size: 18),
              ),
              ShapeButton.rectangle(
                onPressed: () {},
                text: SonrText.medium("Save"),
                icon: SonrIcon.normal(Icons.download_rounded, size: 18, color: UserService.isDarkMode.value ? Colors.white : SonrColor.Black),
              ),
            ]),
          ]),
        ));
  }
}
