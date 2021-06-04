import 'package:sonr_app/modules/card/url/card_item.dart';
import 'package:sonr_app/modules/card/url/grid_item.dart';
import 'package:sonr_app/modules/card/url/list_item.dart';
import 'package:sonr_app/style/style.dart';

import 'contact/card_item.dart';
import 'contact/grid_item.dart';
import 'contact/list_item.dart';
import 'file/card_item.dart';
import 'file/grid_item.dart';
import 'file/list_item.dart';
export 'contact/card_item.dart';
export 'contact/grid_item.dart';
export 'contact/list_item.dart';
export 'file/card_item.dart';
export 'file/grid_item.dart';
export 'file/list_item.dart';
export 'url/card_item.dart';
export 'package:sonr_app/style/style.dart';

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
          return MetaCardItemView(item);
        case CardsViewType.GridItem:
          return MetaGridItemView(item);
        case CardsViewType.ListItem:
          return MetaListItemView(item);
      }
    }
  }
}

extension TransferItemsTypeUtils on TransferItemsType {
  /// Return Empty Image Index by Type
  String get emptyLabel => "No ${this.toString().substring(this.toString().indexOf('.') + 1)} yet";

  /// Return Item Count by View Type
  int get itemCount {
    switch (this) {
      case TransferItemsType.Files:
        return CardService.files.length;
      case TransferItemsType.Contacts:
        return CardService.contacts.length;
      case TransferItemsType.Links:
        return CardService.links.length;
      default:
        return CardService.media.length;
    }
  }

  /// Return TransferItem from Index Value
  TransferCard transferItemAtIndex(int index) {
    switch (this) {
      case TransferItemsType.Files:
        return CardService.files.reversed.toList()[index];
      case TransferItemsType.Contacts:
        return CardService.contacts.reversed.toList()[index];
      case TransferItemsType.Links:
        return CardService.links.reversed.toList()[index];
      default:
        return CardService.media.reversed.toList()[index];
    }
  }
}
