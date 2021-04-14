import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/data/data.dart';
import 'file.dart';

// ^ TransferCard Media Item Details ^ //
class FileCardView extends StatelessWidget {
  final TransferCardItem card;

  FileCardView(this.card);
  @override
  Widget build(BuildContext context) {
    return Card(
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        elevation: 2,
        child: Container(
          height: 420,
          width: Get.width - 64,
          decoration: Neumorphism.floating(),
          margin: EdgeInsets.all(4),
          child: GestureDetector(
            onTap: () {
              OpenFile.open(card.metadata.path);
            },
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
                          child: card.dateText,
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
                            onPressed: () {
                              SonrOverlay.show(_FileCardInfo(card), disableAnimation: true, barrierDismissible: true);
                            },
                            shadowLightColor: Colors.black38,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

// ^ Overlay View for File Info
class _FileCardInfo extends StatelessWidget {
  final TransferCardItem card;
  _FileCardInfo(this.card);

  @override
  Widget build(BuildContext context) {
    // Extract Data
    var metadata = card.metadata;
    var payload = card.payload.asString;
    var size = card.metadata.sizeString;

    // Build Overlay View
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Neumorphic(
          margin: EdgeInsets.only(left: 6, right: 6),
          style: SonrStyle.overlay,
          padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // File Type
            "$payload From".h2,

            // Owner
            Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              card.owner.platform.icon(IconType.Normal, color: Colors.grey[600], size: 18),
              " ${card.owner.firstName} ${card.owner.lastName}".h6,
            ]),

            Divider(),
            Padding(padding: EdgeInsets.all(4)),

            // File Name
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              "Name ".h6,
              Spacer(),
              Container(
                alignment: Alignment.centerRight,
                child: "${metadata.name}".p,
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
                      CardService.deleteCard(card);
                      SonrSnack.success("Deleted File from Sonr.");
                      SonrOverlay.closeAll();
                    } else {
                      SonrOverlay.closeAll();
                    }
                  });
                },
                text: "Delete".h6,
                icon: SonrIcon.normal(Icons.delete_forever_rounded, size: 18),
              ),
              ShapeButton.rectangle(
                onPressed: () {},
                text: "Save".h6,
                icon: SonrIcon.normal(Icons.download_rounded, size: 18, color: UserService.isDarkMode ? Colors.white : SonrColor.Black),
              ),
            ]),
          ]),
        ));
  }
}

// ^ Payload Model Extensions ^ //
extension PayloadUtils on Payload {
  FlutterGradientNames get gradientName {
    return [
      FlutterGradientNames.itmeoBranding,
      FlutterGradientNames.norseBeauty,
      FlutterGradientNames.summerGames,
      FlutterGradientNames.healthyWater,
      FlutterGradientNames.frozenHeat,
      FlutterGradientNames.mindCrawl,
      FlutterGradientNames.seashore
    ].random();
  }

  String get asString {
    if (this == Payload.PDF) {
      return this.toString();
    }
    return this.toString().capitalizeFirst;
  }

  bool get isFile {
    return this != Payload.UNDEFINED && this != Payload.CONTACT && this != Payload.URL;
  }

  bool get isMedia {
    return this == Payload.MEDIA;
  }
}
