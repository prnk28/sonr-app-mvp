import 'icons.dart';

enum ShoppingIcons {
  /// ### [Uni_icons: Shopping] - Boxes
  /// !["Icon of Boxes"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/boxes.svg)
  Boxes,

  /// ### [Uni_icons: Shopping] - BadgeDiscount
  /// !["Icon of BadgeDiscount"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/badge-discount.svg)
  BadgeDiscount,

  /// ### [Uni_icons: Shopping] - CouponDiscount
  /// !["Icon of CouponDiscount"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/coupon-discount.svg)
  CouponDiscount,

  /// ### [Uni_icons: Shopping] - Barcode
  /// !["Icon of Barcode"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/barcode.svg)
  Barcode,

  /// ### [Uni_icons: Shopping] - DeliveryTruck
  /// !["Icon of DeliveryTruck"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/delivery-truck.svg)
  DeliveryTruck,

  /// ### [Uni_icons: Shopping] - DoorSign
  /// !["Icon of DoorSign"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/door-sign.svg)
  DoorSign,

  /// ### [Uni_icons: Shopping] - Discount
  /// !["Icon of Discount"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/discount.svg)
  Discount,

  /// ### [Uni_icons: Shopping] - Filter
  /// !["Icon of Filter"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/filter.svg)
  Filter,

  /// ### [Uni_icons: Shopping] - Receipt
  /// !["Icon of Receipt"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/receipt.svg)
  Receipt,

  /// ### [Uni_icons: Shopping] - Megaphone
  /// !["Icon of Megaphone"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/megaphone.svg)
  Megaphone,

  /// ### [Uni_icons: Shopping] - HandCart
  /// !["Icon of HandCart"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/hand-cart.svg)
  HandCart,

  /// ### [Uni_icons: Shopping] - Scan
  /// !["Icon of Scan"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/scan.svg)
  Scan,

  /// ### [Uni_icons: Shopping] - ShoppingBag
  /// !["Icon of ShoppingBag"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/shopping-bag.svg)
  ShoppingBag,

  /// ### [Uni_icons: Shopping] - Shop
  /// !["Icon of Shop"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/shop.svg)
  Shop,

  /// ### [Uni_icons: Shopping] - Gift
  /// !["Icon of Gift"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/gift.svg)
  Gift,

  /// ### [Uni_icons: Shopping] - ShoppingCart
  /// !["Icon of ShoppingCart"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/shopping-cart.svg)
  ShoppingCart,

  /// ### [Uni_icons: Shopping] - ShoppingBasket
  /// !["Icon of ShoppingBasket"](/Users/prad/Sonr/tools/icons/assets/solid/Shopping/shopping-basket.svg)
  ShoppingBasket,
}

extension ShoppingUtils on ShoppingIcons {
  /// Returns Raw Type of Enum
  String get type => this.toString().substring(0, this.toString().indexOf('.'));

  /// Returns Directory of Category
  String get category => this.type.replaceAll('Icons', '');

  /// Returns Raw Value of Enum Type
  String get value => this.toString().substring(this.toString().indexOf('.') + 1);

  /// Returns this Icons File Name
  String get fileName {
    // Set Base Path
    var path = '';

    // Iterate Words
    bool isFirst = true;
    for (var word in this.pascalWords) {
      // Verify Value
      if (word != null) {
        // Check if first element
        if (isFirst) {
          path += cleanWord(word);
          isFirst = false;
        }
        // Add Hyphen for consecutive words
        else {
          path += "-${cleanWord(word)}";
        }
      }
    }

    return path;
  }

  /// Returns Path for this Icon by Fill
  String path(IconFill fill) {
    return 'assets/icons/${category}/${this.fileName}@${fill.name}.svg';
  }

  /// ## (SVG) ChartIcons:DuoTone
  /// Returns SVGPicture Widget, contains all Default properties for SVGPicture package.
  SvgPicture duoTone({
    Key? key,
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture.asset(
      this.path(IconFill.DuoTone),
      color: Get.isDarkMode ? Color(0xffC2C2C2) : null,
      bundle: rootBundle,
      key: key,
      clipBehavior: clipBehavior,
      fit: fit,
      width: width,
      height: height,
      colorBlendMode: BlendMode.overlay,
      alignment: alignment,
    );
  }

  /// ## (SVG) ChartIcons:Line
  /// Returns SVGPicture Widget, contains all Default properties for SVGPicture package.
  SvgPicture line({
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture.asset(
      this.path(IconFill.Line),
      color: Get.isDarkMode ? Color(0xffC2C2C2) : null,
      bundle: rootBundle,
      key: key,
      clipBehavior: clipBehavior,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
    );
  }

  /// ## (SVG) ChartIcons:Solid
  /// Returns SVGPicture Widget, contains all Default properties for SVGPicture package.
  SvgPicture solid({
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture.asset(
      this.path(IconFill.Solid),
      color: Get.isDarkMode ? Color(0xffC2C2C2) : null,
      bundle: rootBundle,
      key: key,
      clipBehavior: clipBehavior,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
    );
  }

  /// Get All pascal words in Enum Value
  List<String?> get pascalWords => K_PASCAL_REGEX.allMatches(this.value).map((m) => m[0]).toList();

  /// #### Constant Regex Expression for Fuzzy Path
  static final K_PASCAL_REGEX = RegExp(r"(?:[A-Z]+|^)[a-z]*");
}
