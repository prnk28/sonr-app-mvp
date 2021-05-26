import 'package:sonr_app/style/style.dart';

enum TransferItemsType { Media, Files, Contacts, Links }

extension TransferItemsTypeUtils on TransferItemsType {
  /// Returns List Length as H5 Text
  Widget subtitle() {
    return Container(child: "${this.countString()} Items".headFive(color: Get.theme.focusColor, weight: FontWeight.w400, align: TextAlign.start));
  }

  /// Gets Count of Items for Type
  int count() {
    switch (this) {
      case TransferItemsType.Media:
        return CardService.media.length;
      case TransferItemsType.Files:
        return CardService.files.length;
      case TransferItemsType.Contacts:
        return CardService.contacts.length;
      case TransferItemsType.Links:
        return CardService.links.length;
    }
  }

  /// Returns Count of Items for Type as String
  String countString() {
    return this.count().toString();
  }

  /// Returns `name()` as H3 Text
  Widget title() {
    return name().h3;
  }

  /// Returns `name()` for Button Label
  Widget label() {
    if (UserService.isDarkMode) {
      return this.name().h6_White;
    } else {
      return this.name().h6;
    }
  }

  /// Returns Enum Value as String
  String name() {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }

  /// Returns Icon Widget for Type
  Widget icon() {
    if (UserService.isDarkMode) {
      return this.iconData().whiteWith(size: 40);
    } else {
      return this.iconData().blackWith(size: 40);
    }
  }

  /// Returns IconData for Type
  IconData iconData() {
    switch (this) {
      case TransferItemsType.Media:
        return SonrIcons.Album;
      case TransferItemsType.Files:
        return SonrIcons.Folder;
      case TransferItemsType.Contacts:
        return SonrIcons.ContactCard;
      case TransferItemsType.Links:
        return SonrIcons.Clip;
    }
  }
}
