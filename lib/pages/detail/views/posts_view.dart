import 'package:sonr_app/pages/detail/items/card/url/grid_item.dart';
import 'package:sonr_app/pages/detail/items/card/url/list_item.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_app/pages/detail/detail.dart';

/// @ Card Element/View type Enums
enum CardsViewType { CardItem, GridItem, ListItem }

//// @ TransferView: Builds View based on TransferItem Payload Type
class TransferCardItem extends StatelessWidget {
  /// TransferItem: SQL Reference to Protobuf
  final TransferCard item;

  /// Size/Shape of Transfer View
  final CardsViewType type;
  const TransferCardItem(this.item, {Key? key, this.type = CardsViewType.CardItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // @ Build Contact Card by Size
    if (item.payload == Payload.CONTACT) {
      switch (type) {
        case CardsViewType.CardItem:
          return ContactCardItemView(item);
        case CardsViewType.GridItem:
          return ContactGridItemView(item);
        case CardsViewType.ListItem:
          return ContactListItemView(item);
      }
    }

    // @ Build URL Card by Size
    else if (item.payload == Payload.URL) {
      switch (type) {
        case CardsViewType.CardItem:
          return URLCardItemView(item);
        case CardsViewType.GridItem:
          return URLGridItemView(item);
        case CardsViewType.ListItem:
          return URLListItemView(item);
      }
    }

    // @ Build Media/File Card by Size
    else {
      switch (type) {
        case CardsViewType.CardItem:
          return PostFileItem(item: item);
        case CardsViewType.GridItem:
          return PostFileItem(item: item);
        case CardsViewType.ListItem:
          return PostFileItem(item: item);
      }
    }
  }
}

class PostsView {
  static Widget display(DetailPageType type, TransferItemsType itemsType) {
    return CardsListView(type: itemsType);
  }
}

/// @ Displays Cards in a Grid Based on Element Type
class CardsGridView extends StatelessWidget {
  final TransferItemsType type;
  final ScrollController? controller;
  CardsGridView({required this.type, this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GridView.builder(
        controller: controller,
        itemCount: type.itemCount,
        itemBuilder: (BuildContext context, int index) {
          return TransferCardItem(type.transferItemAtIndex(index), type: CardsViewType.GridItem);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
      );
    });
  }
}

/// @ Card List View - By Elements Type
class CardsListView extends StatelessWidget {
  final TransferItemsType type;
  final ScrollController? controller;
  CardsListView({required this.type, this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        controller: controller,
        itemCount: type.itemCount,
        itemBuilder: (BuildContext context, int index) {
          return TransferCardItem(type.transferItemAtIndex(index), type: CardsViewType.ListItem);
        },
      );
    });
  }
}
