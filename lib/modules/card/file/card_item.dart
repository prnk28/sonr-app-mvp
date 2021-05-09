import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'views.dart';

/// @ TransferCard Media Item Details
class MetaCardItemView extends StatelessWidget {
  final TransferCardItem card;

  MetaCardItemView(this.card);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      width: Get.width - 64,
      decoration: Neumorphic.floating(),
      child: Hero(
        tag: card.file!.single.path,
        child: MetaBox(
          metadata: card.file!.single,
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
                    child: ReceivedText.dateTime(received: card.received)),
              ),

              // Info Button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ActionButton(
                      icon: SonrIcons.About.grey,
                      onPressed: () {
                        SonrOverlay.show(
                            _MediaInfoView(card.file!, card.owner, onConfirmed: () {
                              SonrOverlay.back();
                              CardService.deleteCard(card);
                            }),
                            disableAnimation: true,
                            barrierDismissible: true);
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @ Build Card for Video Type
  Widget _buildChildView() {
    if (card.file!.single.mime.type == MIME_Type.VIDEO) {
      return MetaVideo(metadata: card.file!.single);
    } else if (card.file!.single.mime.type != MIME_Type.IMAGE) {
      return MetaIcon(metadata: card.file!.single, width: Get.width - 200, height: Get.height / 5);
    } else {
      return Container();
    }
  }
}

/// @ Overlay View for Media Info
class _MediaInfoView extends StatelessWidget {
  final SonrFile file;
  final Profile owner;
  final Function onConfirmed;
  _MediaInfoView(this.file, this.owner, {required this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: Neumorphic.floating(),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // File Type
            "${file.prettySize()} From".h3,

            // Owner
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [owner.platform.gradient(), owner.nameText]),

            Divider(),
            Padding(padding: EdgeInsets.all(4)),

            // File Name
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              "Name ".h6,
              Spacer(),
              Container(
                alignment: Alignment.centerRight,
                child: "${file.single.name}".p,
                width: Get.width - 220,
                height: 22,
              ),
            ]),

            // File Size
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              "Size ".h6,
              Spacer(),
              "${file.prettySize()}".p,
            ]),

            // File Mime Value
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              "Kind ".h6,
              Spacer(),
              "${file.single.mime.value}".p,
            ]),

            // File Exported
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              "ID ".h6,
              Spacer(),
              "${file.single.id}".p,
            ]),

            Padding(padding: EdgeInsets.all(4)),
            Divider(),

            // Save File to Device
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ConfirmButton.delete(
                onConfirmed: onConfirmed,
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
