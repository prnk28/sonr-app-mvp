import 'package:sonr_app/modules/card/url/grid_item.dart';
import 'package:sonr_app/modules/card/url/list_item.dart';
import 'contact/card_item.dart';
import 'contact/grid_item.dart';
import 'contact/list_item.dart';
import 'file/card_item.dart';
import 'file/grid_item.dart';
import 'file/list_item.dart';
import 'media/card_item.dart';
import 'media/grid_item.dart';
import 'media/list_item.dart';
import 'url/card_item.dart';
import 'package:sonr_app/theme/theme.dart';

enum TransferItemViewType { CardItem, GridItem, ListItem }

/// ^ TransferCardView: Builds View based on TransferCardItem Payload Type ^
class TransferItem extends StatelessWidget {
  /// TransferCardItem: SQL Reference to Protobuf
  final TransferCardItem item;

  /// Size/Shape of TransferCard View
  final TransferItemViewType type;
  const TransferItem(this.item, {Key key, this.type = TransferItemViewType.CardItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // @ Build Media Card by Size
    if (item.payload == Payload.MEDIA) {
      switch (type) {
        case TransferItemViewType.CardItem:
          return MediaCardItemView(item);
        case TransferItemViewType.GridItem:
          return MediaGridItemView(item);
        case TransferItemViewType.ListItem:
          return MediaListItemView(item);
        default:
          return Container();
      }
    }

    // @ Build Contact Card by Size
    else if (item.payload == Payload.CONTACT) {
      switch (type) {
        case TransferItemViewType.CardItem:
          return ContactCardItemView(item);
        case TransferItemViewType.GridItem:
          return ContactGridItemView(item);
        case TransferItemViewType.ListItem:
          return ContactListItemView(item);
        default:
          return Container();
      }
    }

    // @ Build URL Card by Size
    else if (item.payload == Payload.URL) {
      switch (type) {
        case TransferItemViewType.CardItem:
          return URLCardItemView(item);
        case TransferItemViewType.GridItem:
          return URLGridItemView(item);
        case TransferItemViewType.ListItem:
          return URLListItemView(item);
        default:
          return Container();
      }
    }

    // @ Build File Card by Size
    else {
      switch (type) {
        case TransferItemViewType.CardItem:
          return FileCardItemView(item);
        case TransferItemViewType.GridItem:
          return FileGridItemView(item);
        case TransferItemViewType.ListItem:
          return FileListItemView(item);
        default:
          return Container();
      }
    }
  }
}
