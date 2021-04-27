import 'package:sonr_app/modules/card/url/grid_item.dart';
import 'package:sonr_app/modules/card/url/list_item.dart';
import 'contact/card_item.dart';
import 'contact/details_view.dart';
import 'contact/grid_item.dart';
import 'contact/list_item.dart';
import 'file/card_item.dart';
import 'file/details_view.dart';
import 'file/grid_item.dart';
import 'file/list_item.dart';
import 'media/card_item.dart';
import 'media/grid_item.dart';
import 'media/list_item.dart';
import 'url/card_item.dart';
import 'package:sonr_app/theme/theme.dart';

enum TransferItemViewType { CardItem, GridItem, ListItem, Details }

/// ^ TransferCardView: Builds View based on TransferCardItem Payload Type ^
class TransferItem extends StatelessWidget {
  /// TransferCardItem: SQL Reference to Protobuf
  final TransferCardItem item;

  /// Size/Shape of TransferCard View
  final TransferItemViewType type;
  const TransferItem(this.item, {Key key, this.type = TransferItemViewType.CardItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Media Card
    if (item.payload == Payload.MEDIA) {
      return _buildMediaCard();
    }

    // Contact Card
    else if (item.payload == Payload.CONTACT) {
      return _buildContactCard();
    }

    // URL View
    else if (item.payload == Payload.URL) {
      return _buildURLCard();
    }

    // File Card
    else {
      return _buildFileCard();
    }
  }

  // @ Build Contact Card by Size
  Widget _buildContactCard() {
    switch (type) {
      case TransferItemViewType.CardItem:
        return ContactCardItemView(item);
        break;
      case TransferItemViewType.GridItem:
        return ContactGridItemView(item);
        break;
      case TransferItemViewType.ListItem:
        return ContactListItemView(item);
        break;
      case TransferItemViewType.Details:
        return ContactDetailsView(item);
        break;
    }
    return Container();
  }

  // @ Build File Card by Size
  Widget _buildFileCard() {
    switch (type) {
      case TransferItemViewType.CardItem:
        return FileCardItemView(item);
        break;
      case TransferItemViewType.GridItem:
        return FileGridItemView(item);
        break;
      case TransferItemViewType.ListItem:
        return FileListItemView(item);
        break;
      case TransferItemViewType.Details:
        return FileDetailsView(item);
        break;
    }
    return Container();
  }

  // @ Build Media Card by Size
  Widget _buildMediaCard() {
    switch (type) {
      case TransferItemViewType.CardItem:
        return MediaCardItemView(item);
        break;
      case TransferItemViewType.GridItem:
        return MediaGridItemView(item);
        break;
      case TransferItemViewType.ListItem:
        return MediaListItemView(item);
        break;
      default:
        return Container();
        break;
    }
  }

  // @ Build URL Card by Size
  Widget _buildURLCard() {
    switch (type) {
      case TransferItemViewType.CardItem:
        return URLCardItemView(item);
        break;
      case TransferItemViewType.GridItem:
        return URLGridItemView(item);
        break;
      case TransferItemViewType.ListItem:
        return URLListItemView(item);
        break;
      default:
        return Container();
        break;
    }
  }
}
