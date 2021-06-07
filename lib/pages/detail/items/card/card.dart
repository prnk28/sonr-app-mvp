import 'package:sonr_app/pages/detail/items/card/url/grid_item.dart';
import 'package:sonr_app/pages/detail/items/card/url/list_item.dart';
import 'package:sonr_app/style.dart';
import 'contact/card_item.dart';
import 'contact/grid_item.dart';
import 'contact/list_item.dart';
export 'contact/card_item.dart';
export 'contact/grid_item.dart';
export 'contact/list_item.dart';
export 'post/file_item.dart';
export 'url/card_item.dart';
export 'package:sonr_app/style.dart';

/// @ Card Element/View type Enums

enum PostItemType { CardItem, GridItem, ListItem }

//// @ TransferView: Builds View based on TransferItem Payload Type
class TransferCardPost extends StatelessWidget {
  /// TransferItem: SQL Reference to Protobuf
  final TransferCard card;

  /// Size/Shape of Transfer View
  final PostItemType type;
  const TransferCardPost(this.card, {Key? key, this.type = PostItemType.CardItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // @ Build Contact Card by Size
    if (card.payload == Payload.CONTACT) {
      switch (type) {
        case PostItemType.CardItem:
          return ContactCardItemView(card);
        case PostItemType.GridItem:
          return ContactGridItemView(card);
        case PostItemType.ListItem:
          return ContactListItemView(card);
      }
    }

    // @ Build URL Card by Size
    else if (card.payload == Payload.URL) {
      switch (type) {
        case PostItemType.CardItem:
          return URLCardItemView(card);
        case PostItemType.GridItem:
          return URLGridItemView(card);
        case PostItemType.ListItem:
          return URLListItemView(card);
      }
    }

    // @ Build Media/File Card by Size
    else {
      return PostFileItem(item: card);
    }
  }
}
