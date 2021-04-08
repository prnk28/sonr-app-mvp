
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/data/data.dart';

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
                            child: SonrText.date(card.received, color: Colors.white),
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
            SonrText.header("$payload From"),

            // Owner
            Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              card.owner.platform.icon(IconType.Normal, color: Colors.grey[600], size: 18),
              SonrText.bold(" ${card.owner.firstName} ${card.owner.lastName}", size: 16, color: Colors.grey[600])
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
                      CardService.deleteCard(card);
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
                icon: SonrIcon.normal(Icons.download_rounded, size: 18, color: UserService.isDarkMode ? Colors.white : SonrColor.Black),
              ),
            ]),
          ]),
        ));
  }
}
