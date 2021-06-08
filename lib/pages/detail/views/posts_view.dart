import 'package:sonr_app/pages/detail/items/contact/grid_item.dart';
import 'package:sonr_app/pages/detail/items/contact/list_item.dart';
import 'package:sonr_app/pages/detail/items/url/card_item.dart';
import 'package:sonr_app/pages/detail/items/url/list_item.dart';
import 'package:sonr_app/pages/detail/items/post/file_item.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_app/pages/detail/detail.dart';

/// @ Card Element/View type Enums
enum PostItemType { CardItem, ListItem }

//// @ TransferView: Builds View based on TransferItem Payload Type
class TransferCardItem extends StatelessWidget {
  /// TransferItem: SQL Reference to Protobuf
  final TransferCard item;

  /// Size/Shape of Transfer View
  final PostItemType type;
  const TransferCardItem(this.item, {Key? key, this.type = PostItemType.CardItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // @ Build Contact Card by Size
    if (item.payload == Payload.CONTACT) {
      switch (type) {
        case PostItemType.CardItem:
          return ContactGridItemView(item);
        case PostItemType.ListItem:
          return ContactListItemView(item);
      }
    }

    // @ Build URL Card by Size
    else if (item.payload == Payload.URL) {
      switch (type) {
        case PostItemType.CardItem:
          return URLCardItemView(item);
        case PostItemType.ListItem:
          return URLListItemView(item);
      }
    }

    // @ Build Media/File Card by Size
    else {
      return PostFileItem(item: item);
    }
  }
}

class PostsView {
  static Widget display(DetailPageType type, TransferItemsType itemsType) {
    return PostsListView(type: itemsType);
  }
}

/// @ Card List View - By Elements Type
class PostsListView extends StatelessWidget {
  final TransferItemsType type;
  final ScrollController? controller;
  PostsListView({required this.type, this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        controller: controller,
        itemCount: type.itemCount,
        itemBuilder: (BuildContext context, int index) {
          return TransferCardItem(type.transferItemAtIndex(index), type: PostItemType.ListItem);
        },
      );
    });
  }
}
