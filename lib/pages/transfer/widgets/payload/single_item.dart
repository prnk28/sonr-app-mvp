import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/pages/transfer/views/popup_view.dart';
import 'package:sonr_app/style.dart';
import 'thumbnail.dart';

class PayloadSingleItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final file = TransferController.invite.file;
    final invite = TransferController.invite;
    return Container(
        child: Obx(() => Row(children: [
              _buildLeading(invite),
              _buildTitle(invite),
              Container(
                padding: EdgeInsets.only(left: 24),
                alignment: Alignment.topRight,
                child: ActionButton(
                  onPressed: () {
                    AppRoute.popup(EditPayloadPopup(
                      index: 0,
                      item: file.single,
                    ));
                  },
                  iconData: SonrIcons.MoreVertical,
                ),
              ),
            ])));
  }

  Widget _buildLeading(InviteRequest invite) {
    // # Undefined Type
    if (invite.payload == Payload.NONE) {
      return HourglassIndicator();
    }

    // # Check for Media File Type
    else if (invite.payload == Payload.MEDIA) {
      return PayloadItemThumbnail();
    }

    // # Other Types
    else {
      return invite.payload.gradient(size: Height.ratio(0.125));
    }
  }

  Widget _buildTitle(InviteRequest invite) {
    if (invite.payload == Payload.CONTACT) {
      // Build Text View
      return Container(
          width: Width.ratio(0.5),
          height: Height.ratio(0.15),
          padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: [
                UserService.contact.value.firstName.paragraph(color: SonrTheme.itemColor),
                " ".paragraph(color: SonrTheme.itemColor),
                UserService.contact.value.lastName.light(color: SonrTheme.itemColor)
              ].row(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: "Contact Card".paragraph(),
            )
          ]));
    } else if (invite.payload == Payload.URL) {
      // Build Text View
      return Container(
          width: Width.ratio(0.5),
          height: Height.ratio(0.15),
          padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: invite.file.prettyName().paragraph(color: SonrTheme.itemColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: invite.file.prettySize().paragraph(color: Get.theme.hintColor),
            )
          ]));
    } else {
      // Build Text View
      return Container(
          width: Width.ratio(0.5),
          height: Height.ratio(0.15),
          padding: EdgeInsets.only(left: 16, right: 8, top: 0, bottom: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(padding: const EdgeInsets.only(top: 16.0), child: invite.file.prettyType().subheading(color: SonrTheme.itemColor)),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: invite.file.prettyName().light(color: Get.theme.hintColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: invite.file.prettySize().paragraph(color: Get.theme.hintColor),
            )
          ]));
    }
  }
}
