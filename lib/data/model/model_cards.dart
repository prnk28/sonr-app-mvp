import 'package:sonr_app/style/style.dart';

enum TransferItemsType { Media, Files, Contacts, Links }

extension TransferItemsTypeUtils on TransferItemsType {
  /// Returns List Length as H5 Text
  Widget subtitle() {
    return Container(child: "${this.countString()} Items".light(color: Get.theme.focusColor, align: TextAlign.start));
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
    return name().subheading();
  }

  /// Returns `name()` for Button Label
  Widget label() {
    if (UserService.isDarkMode) {
      return this.name().light(color: SonrColor.White.withOpacity(0.8));
    } else {
      return this.name().light(color: SonrColor.Black.withOpacity(0.8));
    }
  }

  /// Returns Enum Value as String
  String name() {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }

  /// Returns Icon Widget for Type
  Widget icon() {
    return this.iconData().gradient(value: this.gradient(), size: 52);
  }

  Widget image() {
    return Image.asset(
      this.imagePath(),
      fit: BoxFit.fitHeight,
      width: 100,
      height: 100,
    );
  }

  /// Returns Gradient Icon for Type
  Gradient gradient() {
    switch (this) {
      case TransferItemsType.Media:
        return SonrGradients.PerfectBlue;
      case TransferItemsType.Files:
        return SonrGradients.ItmeoBranding;
      case TransferItemsType.Contacts:
        return SonrGradients.AmourAmour;
      case TransferItemsType.Links:
        return SonrGradients.FrozenHeat;
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

  /// Returns Image Path for type
  String imagePath() {
    switch (this) {
      case TransferItemsType.Media:
        return "assets/images/Gallery.png";
      case TransferItemsType.Files:
        return "assets/images/Files.png";
      case TransferItemsType.Contacts:
        return "assets/images/Contacts.png";
      case TransferItemsType.Links:
        return "assets/images/Links.png";
    }
  }
}
