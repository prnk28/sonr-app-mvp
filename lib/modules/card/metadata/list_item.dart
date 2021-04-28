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
        decoration: Neumorph.floating(),
        height: Height.ratio(0.15),
        child: Row(children: [
          _buildLeading(),
          _buildTitle(),
          Spacer(),
          PlainIconButton(
            onPressed: () {},
            icon: SonrIcons.MoreVertical.gradient(gradient: SonrGradient.Primary, size: 26),
          ),
        ]));
  }

  Widget _buildLeading() {
    // # Undefined Type
    if (item.payload == Payload.UNDEFINED) {
      return CircularProgressIndicator();
    }

    // # Check for Media File Type
    else if (item.payload == Payload.MEDIA) {
      // Image
      if (item.metadata.mime.type == MIME_Type.image) {
        return MetaImageBox(metadata: item.metadata, width: 72);
      }

      // Other Media (Video, Audio)
      else {
        return MetaIcon(iconSize: Height.ratio(0.125), metadata: item.metadata);
      }
    }

    // # Other File
    else {
      return MetaIcon(iconSize: Height.ratio(0.125), metadata: item.metadata);
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
              child: item.metadata.prettyName.h6,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: item.metadata.sizeString.p_Grey,
            )
          ]));
    } else {
      return Container(
          height: Height.ratio(0.15),
          padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: item.metadata.prettyName.h6,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: item.metadata.sizeString.p_Grey,
            )
          ]));
    }
  }
}
