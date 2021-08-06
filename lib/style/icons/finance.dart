import 'icons.dart';

enum FinanceIcons {
  /// ### [Uni_icons: Finance] - BankCardCheckOut
  /// !["Icon of BankCardCheckOut"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-check-ou-lc.svg)
  BankCardCheckOut,

  /// ### [Uni_icons: Finance] - BankCardDownloadOut
  /// !["Icon of BankCardDownloadOut"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-download-ou-lc.svg)
  BankCardDownloadOut,

  /// ### [Uni_icons: Finance] - BankCardAddOut
  /// !["Icon of BankCardAddOut"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-add-ou-lc.svg)
  BankCardAddOut,

  /// ### [Uni_icons: Finance] - BankCardEditOut
  /// !["Icon of BankCardEditOut"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-edit-ou-lc.svg)
  BankCardEditOut,

  /// ### [Uni_icons: Finance] - BankCardExportOut
  /// !["Icon of BankCardExportOut"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-export-ou-lc.svg)
  BankCardExportOut,

  /// ### [Uni_icons: Finance] - BankCardEject
  /// !["Icon of BankCardEject"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-eject.svg)
  BankCardEject,

  /// ### [Uni_icons: Finance] - BankCardFavouriteOut
  /// !["Icon of BankCardFavouriteOut"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-favourite-ou-lc.svg)
  BankCardFavouriteOut,

  /// ### [Uni_icons: Finance] - BankCardInsert
  /// !["Icon of BankCardInsert"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-insert.svg)
  BankCardInsert,

  /// ### [Uni_icons: Finance] - BankCardLockedOut
  /// !["Icon of BankCardLockedOut"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-locked-ou-lc.svg)
  BankCardLockedOut,

  /// ### [Uni_icons: Finance] - BankCardImportOut
  /// !["Icon of BankCardImportOut"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-import-ou-lc.svg)
  BankCardImportOut,

  /// ### [Uni_icons: Finance] - BankCardRemoveOut
  /// !["Icon of BankCardRemoveOut"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-remove-ou-lc.svg)
  BankCardRemoveOut,

  /// ### [Uni_icons: Finance] - BankCardSearchOut
  /// !["Icon of BankCardSearchOut"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-search-ou-lc.svg)
  BankCardSearchOut,

  /// ### [Uni_icons: Finance] - BankCardViewOut
  /// !["Icon of BankCardViewOut"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-view-ou-lc.svg)
  BankCardViewOut,

  /// ### [Uni_icons: Finance] - BankCardUploadOut
  /// !["Icon of BankCardUploadOut"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-upload-ou-lc.svg)
  BankCardUploadOut,

  /// ### [Uni_icons: Finance] - BankCard
  /// !["Icon of BankCard"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card.svg)
  BankCard,

  /// ### [Uni_icons: Finance] - BankCardOff
  /// !["Icon of BankCardOff"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-off.svg)
  BankCardOff,

  /// ### [Uni_icons: Finance] - BankCardSubtractOut
  /// !["Icon of BankCardSubtractOut"](/Users/prad/Sonr/tools/icons/assets/solid/Finance/bank-card-subtract-ou-lc.svg)
  BankCardSubtractOut,
}

extension FinanceUtils on FinanceIcons {
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
