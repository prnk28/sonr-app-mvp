import 'package:sonr_app/pages/detail/detail.dart';
import 'package:sonr_app/style.dart';

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

  /// Returns Error Page for Items Type
  DetailPageType detailsErrorPage() {
    switch (this) {
      case TransferItemsType.Media:
        return DetailPageType.ErrorEmptyMedia;
      case TransferItemsType.Files:
        return DetailPageType.ErrorEmptyFiles;
      case TransferItemsType.Contacts:
        return DetailPageType.ErrorEmptyContacts;
      case TransferItemsType.Links:
        return DetailPageType.ErrorEmptyLinks;
    }
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
      width: 75,
      height: 75,
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

extension TransferActivityUtils on TransferActivity {
  /// Builds Message Text for This Past Activity
  Widget messageText() {
    switch (this.activity) {
      case ActivityType.Deleted:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(),
          this.activity.value.paragraph(color: SonrColor.Critical),
          _description().paragraph()
        ].row();
      case ActivityType.Shared:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(),
          this.activity.value.light(color: SonrColor.Primary),
          _description().paragraph()
        ].row();
      case ActivityType.Received:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(),
          this.activity.value.paragraph(color: SonrColor.Secondary),
          _description().paragraph()
        ].row();
      default:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(),
          this.activity.value.paragraph(color: SonrColor.Grey),
          _description().paragraph()
        ].row(textBaseline: TextBaseline.alphabetic, mainAxisAlignment: MainAxisAlignment.start);
    }
  }

  /// Generates Description from this Activity
  String _description() {
    if (this.payload == Payload.FILES) {
      return " some Files"; //+ " from ${card.owner.firstName}";
    } else if (this.payload == Payload.FILE || this.payload == Payload.MEDIA) {
      return " a " + this.mime.toString().capitalizeFirst!; //+ " from ${card.owner.firstName}";
    } else {
      if (this.payload == Payload.CONTACT) {
        return " a Contact"; // + " from ${card.owner.firstName}";
      }
      return " a Link"; // + " from ${card.owner.firstName}";
    }
  }
}
