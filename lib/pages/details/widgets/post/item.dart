import 'package:sonr_app/pages/details/widgets/contact/grid_item.dart';
import 'package:sonr_app/pages/details/widgets/contact/list_item.dart';
import 'package:sonr_app/pages/details/widgets/url/card_item.dart';
import 'package:sonr_app/pages/details/widgets/url/list_item.dart';
import 'package:sonr_app/pages/details/widgets/post/file_item.dart';
import 'package:sonr_app/style.dart';

/// @ Card Element/View type Enums
enum PostDisplayType { CardItem, ListItem }

//// @ TransferView: Builds View based on TransferItem Payload Type
class PostItem extends StatelessWidget {
  /// TransferItem: SQL Reference to Protobuf
  final TransferCard item;

  /// Size/Shape of Transfer View
  final PostDisplayType type;
  const PostItem(this.item, {Key? key, this.type = PostDisplayType.CardItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // @ Build Contact Card by Size
    if (item.payload == Payload.CONTACT) {
      switch (type) {
        case PostDisplayType.CardItem:
          return ContactGridItemView(item);
        case PostDisplayType.ListItem:
          return ContactListItemView(item);
      }
    }

    // @ Build URL Card by Size
    else if (item.payload == Payload.URL) {
      switch (type) {
        case PostDisplayType.CardItem:
          return URLCardItemView(item);
        case PostDisplayType.ListItem:
          return URLListItemView(item);
      }
    }

    // @ Build Media/File Card by Size
    else {
      return PostFileItem(item: item);
    }
  }
}
