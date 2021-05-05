import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/theme/theme.dart';

import 'views.dart';

class MetaListItemView extends StatelessWidget {
  final TransferCardItem item;
  const MetaListItemView(this.item, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(4),
        decoration: Neumorphic.floating(),
        height: Height.ratio(0.15),
        child: Row(children: [
          _buildLeading(),
          _buildTitle(),
          Spacer(),
          PlainIconButton(
            onPressed: () {},
            icon: SonrIcons.MoreVertical.gradient(value: SonrGradient.Primary, size: 26),
          ),
        ]));
  }

  Widget _buildLeading() {
    // # Undefined Type
    if (item.mime == MIME_Type.OTHER) {
      return CircularProgressIndicator();
    }

    // # Check for Media File Type
    else if (item.file.isMedia) {
      // Image
      if (item.file.single.mime.type == MIME_Type.IMAGE) {
        return MetaImageBox(metadata: item.file.single, width: 72);
      }

      // Other Media (Video, Audio)
      else {
        return MetaIcon(iconSize: Height.ratio(0.125), metadata: item.file.single);
      }
    }

    // # Other File
    else {
      return MetaIcon(iconSize: Height.ratio(0.125), metadata: item.file.single);
    }
  }

  Widget _buildTitle() {
    if (item.payload == Payload.CONTACT) {
      // Build Text View
      return Container(
          height: Height.ratio(0.15),
          padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: [UserService.firstName.value.h6, " ".h6, UserService.lastName.value.l].row(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: "Contact Card".p_Grey,
            )
          ]));
    } else if (item.payload == Payload.URL) {
      // Build Text View
      return Container(
          height: Height.ratio(0.15),
          padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: item.file.prettyName().h6,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: item.file.sizeToString().p_Grey,
            )
          ]));
    } else {
      return Container(
          height: Height.ratio(0.15),
          padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: item.file.prettyName().h6,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: item.file.sizeToString().p_Grey,
            )
          ]));
    }
  }
}
