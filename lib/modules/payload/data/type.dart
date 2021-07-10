import 'package:sonr_app/style/style.dart';

enum PostItemType { Media, Files, Contacts, Links }

extension PostItemTypeUtils on PostItemType {
  /// Returns List Length as H5 Text
  Widget subtitle() {
    return Container(child: "${this.countString()} Items".light(color: Get.theme.focusColor, align: TextAlign.start));
  }

  /// Gets Count of Items for Type
  int count() {
    switch (this) {
      case PostItemType.Media:
        return CardService.media.length;
      case PostItemType.Files:
        return CardService.files.length;
      case PostItemType.Contacts:
        return CardService.contacts.length;
      case PostItemType.Links:
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
    if (Preferences.isDarkMode) {
      return this.name().light(color: AppColor.White.withOpacity(0.8));
    } else {
      return this.name().light(color: AppColor.Black.withOpacity(0.8));
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
      width: 75,
      height: 75,
    );
  }

  /// Returns Gradient Icon for Type
  Gradient gradient() {
    switch (this) {
      case PostItemType.Media:
        return DesignGradients.PerfectBlue;
      case PostItemType.Files:
        return DesignGradients.ItmeoBranding;
      case PostItemType.Contacts:
        return DesignGradients.AmourAmour;
      case PostItemType.Links:
        return DesignGradients.FrozenHeat;
    }
  }

  /// Returns IconData for Type
  IconData iconData() {
    switch (this) {
      case PostItemType.Media:
        return SimpleIcons.Album;
      case PostItemType.Files:
        return SimpleIcons.Folder;
      case PostItemType.Contacts:
        return SimpleIcons.ContactCard;
      case PostItemType.Links:
        return SimpleIcons.Clip;
    }
  }

  /// Returns Image Path for type
  String imagePath() {
    switch (this) {
      case PostItemType.Media:
        return "assets/images/icons/Gallery.png";
      case PostItemType.Files:
        return "assets/images/icons/Files.png";
      case PostItemType.Contacts:
        return "assets/images/icons/Contacts.png";
      case PostItemType.Links:
        return "assets/images/icons/Links.png";
    }
  }

  /// Return Empty Image Index by Type
  String get emptyLabel => "No ${this.toString().substring(this.toString().indexOf('.') + 1)} yet";

  /// Return Item Count by View Type
  int get itemCount {
    switch (this) {
      case PostItemType.Files:
        return CardService.files.length;
      case PostItemType.Contacts:
        return CardService.contacts.length;
      case PostItemType.Links:
        return CardService.links.length;
      default:
        return CardService.media.length;
    }
  }

  /// Return TransferItem from Index Value
  TransferCard transferItemAtIndex(int index) {
    switch (this) {
      case PostItemType.Files:
        return CardService.files.reversed.toList()[index];
      case PostItemType.Contacts:
        return CardService.contacts.reversed.toList()[index];
      case PostItemType.Links:
        return CardService.links.reversed.toList()[index];
      default:
        return CardService.media.reversed.toList()[index];
    }
  }
}
