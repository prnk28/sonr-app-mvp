import 'package:sonr_app/style/style.dart';

enum TransferItemsType { Media, Files, Contacts, Links }

extension TransferItemsTypeUtils on TransferItemsType {
  /// Returns List Length as H5 Text
  Widget subtitle() {
    switch (this) {
      case TransferItemsType.Media:
        return Container(
            child: CardService.media.length.toString().headFive(color: Get.theme.focusColor, weight: FontWeight.w400, align: TextAlign.start));

      case TransferItemsType.Files:
        return Container(
            child: CardService.files.length.toString().headFive(color: Get.theme.focusColor, weight: FontWeight.w400, align: TextAlign.start));

      case TransferItemsType.Contacts:
        return Container(
            child: CardService.contacts.length.toString().headFive(color: Get.theme.focusColor, weight: FontWeight.w400, align: TextAlign.start));

      case TransferItemsType.Links:
        return Container(
            child: CardService.links.length.toString().headFive(color: Get.theme.focusColor, weight: FontWeight.w400, align: TextAlign.start));
    }
  }

  /// Returns `name()` as H3 Text
  Widget title() {
    return this.toString().substring(this.toString().indexOf('.') + 1).h3;
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
