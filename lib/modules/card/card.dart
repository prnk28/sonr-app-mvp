import 'package:sonr_app/modules/card/url/grid_item.dart';
import 'package:sonr_app/modules/card/url/list_item.dart';
import 'contact/card_item.dart';
import 'contact/grid_item.dart';
import 'contact/list_item.dart';
import 'metadata/card_item.dart';
import 'metadata/grid_item.dart';
import 'metadata/list_item.dart';
import 'url/card_item.dart';
import 'package:sonr_app/style/style.dart';

// ^ Card Element/View type Enums ^ //
enum TransferItemsType { All, Metadata, Contacts, Links }
enum TransferItemView { CardItem, GridItem, ListItem }

/// ^ TransferCardView: Builds View based on TransferCardItem Payload Type ^
class TransferItem extends StatelessWidget {
  /// TransferCardItem: SQL Reference to Protobuf
  final TransferCardItem item;

  /// Size/Shape of TransferCard View
  final TransferItemView type;
  const TransferItem(this.item, {Key? key, this.type = TransferItemView.CardItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // @ Build Contact Card by Size
    if (item.payload == Payload.CONTACT) {
      switch (type) {
        case TransferItemView.CardItem:
          return ContactCardItemView(item);
        case TransferItemView.GridItem:
          return ContactGridItemView(item);
        case TransferItemView.ListItem:
          return ContactListItemView(item);
        default:
          return Container();
      }
    }

    // @ Build URL Card by Size
    else if (item.payload == Payload.URL) {
      switch (type) {
        case TransferItemView.CardItem:
          return URLCardItemView(item);
        case TransferItemView.GridItem:
          return URLGridItemView(item);
        case TransferItemView.ListItem:
          return URLListItemView(item);
        default:
          return Container();
      }
    }

    // @ Build Media/File Card by Size
    else {
      switch (type) {
        case TransferItemView.CardItem:
          return MetaCardItemView(item);
        case TransferItemView.GridItem:
          return MetaGridItemView(item);
        case TransferItemView.ListItem:
          return MetaListItemView(item);
        default:
          return Container();
      }
    }
  }
}

extension CardsViewElementTypeUtils on TransferItemsType {
  // @ Return Empty Image Index by Type
  String get emptyLabel => "No ${this.toString().substring(this.toString().indexOf('.') + 1)} yet";

  // @ Return Item Count
  int get itemCount {
    switch (this) {
      case TransferItemsType.Metadata:
        return CardService.metadata.length;

      case TransferItemsType.Contacts:
        return CardService.contacts.length;

      case TransferItemsType.Links:
        return CardService.links.length;

      default:
        return CardService.all.length;
    }
  }

  // @ Return TransferCardItem
  TransferCardItem transferCardItemAtIndex(int index) {
    switch (this) {
      case TransferItemsType.Metadata:
        return CardService.metadata[index];

      case TransferItemsType.Contacts:
        return CardService.contacts[index];

      case TransferItemsType.Links:
        return CardService.links[index];

      default:
        return CardService.all[index];
    }
  }
}

// ^ Card Grid View - By Elements Type ^ //
/// Displays Cards in a Grid Based on Element Type
class CardsGridView extends StatelessWidget {
  final TransferItemsType type;
  CardsGridView({required this.type, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // @ 2. Build View
      if (type.itemCount > 0) {
        return GridView.builder(
          itemCount: type.itemCount,
          itemBuilder: (BuildContext context, int index) {
            return TransferItem(type.transferCardItemAtIndex(index), type: TransferItemView.GridItem);
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        );
      } else {
        return _CardsViewEmpty(type);
      }
    });
  }
}

// ^ Card List View - By Elements Type ^ //
class CardsListView extends StatelessWidget {
  final TransferItemsType type;
  CardsListView({required this.type, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // @ 2. Build View
      if (type.itemCount > 0) {
        return ListView.builder(
          itemCount: type.itemCount,
          itemBuilder: (BuildContext context, int index) {
            return TransferItem(type.transferCardItemAtIndex(index), type: TransferItemView.ListItem);
          },
        );
      } else {
        return _CardsViewEmpty(type);
      }
    });
  }
}

// @ Helper Method to Build Empty List Value
class _CardsViewEmpty extends StatelessWidget {
  final TransferItemsType type;
  const _CardsViewEmpty(this.type, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
        AssetController.getNoFiles(TransferItemsType.values.indexOf(type)),
        type.emptyLabel.p_Grey,
        Padding(padding: EdgeInsets.all(16)),
      ]),
    );
  }
}
